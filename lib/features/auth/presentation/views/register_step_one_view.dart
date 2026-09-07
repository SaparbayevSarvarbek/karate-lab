import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/phone_text_field.dart';

class RegisterStepOneView extends StatefulWidget {
  const RegisterStepOneView({Key? key}) : super(key: key);

  @override
  State<RegisterStepOneView> createState() => _RegisterStepOneViewState();
}

class _RegisterStepOneViewState extends State<RegisterStepOneView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KarateLab AI'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Ro\'yxatdan o\'tish',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Shaxsiy ma\'lumotlaringizni kiriting (1/3)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _firstNameController,
                  hintText: 'Ism',
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) => value!.isEmpty ? 'Ismni kiriting' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _lastNameController,
                  hintText: 'Familiya',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => value!.isEmpty ? 'Familiyani kiriting' : null,
                ),
                const SizedBox(height: 16),
                PhoneTextField(controller: _phoneController),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Davom etish',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save to BLoC state
                      // context.push('/register-step-two');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
