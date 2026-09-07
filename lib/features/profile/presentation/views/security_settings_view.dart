import 'package:flutter/material.dart';

import '../../../../core/api/models/settings_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

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
      appBar: AppBar(
        title: Text(Tr.t('menuSecurity')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecurityUpdatePasswordSection(),
            const SizedBox(height: 24),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            CustomButton(
              text: _saving ? Tr.t('updating') : Tr.t('updatePasswordBtn'),
              isLoading: _saving,
              onPressed: _changePassword,
            ),
            const SizedBox(height: 32),
            _ActiveSessionsSection(
              sessions: _sessions,
              loading: _sessionsLoading,
              busy: _sessionsBusy,
              onLogoutOthers: _logoutOtherDevices,
              onDeleteSession: _deleteSession,
            ),
            const SizedBox(height: 40),
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
        Text(Tr.t('updatePasswordBtn'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(Tr.t('secUpdateHint'), style: Theme.of(context).textTheme.bodyMedium),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.t('deleteAccountTitle'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            showDialog(context: context, builder: (_) => const SecurityDeleteDialog());
          },
          icon: const Icon(Icons.delete_forever, color: AppColors.error),
          label: Text(Tr.t('deleteAccountTitle'), style: const TextStyle(color: AppColors.error)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.error),
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        Row(
          children: [
            Expanded(
              child: Text(
                Tr.t('activeSessions'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: busy || loading || sessions.length < 2 ? null : onLogoutOthers,
              child: Text(
                busy ? Tr.t('signingOut') : Tr.t('logOutOthersBtn'),
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          Tr.t('swipeHint'),
          style: TextStyle(color: palette.textHint, fontSize: 11.5),
        ),
        const SizedBox(height: 10),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (sessions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.backgroundLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.border),
            ),
            child: Text(
              Tr.t('noSessions'),
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
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
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: session.isActive
                  ? AppColors.success.withValues(alpha: 0.12)
                  : palette.textHint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smartphone_rounded,
              size: 18,
              color: session.isActive ? AppColors.success : palette.textHint,
            ),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 13,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (session.ipAddress != null && session.ipAddress!.isNotEmpty)
                      session.ipAddress!,
                    if (session.createdAt != null)
                      formatDate(session.createdAt),
                  ].join(' • '),
                  style: TextStyle(color: palette.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          if (session.isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                Tr.t('activeBadge'),
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
