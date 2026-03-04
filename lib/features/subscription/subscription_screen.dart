import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/widgets/gradient_button.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedPlan = 1;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.vipHeroGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.vipSurface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(3),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.hasActiveSubscription)
                            _buildActiveStatus(user.subscriptionExpiry!),
                          _buildBenefits(),
                          const SizedBox(height: 24),
                          Text(
                            'Choose Your Plan',
                            style: AppTextStyles.displaySmall(
                              color: AppColors.vipText,
                            ),
                          ),
                        const SizedBox(height: 16),
                        ...AppConstants.subscriptionPlans.asMap().entries.map(
                          (entry) => _buildPlanCard(
                              entry.value, entry.key, entry.key == _selectedPlan),
                        ),
                        const SizedBox(height: 24),
                        GradientButton(
                          label: _selectedPlan == 0
                              ? 'Start Weekly Pass — \$2.99'
                              : 'Start Monthly VIP — \$9.99',
                          onTap: () => _subscribe(context),
                          gradient: AppColors.vipGoldGradient,
                          boxShadow: AppColors.vipGoldGlow(blur: 18),
                          icon: const Icon(Icons.workspace_premium, color: AppColors.vipBlack, size: 16),
                        ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Cancel anytime. No hidden fees.',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.vipTextMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildFAQ(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: AppColors.vipText, size: 26),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Velvet VIP',
                  style: AppTextStyles.displaySmall(color: AppColors.vipText),
                ),
                Text(
                  'Unlimited romance, zero limits',
                  style: AppTextStyles.bodyMedium(color: AppColors.vipTextMuted),
                ),
              ],
            ),
          ),
          const Icon(Icons.workspace_premium, color: AppColors.vipGold, size: 48),
        ],
      ),
    );
  }

  Widget _buildActiveStatus(DateTime expiry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.vipGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.vipGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.vipGold, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VIP Active',
                  style: AppTextStyles.titleSmall(color: AppColors.vipText),
                ),
                Text(
                  'Expires ${_formatDate(expiry)}',
                  style: AppTextStyles.bodySmall(color: AppColors.vipTextMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    final benefits = [
      ('Unlimited Chapters', Icons.all_inclusive_rounded),
      ('Audio Narration for All Chapters', Icons.headphones_rounded),
      ('Early Access to New Releases', Icons.new_releases_rounded),
      ('Ad-Free Reading Experience', Icons.block_rounded),
      ('50 Bonus Coins Monthly', Icons.monetization_on_rounded),
      ('Priority Customer Support', Icons.support_agent_rounded),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VIP Benefits',
                          style: AppTextStyles.titleMedium(color: AppColors.vipText),
                          ),
                          const SizedBox(height: 12),
                          ...benefits.map(
                            (b) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.vipGoldGradient,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: AppColors.vipGoldGlow(blur: 8),
                                    ),
                                    child: Icon(b.$2, color: AppColors.vipBlack, size: 16),
                                  ),
                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      b.$1,
                                      style: AppTextStyles.bodyMedium(
                                        color: AppColors.vipText,
                                      ),
                                    ),
                                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int index, bool isSelected) {
    final tag = plan['tag'] as String?;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.vipSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.vipGold : AppColors.vipGold.withValues(alpha: 0.25),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected ? AppColors.vipGoldGlow(blur: 12) : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.vipGold : AppColors.vipTextMuted,
                  width: 2,
                ),
                color: isSelected ? AppColors.vipGold : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: AppColors.vipBlack, size: 14)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                      plan['name'] as String,
                      style: AppTextStyles.titleMedium(
                        color: AppColors.vipText,
                      ),
                    ),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppColors.vipGoldGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: AppColors.vipBlack,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan['description'] as String,
                    style: AppTextStyles.bodySmall(
                      color: AppColors.vipTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan['price'] as String,
                  style: AppTextStyles.titleLarge(color: AppColors.vipGold),
                ),
                Text(
                  '/${plan['period']}',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.vipTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 100).ms),
    );
  }

  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAQ',
          style: AppTextStyles.titleMedium(color: AppColors.vipText),
        ),
        const SizedBox(height: 12),
        _faqItem(
          'Can I cancel anytime?',
          'Yes, cancel anytime from your profile settings. Your access continues until the end of the billing period.',
        ),
        _faqItem(
          'What happens to my coins if I subscribe?',
          'Your coins stay in your wallet. Monthly VIP subscribers receive 50 bonus coins every month.',
        ),
        _faqItem(
          'Do I get audio for all chapters?',
          'Yes! VIP subscribers get audio narration for every chapter across all stories.',
        ),
      ],
    );
  }

  Widget _faqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.titleSmall(color: AppColors.vipText),
      ),
      iconColor: AppColors.vipGold,
      collapsedIconColor: AppColors.vipTextMuted,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            answer,
            style: AppTextStyles.bodyMedium(
              color: AppColors.vipTextMuted,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _subscribe(BuildContext context) {
    final duration = _selectedPlan == 0
        ? const Duration(days: 7)
        : const Duration(days: 30);

    ref.read(userProvider.notifier).activateSubscription(duration: duration);

    if (_selectedPlan == 1) {
      ref.read(userProvider.notifier).addCoins(50);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PopScope(
        canPop: true,
        child: AlertDialog(
          backgroundColor: AppColors.vipSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.vipGold, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Welcome to VIP!',
                  style: AppTextStyles.titleMedium(color: AppColors.vipText),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  context.pop();
                },
                child: const Icon(Icons.close, color: AppColors.vipTextMuted, size: 24),
              ),
            ],
          ),
          content: Text(
            _selectedPlan == 1
                ? 'You now have unlimited access to all chapters + 50 coins added!'
                : 'You now have 7 days of unlimited access!',
            style: AppTextStyles.bodyMedium(color: AppColors.vipTextMuted),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.pop();
              },
              child: Text('Close', style: TextStyle(color: AppColors.vipTextMuted)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.vipGold,
                foregroundColor: AppColors.vipBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Reading!'),
            ),
          ],
        ),
      ),
    );
  }
}
