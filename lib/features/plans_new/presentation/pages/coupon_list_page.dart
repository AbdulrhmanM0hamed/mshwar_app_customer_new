import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/coupon/coupon_cubit.dart';
import '../cubit/coupon/coupon_state.dart';
import '../widgets/coupon_card.dart';

class CouponListPage extends StatelessWidget {
  final bool showBackButton;

  const CouponListPage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.instance<PlansCouponCubit>()..loadCoupons(),
      child: Scaffold(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.coupons,
          showBackButton: showBackButton,
          actions: [
            BlocBuilder<PlansCouponCubit, PlansCouponState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    context.read<PlansCouponCubit>().loadCoupons();
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<PlansCouponCubit, PlansCouponState>(
          builder: (context, state) {
            if (state is PlansCouponsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlansCouponsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: state.message,
                        size: 16,
                        color: themeChange.getThem() ? Colors.white70 : Colors.black54,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PlansCouponsLoaded) {
              if (state.coupons.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 80,
                          color: themeChange.getThem()
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey300,
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: l10n.noCouponsAvailable,
                          size: 20,
                          weight: FontWeight.bold,
                          color: themeChange.getThem()
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey500,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PlansCouponCubit>().loadCoupons();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = state.coupons[index];
                    return CouponCard(
                      coupon: coupon,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: coupon.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.couponCodeCopied,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black38,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
