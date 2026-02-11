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
import '../cubit/complaint/complaint_cubit.dart';
import '../cubit/complaint/complaint_state.dart';
import '../../data/models/ride_model.dart';
import '../../data/models/complaint_model.dart';

/// Add Complaint Page - Submit complaint about ride
class AddComplaintPage extends StatefulWidget {
  final RideModel ride;

  const AddComplaintPage({
    super.key,
    required this.ride,
  });

  @override
  State<AddComplaintPage> createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedType;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<ComplaintCubit>(),
      child: Scaffold(
        backgroundColor:
            isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.addComplaint,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<ComplaintCubit, ComplaintState>(
          listener: (context, state) {
            if (state is ComplaintSubmitted) {
              ShowToastDialog.showToast(l10n.complaintSubmitted);
              Navigator.pop(context);
            }
            if (state is ComplaintSubmitError) {
              ShowToastDialog.showToast(state.message);
            }
          },
          builder: (context, state) {
            final isSubmitting = state is ComplaintSubmitting;

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
                          color: isDark
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 14,
                              color: isDark
                                  ? AppThemeData.grey500Dark
                                  : AppThemeData.grey500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomText(
                                text: widget.ride.pickupName,
                                size: 13,
                                color: isDark
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
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
                              color: isDark
                                  ? AppThemeData.grey500Dark
                                  : AppThemeData.grey500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomText(
                                text: widget.ride.dropoffName,
                                size: 13,
                                color: isDark
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Complaint Type
                  CustomText(
                    text: l10n.complaintType,
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDark
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppThemeData.grey800Dark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey200,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        hintText: l10n.selectComplaintType,
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      dropdownColor:
                          isDark ? AppThemeData.grey800Dark : Colors.white,
                      style: TextStyle(
                        color: isDark
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: ComplaintType.driverBehavior,
                          child: Text(l10n.driverBehavior),
                        ),
                        DropdownMenuItem(
                          value: ComplaintType.vehicleCondition,
                          child: Text(l10n.vehicleCondition),
                        ),
                        DropdownMenuItem(
                          value: ComplaintType.routeIssue,
                          child: Text(l10n.routeIssue),
                        ),
                        DropdownMenuItem(
                          value: ComplaintType.paymentIssue,
                          child: Text(l10n.paymentIssue),
                        ),
                        DropdownMenuItem(
                          value: ComplaintType.safetyIssue,
                          child: Text(l10n.safetyIssue),
                        ),
                        DropdownMenuItem(
                          value: ComplaintType.other,
                          child: Text(l10n.other),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  CustomText(
                    text: l10n.describeYourComplaint,
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDark
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppThemeData.grey800Dark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey200,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText:
                            'Please provide details about your complaint...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        color: isDark
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  CustomButton(
                    btnName:
                        isSubmitting ? 'Submitting...' : l10n.submitComplaint,
                    buttonColor: _selectedType != null &&
                            _descriptionController.text.isNotEmpty
                        ? AppThemeData.primary200
                        : AppThemeData.grey400,
                    textColor: Colors.white,
                    borderRadius: 12,
                    ontap: isSubmitting ||
                            _selectedType == null ||
                            _descriptionController.text.isEmpty
                        ? null
                        : () {
                            final request = ComplaintRequest(
                              rideId: widget.ride.id,
                              driverId: widget.ride.driverId,
                              complaintType: _selectedType!,
                              description: _descriptionController.text.trim(),
                            );
                            context
                                .read<ComplaintCubit>()
                                .submitComplaint(request);
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
