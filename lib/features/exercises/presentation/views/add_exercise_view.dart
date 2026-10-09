import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/media_upload_section.dart';

/// Yangi mashq qo'shish: nom, yosh, turi (Texnik/UJT/MJT), umumiy rasm,
/// maqsad, sifatlar va har biri nom/tavsif/rasm/takrorlash/vaqtdan iborat
/// bosqichlar.
class AddExerciseView extends StatefulWidget {
  const AddExerciseView({super.key});

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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await getIt<ExerciseRepository>().getCategories();
    if (!mounted) return;
    result.fold(
      (_) {},
      (categories) {
        if (categories.isNotEmpty) {
          setState(() {
            _categories = categories.map((c) => c.name).toList();
            if (!_categories.contains(_selectedCategory)) {
              _selectedCategory = _categories.first;
            }
          });
        }
      },
    );
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
      final picked =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
      if (picked != null && mounted) {
        setState(() => _steps[index].image = File(picked.path));
      }
    } catch (_) {
      _showToast(Tr.t('imagePickError'));
    } finally {
      if (mounted) setState(() => _stepBusy = false);
    }
  }

  void _showToast(String message) {
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
      _showToast(Tr.t('addStepRequired'));
      return;
    }

    setState(() => _saving = true);

    final request = CreateExerciseRequest(
      title: _nameController.text.trim(),
      category: _selectedCategory,
      age: _ageController.text.trim(),
      goal: _goalController.text.trim(),
      qualities: _qualities,
    );

    final stepInputs = <ExerciseStepInput>[];
    final stepFiles = <File?>[];
    for (final s in _steps) {
      stepInputs.add(ExerciseStepInput(
        title: s.title.text.trim(),
        description: s.description.text.trim(),
        repetitions: s.repetitions.text.trim(),
        rest: s.rest.text.trim(),
        duration: int.tryParse(s.duration.text.trim()) ?? 0,
      ));
      stepFiles.add(s.image);
    }

    final result = await getIt<ExerciseRepository>().createExercise(
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      (_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(Tr.t('exerciseAddedSuccess')),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
      appBar: AppBar(
        title: Text(Tr.t('addExerciseTitle')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaUploadSection(
                  onImagePicked: (f) => setState(() => _image = f),
                  onVideoPicked: (f) => setState(() => _video = f),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: Tr.t('exerciseNameHint'),
                  prefixIcon: const Icon(Icons.fitness_center),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? Tr.t('nameRequired') : null,
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _ageController,
                  hintText: Tr.t('ageRangeHint'),
                  prefixIcon: const Icon(Icons.cake_outlined),
                ),
                SizedBox(height: 14.h),
                AddExerciseDropdown(
                  label: Tr.t('exerciseType'),
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _goalController,
                  hintText: Tr.t('goalHint'),
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _qualitiesController,
                  hintText: Tr.t('qualitiesHint'),
                  prefixIcon: const Icon(Icons.stars_outlined),
                ),

                // ── Bosqichlar (steps) ────────────────────────────────
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Icon(Icons.format_list_numbered_rounded,
                        size: 20.w, color: AppColors.primaryBlue),
                    SizedBox(width: 8.w),
                    Text(
                      Tr.t('stepsTitle'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
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
                    busy: _stepBusy,
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
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primaryBlue),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded,
                            color: AppColors.primaryBlue, size: 20.w),
                        SizedBox(width: 6.w),
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

                SizedBox(height: 26.h),
                CustomButton(
                  text: _saving ? Tr.t('saving') : Tr.t('saveExercise'),
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
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
      style: TextStyle(fontSize: 14.sp, color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Bosqich (step) yaratish formasi uchun doimiy controllerlar to'plami.
class _StepDraft {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController repetitions = TextEditingController();
  final TextEditingController rest = TextEditingController();
  final TextEditingController duration = TextEditingController();
  File? image;

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
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14.r),
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
          SizedBox(height: 10.h),
          CustomTextField(
            controller: draft.title,
            hintText: Tr.t('stepNameHint'),
            prefixIcon: const Icon(Icons.title),
          ),
          SizedBox(height: 10.h),
          TextFormField(
            controller: draft.description,
            maxLines: 3,
            style: TextStyle(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: Tr.t('stepDescriptionHint'),
              filled: true,
              fillColor: palette.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: draft.repetitions,
                  hintText: Tr.t('repetitionsHint'),
                  prefixIcon: const Icon(Icons.repeat_rounded),
                ),
              ),
              SizedBox(width: 10.w),
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
          SizedBox(height: 10.h),
          CustomTextField(
            controller: draft.rest,
            hintText: Tr.t('restHint'),
            prefixIcon: const Icon(Icons.self_improvement_rounded),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: busy ? null : onImageTap,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: palette.backgroundLight,
                borderRadius: BorderRadius.circular(10.r),
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
                          SizedBox(height: 6.h),
                          Text(
                            Tr.t('addImageOptional'),
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.all(6.w),
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