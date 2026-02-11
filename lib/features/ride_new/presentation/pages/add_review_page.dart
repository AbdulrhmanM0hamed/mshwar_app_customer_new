import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/light_bordered_card.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/constant/show_toast_dialog.dart';
import '../cubit/review/review_cubit.dart';
import '../cubit/review/review_state.dart';
import '../widgets/rating_widget.dart';
import '../../data/models/ride_model.dart';
import '../../data/models/review_model.dart';

/// Add Review Page - Submit ride review
class AddReviewPage extends StatefulWidget {
  final RideModel ride;

  const AddReviewPage({
    super.key,
    required this.ride,
  });

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<ReviewCubit>(),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.addReview,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<ReviewCubit, ReviewState>(
          listener: (context, state) {
            if (state is ReviewSubmitted) {
              ShowToastDialog.showToast(l10n.reviewSubmitted);
              Navigator.pop(context);
            }
            if (state is ReviewSubmitError) {
              ShowToastDialog.showToast(state.message);
            }
          },
          builder: (context, state) {
            final isSubmitting = state is ReviewSubmitting;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ride Info Card
                  LightBorderedCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Ride #${widget.ride.id}',
                          size: 16,
                          weight: FontWeight.w600,
                          color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 14,
                              color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomText(
                                text: widget.ride.pickupName,
                                size: 13,
                                color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location5,
                              size: 14,
                              color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomText(
                                text: widget.ride.dropoffName,
                                size: 13,
                                color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (widget.ride.driverName != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Iconsax.user,
                                size: 14,
                                color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                              ),
                              const SizedBox(width: 6),
                              CustomText(
                                text: widget.ride.driverName!,
                                size: 13,
                                weight: FontWeight.w500,
                                color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rating Section
                  CustomText(
                    text: l10n.rateYourRide,
                    size: 18,
                    weight: FontWeight.w600,
                    color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 16),
                  
                  Center(
                    child: RatingWidget(
                      rating: _rating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                      size: 48,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Comment Section
                  CustomText(
                    text: l10n.writeAReview,
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppThemeData.grey800Dark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        hintStyle: TextStyle(
                          color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  CustomButton(
                    btnName: isSubmitting ? 'Submitting...' : l10n.submitReview,
                    buttonColor: _rating > 0 ? AppThemeData.primary200 : AppThemeData.grey400,
                    textColor: Colors.white,
                    borderRadius: 12,
                    ontap: isSubmitting || _rating == 0 ? null : () {
                      final request = ReviewRequest(
                        rideId: widget.ride.id,
                        driverId: widget.ride.driverId ?? '',
                        rating: _rating,
                        comment: _commentController.text.trim(),
                      );
                      context.read<ReviewCubit>().submitReview(request);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
