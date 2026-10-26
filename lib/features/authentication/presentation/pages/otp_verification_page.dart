import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;

  const OtpVerificationPage({super.key, required this.verificationId});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/dashboard');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Verify your identity')),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E8F7),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.phonelink_lock_rounded,
                            size: 32,
                            color: Color(0xFF242269),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'Enter your code',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the 6-digit verification code to finish signing in.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _otpController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: '• • • • • •',
                          ),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 10,
                            color: Color(0xFF242269),
                          ),
                          validator: (value) =>
                              value == null ||
                                  !RegExp(r'^\d{6}$').hasMatch(value)
                              ? 'Enter the 6-digit demo code'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        if (state is AuthLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed: _verifyCode,
                            child: const Text(
                              'Verify and sign in',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E8F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: Color(0xFF242269),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Your demo code is 123456',
                                style: TextStyle(
                                  color: Color(0xFF35336F),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Back to sign in'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _verifyCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      OtpVerificationRequested(
        verificationId: widget.verificationId,
        otp: _otpController.text,
      ),
    );
  }
}
