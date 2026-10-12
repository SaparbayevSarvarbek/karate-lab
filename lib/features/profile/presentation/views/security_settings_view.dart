import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/settings_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_step_badge.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/karate_app_bar.dart';

/// Xavfsizlik sozlamalari (Swagger: `PUT /settings/password/`,
/// `GET/DELETE /security/sessions/`, `DELETE /security/sessions/{id}/`).
class SecuritySettingsView extends StatefulWidget {
  const SecuritySettingsView({super.key});

  @override
  State<SecuritySettingsView> createState() => _SecuritySettingsViewState();
}

class _SecuritySettingsViewState extends State<SecuritySettingsView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  List<UserSession> _sessions = [];
  bool _sessionsLoading = true;
  bool _sessionsBusy = false;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    final result = await getIt<SettingsRepository>().getSessions();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _sessionsLoading = false),
      (sessions) => setState(() {
        _sessions = sessions;
        _sessionsLoading = false;
      }),
    );
  }

  Future<void> _deleteSession(UserSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(Tr.t('endSessionTitle')),
        content: Text(Tr.t('endSessionText', {'device': session.deviceInfo})),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(Tr.t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              Tr.t('signOutDevice'),
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final result = await getIt<SettingsRepository>().deleteSession(session.id);
    if (!mounted) return;
    result.fold(
      (error) => _showSnackBar(error.message, AppColors.error),
      (_) {
        _showSnackBar(Tr.t('sessionEnded'), AppColors.success);
        setState(() {
          _sessions.removeWhere((s) => s.id == session.id);
        });
      },
    );
  }

  Future<void> _logoutOtherDevices() async {
    if (_sessionsBusy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(Tr.t('logOutOthersTitle')),
        content: Text(Tr.t('logOutOthersText')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Tr.t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              Tr.t('signOutDevice'),
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _sessionsBusy = true);
    final result = await getIt<SettingsRepository>().logoutOtherDevices();
    if (!mounted) return;
    setState(() => _sessionsBusy = false);
    result.fold(
      (error) => _showSnackBar(error.message, AppColors.error),
      (_) {
        _showSnackBar(Tr.t('sessionsEndedAll'), AppColors.success);
        setState(() {
          _sessions = [];
          _sessionsLoading = true;
        });
        _loadSessions();
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    final result = await getIt<SettingsRepository>().changePassword(
      ChangePasswordRequest(
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _saving = false);
        _showSnackBar(error.message, AppColors.error);
      },
      (_) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        setState(() => _saving = false);
        _showSnackBar(Tr.t('passwordUpdated'), AppColors.success);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: KarateAppBar(title: Tr.t('menuSecurity')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenH.w,
          AppSpacing.sm.h,
          AppSpacing.screenH.w,
          AppSpacing.xxl.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecurityUpdatePasswordSection(),
            SizedBox(height: AppSpacing.md.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SecurityPasswordField(
                    controller: _currentPasswordController,
                    hint: Tr.t('currentPassword'),
                    obscure: _obscureCurrent,
                    onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    validator: (v) => v!.isEmpty ? Tr.t('enterCurrentPassword') : null,
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  SecurityPasswordField(
                    controller: _newPasswordController,
                    hint: Tr.t('newPassword'),
                    obscure: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    validator: (v) {
                      if (v == null || v.isEmpty) return Tr.t('enterNewPassword');
                      if (v.length < 6) return Tr.t('passwordMin');
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  SecurityPasswordField(
                    controller: _confirmPasswordController,
                    hint: Tr.t('confirmPassword'),
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) {
                      if (v != _newPasswordController.text) return Tr.t('passwordMismatch');
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            CustomButton(
              text: _saving ? Tr.t('updating') : Tr.t('updatePasswordBtn'),
              isLoading: _saving,
              onPressed: _changePassword,
              leadingIcon: Icons.lock_reset_rounded,
            ),
            SizedBox(height: AppSpacing.xxxl.h),
            _ActiveSessionsSection(
              sessions: _sessions,
              loading: _sessionsLoading,
              busy: _sessionsBusy,
              onLogoutOthers: _logoutOtherDevices,
              onDeleteSession: _deleteSession,
            ),
            SizedBox(height: AppSpacing.xxxl.h),
            const SecurityDeleteAccountSection(),
          ],
        ),
      ),
    );
  }
}

class SecurityUpdatePasswordSection extends StatelessWidget {
  const SecurityUpdatePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: Tr.t('updatePasswordBtn')),
        SizedBox(height: 4.h),
        Text(
          Tr.t('secUpdateHint'),
          style: AppTextStyles.caption
              .copyWith(color: context.palette.textSecondary),
        ),
      ],
    );
  }
}

class SecurityPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const SecurityPasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      obscureText: obscure,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint),
        onPressed: onToggle,
      ),
      validator: validator,
    );
  }
}

class SecurityDeleteAccountSection extends StatelessWidget {
  const SecurityDeleteAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: 'Xavfli zona'),
        SizedBox(height: AppSpacing.md.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.lg.w),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppRadius.card.r),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      Tr.t('deleteAccountText'),
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(context: context, builder: (_) => const SecurityDeleteDialog());
                },
                icon: Icon(Icons.delete_forever_rounded,
                    color: AppColors.error, size: 18.w),
                label: Text(
                  Tr.t('deleteAccountTitle'),
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.6)),
                  minimumSize: Size(double.infinity, 52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecurityDeleteDialog extends StatelessWidget {
  const SecurityDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Tr.t('deleteAccountTitle')),
      content: Text(Tr.t('deleteAccountText')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(Tr.t('cancel'))),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Tr.t('delete'), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _ActiveSessionsSection extends StatelessWidget {
  final List<UserSession> sessions;
  final bool loading;
  final bool busy;
  final VoidCallback onLogoutOthers;
  final Future<void> Function(UserSession) onDeleteSession;

  const _ActiveSessionsSection({
    required this.sessions,
    required this.loading,
    required this.busy,
    required this.onLogoutOthers,
    required this.onDeleteSession,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}'
        '.${local.month.toString().padLeft(2, '0')}.${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: Tr.t('activeSessions'),
          actionLabel: busy ? Tr.t('signingOut') : Tr.t('logOutOthersBtn'),
          onAction: (busy || loading || sessions.length < 2)
              ? null
              : onLogoutOthers,
        ),
        SizedBox(height: 4.h),
        Text(
          Tr.t('swipeHint'),
          style: AppTextStyles.caption.copyWith(color: palette.textHint),
        ),
        SizedBox(height: AppSpacing.md.h),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (sessions.isEmpty)
          AppEmptyView(
            icon: Icons.devices_other_outlined,
            title: Tr.t('noSessions'),
            compact: true,
          )
        else
          ...sessions.map(
            (s) => _SwipeableSessionTile(
              session: s,
              formatDate: _formatDate,
              onDelete: () => onDeleteSession(s),
            ),
          ),
      ],
    );
  }
}

class _SwipeableSessionTile extends StatefulWidget {
  final UserSession session;
  final String Function(DateTime?) formatDate;
  final Future<void> Function() onDelete;

  const _SwipeableSessionTile({
    required this.session,
    required this.formatDate,
    required this.onDelete,
  });

  @override
  State<_SwipeableSessionTile> createState() => _SwipeableSessionTileState();
}

class _SwipeableSessionTileState extends State<_SwipeableSessionTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.session.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await widget.onDelete();
        return false;
      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.card.r),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: _SessionTile(session: widget.session, formatDate: widget.formatDate),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final UserSession session;
  final String Function(DateTime?) formatDate;

  const _SessionTile({required this.session, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = session.isActive ? AppColors.success : palette.textHint;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.smartphone_rounded, size: 20.w, color: tint),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.deviceInfo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  [
                    if (session.ipAddress != null && session.ipAddress!.isNotEmpty)
                      session.ipAddress!,
                    if (session.createdAt != null)
                      formatDate(session.createdAt),
                  ].join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption
                      .copyWith(color: palette.textSecondary),
                ),
              ],
            ),
          ),
          if (session.isActive) ...[
            SizedBox(width: 8.w),
            AppStepBadge(
              label: Tr.t('activeBadge'),
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}
