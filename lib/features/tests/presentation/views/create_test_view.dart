import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/karate_app_bar.dart';

/// Yangi test yaratish: nom, umumiy rasm, yoshlar, kategoriya va
/// har biri nom/tavsif/rasm/takrorlash/vaqtdan iborat qadamlar.
class CreateTestView extends StatefulWidget {
  const CreateTestView({super.key});

  @override
  State<CreateTestView> createState() => _CreateTestViewState();
}

class _CreateTestViewState extends State<CreateTestView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _goalController = TextEditingController();
  final _qualitiesController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'UJT';
  List<String> _categories = const ['Texnik', 'UJT', 'MJT'];

  File? _cover;
  final List<_StepDraft> _steps = [];
  final ImagePicker _picker = ImagePicker();
  bool _saving = false;
  bool _pickingCover = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await getIt<ExerciseRepository>().getCategories();
    if (!mounted) return;
    result.fold((_) {}, (categories) {
      if (categories.isNotEmpty) {
        setState(() {
          _categories = categories.map((c) => c.name).toList();
          if (!_categories.contains(_selectedCategory)) {
            _selectedCategory = _categories.first;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    _qualitiesController.dispose();
    _descriptionController.dispose();
    for (final s in _steps) {
      s.dispose();
    }
    super.dispose();
  }

  void _addStep() => setState(() => _steps.add(_StepDraft()));

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index).dispose());
  }

  Future<void> _pickCover() async {
    if (_pickingCover) return;
    setState(() => _pickingCover = true);
    try {
      final picked =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
      if (picked != null && mounted) {
        setState(() => _cover = File(picked.path));
      }
    } catch (_) {
      _toast(Tr.t('imagePickError'));
    } finally {
      if (mounted) setState(() => _pickingCover = false);
    }
  }

  Future<void> _pickStepImage(int index) async {
    try {
      final picked =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
      if (picked != null && mounted) {
        setState(() => _steps[index].image = File(picked.path));
      }
    } catch (_) {
      _toast(Tr.t('imagePickError'));
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  List<String> get _qualities => _qualitiesController.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    if (_steps.isEmpty) {
      _toast(Tr.t('addStepRequired'));
      return;
    }

    setState(() => _saving = true);

    final request = CreateTestRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      age: _ageController.text.trim(),
      goal: _goalController.text.trim(),
      qualities: _qualities,
    );

    final stepInputs = <TestStepInput>[];
    final stepFiles = <File?>[];
    for (final s in _steps) {
      stepInputs.add(TestStepInput(
        title: s.title.text.trim(),
        description: s.description.text.trim(),
        repetitions: s.repetitions.text.trim(),
        duration: int.tryParse(s.duration.text.trim()) ?? 0,
      ));
      stepFiles.add(s.image);
    }

    final result = await getIt<TestRepository>().createTest(
      request,
      cover: _cover,
      steps: stepInputs,
      stepImages: stepFiles,
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _saving = false);
        _toast(error.message);
      },
      (_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(Tr.t('testCreatedSuccess')),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        context.pop<bool>(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: KarateAppBar(title: Tr.t('createTestTitle')),
      bottomNavigationBar: _saving
          ? null
          : AppBottomBar(
              child: CustomButton(
                text: Tr.t('saveTest'),
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _save,
              ),
            ),
      body: SafeArea(
        child: _saving
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Test yaratilmoqda...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CoverPicker(
                        cover: _cover,
                        busy: _pickingCover,
                        onTap: _pickCover,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: _nameController,
                        hintText: Tr.t('testNameHint'),
                        prefixIcon: const Icon(Icons.assignment),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? Tr.t('testNameRequired') : null,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _ageController,
                        hintText: Tr.t('ageRangeHint'),
                        prefixIcon: const Icon(Icons.cake_outlined),
                      ),
                      SizedBox(height: 16.h),
                      _Dropdown(
                        label: Tr.t('categoryLabel'),
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _goalController,
                        hintText: Tr.t('goalHint'),
                        prefixIcon: const Icon(Icons.flag_outlined),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _qualitiesController,
                        hintText: Tr.t('qualitiesHint'),
                        prefixIcon: const Icon(Icons.stars_outlined),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _descriptionController,
                        hintText: Tr.t('descriptionOptional'),
                        prefixIcon: const Icon(Icons.subject_outlined),
                      ),

                      // ── Qadamlar ─────────────────────────────────────
                      SizedBox(height: 24.h),
                      AppSectionHeader(title: Tr.t('stepsTitle')),
                      SizedBox(height: 8.h),
                      Text(
                        Tr.t('stepsHint'),
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12.5.sp),
                      ),
                      for (var i = 0; i < _steps.length; i++) ...[
                        SizedBox(height: 12.h),
                        _StepCard(
                          index: i + 1,
                          draft: _steps[i],
                          onImageTap: () => _pickStepImage(i),
                          onRemove: () => _removeStep(i),
                        ),
                      ],
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: _addStep,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.button.r),
                            border: Border.all(color: AppColors.primaryBlue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: AppColors.primaryBlue, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                Tr.t('addStep'),
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _CoverPicker extends StatelessWidget {
  final File? cover;
  final bool busy;
  final VoidCallback onTap;

  const _CoverPicker({
    required this.cover,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        height: 170.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(
            color: cover != null ? AppColors.primaryBlue : AppColors.border,
          ),
          image: cover != null
              ? DecorationImage(image: FileImage(cover!), fit: BoxFit.cover)
              : null,
        ),
        child: cover == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 40.w, color: AppColors.textHint),
                    SizedBox(height: 8.h),
                    Text(
                      Tr.t('addCoverImage'),
                      style: TextStyle(color: AppColors.textHint, fontSize: 13.sp),
                    ),
                  ],
                ),
              )
            : Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 16.w),
                ),
              ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      style: TextStyle(fontSize: 14.sp, color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

class _StepDraft {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController repetitions = TextEditingController();
  final TextEditingController duration = TextEditingController();
  File? image;

  void dispose() {
    title.dispose();
    description.dispose();
    repetitions.dispose();
    duration.dispose();
  }
}

class _StepCard extends StatelessWidget {
  final int index;
  final _StepDraft draft;
  final VoidCallback onImageTap;
  final VoidCallback onRemove;

  const _StepCard({
    required this.index,
    required this.draft,
    required this.onImageTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  Tr.t('stepLabel', {'index': '$index'}),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.delete_outline_rounded,
                    color: AppColors.error, size: 20.w),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: draft.title,
            hintText: Tr.t('stepNameHint'),
            prefixIcon: const Icon(Icons.title),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: draft.description,
            maxLines: 3,
            style: TextStyle(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: Tr.t('stepDescriptionHint'),
              filled: true,
              fillColor: palette.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: draft.repetitions,
                  hintText: Tr.t('repetitionsHint'),
                  prefixIcon: const Icon(Icons.repeat_rounded),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  controller: draft.duration,
                  hintText: Tr.t('durationHint'),
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.timer_outlined),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: palette.backgroundLight,
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                border: Border.all(
                  color: draft.image != null
                      ? AppColors.primaryBlue
                      : AppColors.border,
                ),
                image: draft.image != null
                    ? DecorationImage(
                        image: FileImage(draft.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: draft.image == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 36.w, color: AppColors.textHint),
                          SizedBox(height: 8.h),
                          Text(
                            Tr.t('addImageOptional'),
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    )
                  : Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        margin: EdgeInsets.all(8.w),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit,
                            color: Colors.white, size: 14.w),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}