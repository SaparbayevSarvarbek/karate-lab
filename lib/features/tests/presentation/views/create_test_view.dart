import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/remote_image.dart';

/// Yangi test yaratish (Swagger: `POST /tests/` — `name` va `exerciseIds`).
class CreateTestView extends StatefulWidget {
  const CreateTestView({super.key});

  @override
  State<CreateTestView> createState() => _CreateTestViewState();
}

class _CreateTestViewState extends State<CreateTestView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  List<Exercise> _exercises = [];
  final Set<int> _selectedExerciseIds = {};
  bool _loadingExercises = true;
  String? _exercisesError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    final result = await getIt<ExerciseRepository>().getExercises();
    result.fold(
      (e) => setState(() {
        _exercisesError = e.message;
        _loadingExercises = false;
      }),
      (list) => setState(() {
        _exercises = list;
        _loadingExercises = false;
      }),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExerciseIds.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Kamida bitta mashq tanlang'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() => _saving = true);

    final result = await getIt<TestRepository>().createTest(
      CreateTestRequest(
        name: _nameController.text.trim(),
        exerciseIds: _selectedExerciseIds.toList(),
      ),
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
            const SnackBar(
              content: Text('Test muvaffaqiyatli yaratildi!'),
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
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yangi test yaratish'),
        centerTitle: true,
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
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(title: 'Asosiy ma\'lumotlar'),
                      SizedBox(height: 14.h),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Test nomi',
                        prefixIcon: const Icon(Icons.assignment),
                        validator: (v) =>
                            v!.isEmpty ? 'Test nomini kiriting' : null,
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        children: [
                          const _SectionTitle(title: 'Mashqlar'),
                          const Spacer(),
                          Text(
                            '${_selectedExerciseIds.length} ta tanlangan',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (_loadingExercises)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_exercisesError != null)
                        Column(
                          children: [
                            Text(
                              _exercisesError!,
                              style: const TextStyle(color: AppColors.error),
                            ),
                            ElevatedButton(
                              onPressed: _loadExercises,
                              child: const Text('Qayta urinish'),
                            ),
                          ],
                        )
                      else if (_exercises.isEmpty)
                        Text(
                          'Mashqlar kutubxonasi bo\'sh. Avval mashq qo\'shing.',
                          style: TextStyle(color: palette.textSecondary),
                        )
                      else
                        ..._exercises.map(
                          (exercise) => _ExerciseSelectTile(
                            exercise: exercise,
                            selected:
                                _selectedExerciseIds.contains(exercise.id),
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                _selectedExerciseIds.add(exercise.id);
                              } else {
                                _selectedExerciseIds.remove(exercise.id);
                              }
                            }),
                          ),
                        ),
                      SizedBox(height: 26.h),
                      CustomButton(
                        text: 'Testni saqlash',
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: context.palette.textPrimary,
      ),
    );
  }
}

class _ExerciseSelectTile extends StatelessWidget {
  final Exercise exercise;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const _ExerciseSelectTile({
    required this.exercise,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: () => onChanged(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue.withValues(alpha: 0.06)
              : palette.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : palette.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            RemoteImage(
              url: exercise.image,
              width: 52.w,
              height: 52.w,
              borderRadius: BorderRadius.circular(10.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Davomiyligi: ${exercise.durationLabel}',
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 11.5.sp),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primaryBlue : palette.textHint,
              size: 22.w,
            ),
          ],
        ),
      ),
    );
  }
}
