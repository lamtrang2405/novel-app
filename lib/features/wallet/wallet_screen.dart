import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/user_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Coin Wallet', style: AppTextStyles.titleLarge()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(user.coins).animate().fadeIn().slideY(begin: -0.1),
            const SizedBox(height: 24),
            Text('Buy Coins', style: AppTextStyles.displaySmall()),
            const SizedBox(height: 4),
            Text(
              'Use coins to unlock premium chapters',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ...AppConstants.coinPackages.asMap().entries.map(
              (entry) => _buildCoinPackage(
                context,
                ref,
                entry.value,
                entry.key,
              ),
            ),
            const SizedBox(height: 24),
            _buildHowToEarn(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(int coins) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.monetization_on_rounded,
              color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            '$coins',
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            'Coins Available',
            style: AppTextStyles.bodyMedium(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackage(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> pkg,
    int index,
  ) {
    final isPopular = pkg['tag'] == 'Popular';
    final isBestValue = pkg['tag'] == 'Best Value';
    final bonus = pkg['bonus'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          ref.read(userProvider.notifier).addCoins((pkg['coins'] as int) + bonus);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${pkg['coins'] + bonus} coins added to your wallet!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPopular || isBestValue
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.1),
              width: isPopular || isBestValue ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isBestValue
                      ? AppColors.goldGradient
                      : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on,
                        color: Colors.white, size: 20),
                    Text(
                      '${pkg['coins']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pkg['coins']} Coins',
                      style: AppTextStyles.titleMedium(),
                    ),
                    if (bonus > 0)
                      Text(
                        '+$bonus bonus coins',
                        style: AppTextStyles.bodySmall(color: AppColors.success),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pkg['price'] as String,
                    style: AppTextStyles.titleMedium(color: AppColors.primary),
                  ),
                  if (pkg['tag'] != null && (pkg['tag'] as String).isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isBestValue
                            ? AppColors.gold
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pkg['tag'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 80).ms),
    );
  }

  Widget _buildHowToEarn() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Earn Free Coins', style: AppTextStyles.titleSmall()),
          const SizedBox(height: 12),
          _earnRow(Icons.login_rounded, 'Daily login bonus', '+5 coins'),
          _earnRow(Icons.rate_review_rounded, 'Write a review', '+10 coins'),
          _earnRow(Icons.share_rounded, 'Share a story', '+5 coins'),
          _earnRow(Icons.workspace_premium, 'Subscribe monthly',
              '+50 coins/month'),
        ],
      ),
    );
  }

  Widget _earnRow(IconData icon, String label, String reward) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              reward,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
