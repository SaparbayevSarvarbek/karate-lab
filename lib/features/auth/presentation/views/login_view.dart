import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../viewmodels/bloc/auth_bloc.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_footer_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon 🚀'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      LoginRequested(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _onRegister() {
    context.push('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/main', extra: state.role);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('KarateLab AI'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Tizimga kirilmoqda...',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 32),
                            const LoginHeaderWidget(),
                            const SizedBox(height: 48),
                            CustomTextField(
                              controller: _usernameController,
                              hintText: 'Foydalanuvchi nomi',
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) =>
                                  v!.isEmpty ? 'Username kiriting' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Parol',
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textHint,
                                ),
                                onPressed: _togglePassword,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Parolni kiriting' : null,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _onForgotPassword,
                                child: const Text(
                                  'Parolni unutdingizmi?',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Kirish',
                              onPressed: _onLogin,
                            ),
                            const SizedBox(height: 24),
                            LoginFooterWidget(onRegister: _onRegister),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
