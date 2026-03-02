import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/gradient_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.bgDark,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        _buildTabBar(),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildSignInForm(),
                              _buildSignUpForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        children: [
          const Icon(Icons.auto_stories_rounded,
              color: Colors.white, size: 48)
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 10),
          Text(AppConstants.appName,
              style: AppTextStyles.displaySmall(color: Colors.white))
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms),
          Text(AppConstants.appTagline,
              style: AppTextStyles.bodyMedium(color: Colors.white70))
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Create Account'),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Welcome back!', style: AppTextStyles.displaySmall()),
          const SizedBox(height: 4),
          Text(
            'Sign in to continue your story',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Sign In',
            onTap: () => _signIn(),
          ),
          const SizedBox(height: 20),
          _buildSocialDivider(),
          const SizedBox(height: 20),
          _buildSocialButtons(),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Continue as Guest →'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Join Velvet Reads', style: AppTextStyles.displaySmall()),
          const SizedBox(height: 4),
          Text(
            'Start your romance journey today',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Create password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Create Account',
            onTap: () => _signIn(),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'By signing up, you agree to our Terms of Service\nand Privacy Policy',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(),
            ),
          ),
          const SizedBox(height: 20),
          _buildSocialDivider(),
          const SizedBox(height: 20),
          _buildSocialButtons(),
        ],
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.primary.withValues(alpha: 0.15))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: AppTextStyles.bodySmall(),
          ),
        ),
        Expanded(child: Divider(color: AppColors.primary.withValues(alpha: 0.15))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _signIn(),
            icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
            label: const Text('Google'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _signIn(),
            icon: const Icon(Icons.apple, size: 20),
            label: const Text('Apple'),
          ),
        ),
      ],
    );
  }

  void _signIn() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }
}
