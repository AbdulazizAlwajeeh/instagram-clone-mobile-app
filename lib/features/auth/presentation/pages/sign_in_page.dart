import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/features/auth/presentation/widgets/auth_header.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_action.dart';
import '../widgets/auth_text_field.dart';

/// A presentation page layer displaying the credentials acquisition gate layout.
///
/// Interfaces with user token inputs and bridges entry workflows down into
/// active state management event streams.
class SignInPage extends StatefulWidget {
  /// Instantiates a stateless configuration anchor frame for authentication.
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// Form tracking key used to evaluate structural field validations atomically.
  final _formKey = GlobalKey<FormState>();

  /// Form input text capture manager holding onto email string arrays.
  final _emailController = TextEditingController();

  /// Form input text capture manager holding onto password identity strings.
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController
        .dispose(); // Releases filesystem focus locks on widget disposal.
    _passwordController.dispose();
    super.dispose();
  }

  /// Triggers structural client-side validations and forwards matching credentials hooks upstream.
  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // Outer safety gutter wrapping entry forms.
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                // Intercepts processing boundaries errors to alert user interaction channels.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is AuthSuccess) {
                // Intercepts structural success frames to confirm authorization context.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Welcome back, ${state.user.username}!'),
                  ),
                );
                context.go(
                  AppRouter.feedPath,
                ); // Navigates profile forward into secure activity pipelines.
              }
            },
            builder: (context, state) {
              final isLoading =
                  state
                      is AuthLoading; // Freezes entry interaction channels during transit.

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: true,
                      enabled: !isLoading,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    AuthActionBlock(
                      primaryButtonText: 'Log In',
                      secondaryButtonText: "Don't have an account? Sign Up",
                      isLoading: isLoading,
                      onPrimaryPressed: _handleSignIn,
                      onSecondaryPressed: () {
                        context.go(
                          AppRouter.signUpPath,
                        ); // Switches interface directly over to account generation frames.
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
