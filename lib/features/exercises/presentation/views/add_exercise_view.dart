import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/media_upload_section.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Yangi mashq qo'shish: nom, yosh, turi (Texnik/UJT/MJT), umumiy rasm,
/// maqsad, sifatlar va har biri nom/tavsif/rasm/takrorlash/vaqtdan iborat
/// bosqichlar.
class AddExerciseView extends StatefulWidget {
  final Exercise? exercise;

  const AddExerciseView({super.key, this.exercise});

  @override
  State<AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends State<AddExerciseView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _goalController = TextEditingController();
  final _qualitiesController = TextEditingController();
  String _selectedCategory = 'UJT';
  bool _saving = false;
  File? _image;
  File? _video;

  final List<_StepDraft> _steps = [];
  final ImagePicker _picker = ImagePicker();
  bool _stepBusy = false;

  List<String> _categories = const ['Texnik', 'UJT', 'MJT'];

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    if (exercise != null) {
      _nameController.text = exercise.title;
      _ageController.text = exercise.age;
      _goalController.text = exercise.goal;
      _qualitiesController.text = exercise.qualities.join(', ');
      _selectedCategory = exercise.category;
      _steps.addAll(exercise.steps.map(_StepDraft.fromExerciseStep));
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await getIt<ExerciseRepository>().getCategories();
    if (!mounted) return;
    result.fold((_) {}, (categories) {
      if (categories.isNotEmpty) {
        setState(() {
          _categories = categories.map((c) => c.name).toList();
          if (_selectedCategory.isNotEmpty &&
              !_categories.contains(_selectedCategory)) {
            _categories.add(_selectedCategory);
          }
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
    for (final s in _steps) {
      s.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() => _steps.add(_StepDraft()));
  }

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index).dispose());
  }

  Future<void> _pickStepImage(int index) async {
    if (_stepBusy) return;
    setState(() => _stepBusy = true);
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
      );
      if (picked != null && mounted) {
        setState(() {
          _steps[index].image = File(picked.path);
          _steps[index].imageUrl = null;
        });
      }
    } catch (_) {
      _showToast(Tr.t('imagePickError'));
    } finally {
      if (mounted) setState(() => _stepBusy = false);
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    AppSnackbar.error(context, message);
  }

  List<String> get _qualities => _qualitiesController.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    if (_steps.isEmpty) {
      _showToast(Tr.t('addStepRequired'));
      return;
    }

    setState(() => _saving = true);

    final request = CreateExerciseRequest(
      title: _nameController.text.trim(),
      duration: widget.exercise?.duration ?? 0,
      description: widget.exercise?.description ?? '',
      category: _selectedCategory,
      age: _ageController.text.trim(),
      goal: _goalController.text.trim(),
      qualities: _qualities,
    );

    final stepInputs = <ExerciseStepInput>[];
    final stepFiles = <File?>[];
    for (final s in _steps) {
      stepInputs.add(
        ExerciseStepInput(
          id: s.id,
          title: s.title.text.trim(),
          description: s.description.text.trim(),
          repetitions: s.repetitions.text.trim(),
          rest: s.rest.text.trim(),
          duration: int.tryParse(s.duration.text.trim()) ?? 0,
        ),
      );
      stepFiles.add(s.image);
    }

    final repository = getIt<ExerciseRepository>();
    final result = _isEditing
        ? await repository.updateExercise(
            widget.exercise!.id,
            request,
            image: _image,
            video: _video,
            steps: stepInputs,
            stepImages: stepFiles,
          )
        : await repository.createExercise(
            request,
            image: _image,
            video: _video,
            category: _selectedCategory,
            age: _ageController.text.trim(),
            goal: _goalController.text.trim(),
            qualities: _qualities,
            steps: stepInputs,
            stepImages: stepFiles,
          );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _saving = false);
        AppSnackbar.error(context, error.message);
      },
      (savedExercise) {
        AppSnackbar.success(
          context,
          Tr.t(_isEditing ? 'exerciseUpdatedSuccess' : 'exerciseAddedSuccess'),
        );
        if (_isEditing) {
          context.pop<Exercise>(savedExercise);
          return;
        }
        final navigator = Navigator.of(context);
        navigator.popUntil((route) => route is! PopupRoute);
        if (!mounted) return;
        navigator.pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: KarateAppBar(
        title: Tr.t(_isEditing ? 'editExerciseTitle' : 'addExerciseTitle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenH.w,
            AppSpacing.screenTop.h,
            AppSpacing.screenH.w,
            AppSpacing.xxl.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(title: Tr.t('addCoverImage')),
                      SizedBox(height: AppSpacing.md.h),
                      MediaUploadSection(
                        onImagePicked: (f) => setState(() => _image = f),
                        onVideoPicked: (f) => setState(() => _video = f),
                        initialImageUrl: widget.exercise?.image,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                AppCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: Tr.t('exerciseNameHint'),
                        prefixIcon: const Icon(Icons.fitness_center),
                        validator: (v) => (v == null || v.isEmpty)
                            ? Tr.t('nameRequired')
                            : null,
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      CustomTextField(
                        controller: _ageController,
                        hintText: Tr.t('ageRangeHint'),
                        prefixIcon: const Icon(Icons.cake_outlined),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      AddExerciseDropdown(
                        label: Tr.t('exerciseType'),
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (v) =>
                            setState(() => _selectedCategory = v!),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      CustomTextField(
                        controller: _goalController,
                        hintText: Tr.t('goalHint'),
                        prefixIcon: const Icon(Icons.flag_outlined),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      CustomTextField(
                        controller: _qualitiesController,
                        hintText: Tr.t('qualitiesHint'),
                        prefixIcon: const Icon(Icons.stars_outlined),
                      ),
                    ],
                  ),
                ),

                // ── Bosqichlar (steps) ────────────────────────────────
                SizedBox(height: AppSpacing.sectionGap.h),
                AppSectionHeader(title: Tr.t('stepsTitle')),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  Tr.t('stepsHint'),
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                for (var i = 0; i < _steps.length; i++) ...[
                  SizedBox(height: AppSpacing.md.h),
                  _StepCard(
                    index: i + 1,
                    draft: _steps[i],
                    busy: _stepBusy,
                    onImageTap: () => _pickStepImage(i),
                    onRemove: () => _removeStep(i),
                  ),
                ],
                SizedBox(height: AppSpacing.md.h),
                _AddStepButton(onTap: _addStep),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        child: CustomButton(
          text: _saving
              ? Tr.t('saving')
              : Tr.t(_isEditing ? 'saveChanges' : 'saveExercise'),
          isLoading: _saving,
          onPressed: _save,
        ),
      ),
    );
  }
}

/// Bosqich qo'shish tugmasi — 52 balandlikdagi konturli amal.
class _AddStepButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddStepButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.card.r);
    return Material(
      color: AppColors.primaryBlue.withValues(alpha: 0.08),
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: AppColors.primaryBlue, size: 20.w),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                Tr.t('addStep'),
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddExerciseDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const AddExerciseDropdown({
    super.key,
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
      style: AppTextStyles.body.copyWith(color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          borderSide: BorderSide(color: palette.border),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(value: e, child: Text(Tr.categoryName(e))),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Bosqich (step) yaratish formasi uchun doimiy controllerlar to'plami.
class _StepDraft {
  final int? id;
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController repetitions = TextEditingController();
  final TextEditingController rest = TextEditingController();
  final TextEditingController duration = TextEditingController();
  File? image;

  _StepDraft({this.id});
  String? imageUrl;

  factory _StepDraft.fromExerciseStep(ExerciseStep step) {
    final draft = _StepDraft(id: step.id);
    draft.imageUrl = step.imageUrl;
    draft.title.text = step.title;
    draft.description.text = step.description;
    draft.repetitions.text = step.repetitions;
    draft.rest.text = step.rest;
    draft.duration.text = '${step.duration}';
    return draft;
  }

  void dispose() {
    title.dispose();
    description.dispose();
    repetitions.dispose();
    rest.dispose();
    duration.dispose();
  }
}

/// Bitta bosqich kartasi — nom, tavsif, takrorlash, dam olish, vaqt + rasm.
class _StepCard extends StatelessWidget {
  final int index;
  final _StepDraft draft;
  final bool busy;
  final VoidCallback onImageTap;
  final VoidCallback onRemove;

  const _StepCard({
    required this.index,
    required this.draft,
    required this.busy,
    required this.onImageTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.tile.r),
                ),
                child: Text(
                  '$index',
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Text(
                  Tr.t('stepLabel', {'index': '$index'}),
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                tooltip: Tr.t('delete'),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: palette.error,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          CustomTextField(
            controller: draft.title,
            hintText: Tr.t('stepNameHint'),
            prefixIcon: const Icon(Icons.title),
          ),
          SizedBox(height: AppSpacing.md.h),
          TextFormField(
            controller: draft.description,
            maxLines: 3,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            style: AppTextStyles.body.copyWith(color: palette.textPrimary),
            decoration: InputDecoration(
              hintText: Tr.t('stepDescriptionHint'),
              hintStyle: AppTextStyles.body.copyWith(color: palette.textHint),
              filled: true,
              fillColor: palette.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                borderSide: BorderSide(color: palette.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                borderSide: BorderSide(color: palette.border),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: draft.repetitions,
                  hintText: Tr.t('repetitionsHint'),
                  prefixIcon: const Icon(Icons.repeat_rounded),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
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
          SizedBox(height: AppSpacing.md.h),
          CustomTextField(
            controller: draft.rest,
            hintText: Tr.t('restHint'),
            prefixIcon: const Icon(Icons.self_improvement_rounded),
          ),
          SizedBox(height: AppSpacing.md.h),
          GestureDetector(
            onTap: busy ? null : onImageTap,
            child: Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: palette.backgroundLight,
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                border: Border.all(
                  color: draft.image != null || draft.imageUrl != null
                      ? AppColors.primaryBlue
                      : palette.border,
                ),
                image: draft.image != null
                    ? DecorationImage(
                        image: FileImage(draft.image!),
                        fit: BoxFit.cover,
                      )
                    : draft.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(
                          ApiConstants.resolveMediaUrl(draft.imageUrl!),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: draft.image == null && draft.imageUrl == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 36.w,
                            color: palette.textHint,
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(
                            Tr.t('addImageOptional'),
                            style: AppTextStyles.caption.copyWith(
                              color: palette.textHint,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        margin: EdgeInsets.all(AppSpacing.sm.w),
                        padding: EdgeInsets.all(AppSpacing.xs.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14.w,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
