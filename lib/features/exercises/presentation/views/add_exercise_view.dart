import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/media_upload_section.dart';

class AddExerciseView extends StatefulWidget {
  const AddExerciseView({super.key});

  @override
  State<AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends State<AddExerciseView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedCategory = 'Zarba texnikasi';
  bool _saving = false;
  File? _image;
  File? _video;

  final List<String> _categories = [
    'Zarba texnikasi',
    'Himoya texnikasi',
    'Tepish texnikasi',
    'Kata',
    'Kumite',
    'Dachi (turishlar)',
    'Umumiy jismoniy',
    'Texnika',
    'Chidamlilik',
    'Egiluvchanlik',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    final durationMinutes = int.parse(_durationController.text.trim());
    final request = CreateExerciseRequest(
      title: _nameController.text.trim(),
      duration: durationMinutes * 60,
      description: _descriptionController.text.trim(),
    );

    final result = await getIt<ExerciseRepository>().createExercise(
      request,
      image: _image,
      video: _video,
      category: _selectedCategory,
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
              content: Text('Mashq muvaffaqiyatli qo\'shildi!'),
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
        title: const Text('Yangi mashq qo\'shish'),
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
                  hintText: 'Mashq nomi',
                  prefixIcon: const Icon(Icons.fitness_center),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nom kiriting' : null,
                ),
                SizedBox(height: 14.h),
                AddExerciseDropdown(
                  label: 'Kategoriya',
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
                SizedBox(height: 14.h),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    labelText: 'Vaqt (daqiqa)',
                    hintText: 'Masalan: 5',
                    prefixIcon: const Icon(Icons.timer_outlined),
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
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Vaqtni kiriting';
                    final val = int.tryParse(v.trim());
                    if (val == null || val <= 0) return 'To\'g\'ri vaqt kiriting';
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Mashq tavsifi...',
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
                ),
                SizedBox(height: 26.h),
                CustomButton(
                  text: _saving ? 'Saqlanmoqda...' : 'Mashqni saqlash',
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
