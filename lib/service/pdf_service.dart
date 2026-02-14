import 'dart:io';
import 'dart:convert';
import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/features/ride_new/data/models/ride_model.dart';
import 'package:cabme/features/authentication_new/data/models/user_model.dart';
import 'package:cabme/features/settings_new/data/models/settings_model.dart';
import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {
  /// Generate PDF for ride details and return the file path
  static Future<File?> generateRidePdf(
      BuildContext context, RideModel rideData) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final pdf = pw.Document();

      // Get current date and time
      final now = DateTime.now();
      final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
      final rideDateFormat = DateFormat('dd MMM yyyy, hh:mm a');

      // Parse ride date
      DateTime? rideDateTime;
      if (rideData.createdAt.isNotEmpty) {
        try {
          rideDateTime = DateTime.parse(rideData.createdAt);
        } catch (e) {
          rideDateTime = now;
        }
      } else {
        rideDateTime = now;
      }

      // Get currency symbol
      final currency = Constant.currency ?? 'KWD';

      // Get customer details
      UserModel? customerData;
      try {
        customerData = Constant.getUserData();
      } catch (e) {
        debugPrint('Error getting customer data: $e');
      }

      // Get company/settings data
      SettingsModel? settingsData;
      try {
        settingsData = _getSettingsData();
      } catch (e) {
        debugPrint('Error getting settings data: $e');
      }

      // Build PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context pdfContext) {
            return [
              // Company Header
              _buildCompanyHeader(settingsData),
              pw.SizedBox(height: 20),
              // Receipt Header
              _buildHeader(l10n, rideData, dateFormat.format(now)),
              pw.SizedBox(height: 30),

              // Customer Information
              if (customerData != null && customerData.id.isNotEmpty) ...[
                _buildSectionTitle('Customer Information'),
                pw.SizedBox(height: 10),
                _buildCustomerInfo(l10n, customerData),
                pw.SizedBox(height: 20),
              ],

              // Trip Information
              _buildSectionTitle('Trip Information'),
              pw.SizedBox(height: 10),
              _buildTripInfo(
                  l10n, rideData, rideDateFormat.format(rideDateTime!)),
              pw.SizedBox(height: 20),

              // Route Information
              _buildSectionTitle(l10n.route),
              pw.SizedBox(height: 10),
              _buildRouteInfo(l10n, rideData),
              pw.SizedBox(height: 20),

              // Driver & Vehicle Information (if available)
              if (rideData.paymentStatus == 'yes' &&
                  rideData.driverName != null) ...[
                _buildSectionTitle(l10n.driverDetails),
                pw.SizedBox(height: 10),
                _buildDriverInfo(l10n, rideData),
                pw.SizedBox(height: 20),
              ],

              // Payment Information
              _buildSectionTitle('Payment Information'),
              pw.SizedBox(height: 10),
              _buildPaymentInfo(l10n, rideData, currency),
              pw.SizedBox(height: 20),

              // Footer
              pw.Spacer(),
              _buildFooter(l10n),
            ];
          },
        ),
      );

      // Save PDF to file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'Ride_${rideData.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      return null;
    }
  }

  /// Generate and share PDF
  static Future<void> generateAndSharePdf(
      BuildContext context, RideModel rideData) async {
    try {
      final file = await generateRidePdf(context, rideData);
      if (file != null && await file.exists()) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Ride Details - Trip #${rideData.id}',
        );
      } else {
        if (context.mounted) {
          CustomSnackbar.showError(
            context: context,
            message: 'Failed to generate PDF',
          );
        }
      }
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      if (context.mounted) {
        CustomSnackbar.showError(
          context: context,
          message: 'Failed to share PDF: $e',
        );
      }
    }
  }

  /// Generate and print PDF
  static Future<void> generateAndPrintPdf(
      BuildContext context, RideModel rideData) async {
    try {
      final pdf = await _buildPdfDocument(context, rideData);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint('Error printing PDF: $e');
      if (context.mounted) {
        CustomSnackbar.showError(
          context: context,
          message: 'Failed to print PDF: $e',
        );
      }
    }
  }

  /// Build PDF document
  static Future<pw.Document> _buildPdfDocument(
      BuildContext context, RideModel rideData) async {
    final l10n = AppLocalizations.of(context)!;
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final rideDateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    DateTime? rideDateTime;
    if (rideData.createdAt.isNotEmpty) {
      try {
        rideDateTime = DateTime.parse(rideData.createdAt);
      } catch (e) {
        rideDateTime = now;
      }
    } else {
      rideDateTime = now;
    }

    final currency = Constant.currency ?? 'KWD';

    // Get customer details
    UserModel? customerData;
    try {
      customerData = Constant.getUserData();
    } catch (e) {
      debugPrint('Error getting customer data: $e');
    }

    // Get company/settings data
    SettingsModel? settingsData;
    try {
      settingsData = _getSettingsData();
    } catch (e) {
      debugPrint('Error getting settings data: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context pdfContext) {
          return [
            // Company Header
            _buildCompanyHeader(settingsData),
            pw.SizedBox(height: 20),
            // Receipt Header
            _buildHeader(l10n, rideData, dateFormat.format(now)),
            pw.SizedBox(height: 30),
            // Customer Information
            if (customerData != null && customerData.id.isNotEmpty) ...[
              _buildSectionTitle('Customer Information'),
              pw.SizedBox(height: 10),
              _buildCustomerInfo(l10n, customerData),
              pw.SizedBox(height: 20),
            ],
            _buildSectionTitle('Trip Information'),
            pw.SizedBox(height: 10),
            _buildTripInfo(
                l10n, rideData, rideDateFormat.format(rideDateTime!)),
            pw.SizedBox(height: 20),
            _buildSectionTitle(l10n.route),
            pw.SizedBox(height: 10),
            _buildRouteInfo(l10n, rideData),
            pw.SizedBox(height: 20),
            if (rideData.paymentStatus == 'yes' &&
                rideData.driverName != null) ...[
              _buildSectionTitle(l10n.driverDetails),
              pw.SizedBox(height: 10),
              _buildDriverInfo(l10n, rideData),
              pw.SizedBox(height: 20),
            ],
            _buildSectionTitle('Payment Information'),
            pw.SizedBox(height: 10),
            _buildPaymentInfo(l10n, rideData, currency),
            pw.SizedBox(height: 20),
            pw.Spacer(),
            _buildFooter(l10n),
          ];
        },
      ),
    );

    return pdf;
  }

  /// Get settings data from Preferences or return null
  static SettingsModel? _getSettingsData() {
    try {
      final settingsJson = Preferences.getString('settings');
      if (settingsJson.isNotEmpty && settingsJson != 'null') {
        final settingsMap = jsonDecode(settingsJson);
        return SettingsModel.fromJson(settingsMap);
      }
    } catch (e) {
      debugPrint('Error parsing settings from Preferences: $e');
    }
    return null;
  }

  /// Build company header section
  static pw.Widget _buildCompanyHeader(SettingsModel? settings) {
    final companyName = settings?.data?.title ?? 'Mshwar';
    final companyEmail = settings?.data?.email ?? '';
    final companyPhone = settings?.data?.contactUsPhone ?? '';
    final companyAddress = settings?.data?.contactUsAddress ?? '';

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF0D47A1), // blue900
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Company Name
          pw.Text(
            companyName,
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 12),
          // Contact Information
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (companyEmail.isNotEmpty && companyEmail != 'null')
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Row(
                          children: [
                            pw.Text(
                              'Email: ',
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                companyEmail,
                                style: const pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (companyPhone.isNotEmpty && companyPhone != 'null')
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Row(
                          children: [
                            pw.Text(
                              'Phone: ',
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                companyPhone,
                                style: const pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (companyAddress.isNotEmpty && companyAddress != 'null')
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Address: ',
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              companyAddress,
                              style: const pw.TextStyle(
                                  fontSize: 11, color: PdfColors.white),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build header section
  static pw.Widget _buildHeader(
      AppLocalizations l10n, RideModel rideData, String generatedDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Ride Receipt',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF0D47A1), // blue900
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Trip ID: ${rideData.id}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Generated: $generatedDate',
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build section title
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFE3F2FD), // blue50
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: const PdfColor.fromInt(0xFF0D47A1), // blue900
        ),
      ),
    );
  }

  /// Build trip information
  static pw.Widget _buildTripInfo(
      AppLocalizations l10n, RideModel rideData, String rideDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Trip ID', '#${rideData.id}'),
          pw.Divider(),
          _buildInfoRow('Date & Time', rideDate),
          pw.Divider(),
          _buildInfoRow('Status', _getStatusText(rideData.status)),
          pw.Divider(),
          _buildInfoRow(
            'Distance',
            '${rideData.distance} ${rideData.distanceUnit}',
          ),
          if (rideData.duration != null && rideData.duration != 'null') ...[
            pw.Divider(),
            _buildInfoRow('Duration', rideData.duration!),
          ],
        ],
      ),
    );
  }

  /// Build route information
  static pw.Widget _buildRouteInfo(AppLocalizations l10n, RideModel rideData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 10,
                height: 10,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Pickup Location',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      rideData.pickupName,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 15),
          // Stops
          if (rideData.stops.isNotEmpty)
            ...rideData.stops.asMap().entries.map((entry) {
              final index = entry.key;
              final stop = entry.value;
              return pw.Column(
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.orange,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Stop ${index + 1}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              stop.location,
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                ],
              );
            }),
          // Dropoff
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 10,
                height: 10,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.red,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Dropoff Location',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      rideData.dropoffName,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build customer information
  static pw.Widget _buildCustomerInfo(AppLocalizations l10n, UserModel user) {
    if (user.id.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (user.firstName.isNotEmpty || user.lastName.isNotEmpty)
            _buildInfoRow(
              'Customer Name',
              '${user.firstName} ${user.lastName}'.trim(),
            ),
          if (user.email.isNotEmpty && user.email != 'null') ...[
            pw.Divider(),
            _buildInfoRow('Email', user.email),
          ],
          if (user.phone != null &&
              user.phone != 'null' &&
              user.phone!.isNotEmpty) ...[
            pw.Divider(),
            _buildInfoRow(l10n.phoneNumber, user.phone!),
          ],
          if (user.id.isNotEmpty) ...[
            pw.Divider(),
            _buildInfoRow('Customer ID', user.id),
          ],
        ],
      ),
    );
  }

  /// Build driver information
  static pw.Widget _buildDriverInfo(AppLocalizations l10n, RideModel rideData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (rideData.driverName != null)
            _buildInfoRow(
              'Driver Name',
              rideData.driverName!,
            ),
          if (rideData.driverPhone != null &&
              rideData.driverPhone != 'null') ...[
            pw.Divider(),
            _buildInfoRow('Driver Phone', rideData.driverPhone!),
          ],
          if (rideData.vehiclePlate != null &&
              rideData.vehiclePlate != 'null') ...[
            pw.Divider(),
            _buildInfoRow('License Plate', rideData.vehiclePlate!),
          ],
          if (rideData.vehicleBrand != null ||
              rideData.vehicleModel != null) ...[
            pw.Divider(),
            _buildInfoRow(
              'Vehicle',
              '${rideData.vehicleBrand ?? ''} ${rideData.vehicleModel ?? ''}'
                  .trim(),
            ),
          ],
          if (rideData.vehicleColor != null &&
              rideData.vehicleColor != 'null') ...[
            pw.Divider(),
            _buildInfoRow('Color', rideData.vehicleColor!),
          ],
        ],
      ),
    );
  }

  /// Build payment information
  static pw.Widget _buildPaymentInfo(
      AppLocalizations l10n, RideModel rideData, String currency) {
    double baseAmount = double.tryParse(rideData.amount) ?? 0.0;
    double totalTax = 0.0;
    double totalAmount = 0.0;

    try {
      if (rideData.taxes.isNotEmpty) {
        for (var tax in rideData.taxes) {
          totalTax += tax.calculateTax(baseAmount);
        }
      }
      totalAmount = baseAmount + totalTax;
    } catch (e) {
      debugPrint('Error calculating payment: $e');
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (baseAmount > 0)
            _buildInfoRow(
              'Base Fare',
              Constant().amountShow(amount: baseAmount.toString()),
            ),
          if (totalTax > 0) ...[
            pw.Divider(),
            _buildInfoRow(
              'Tax',
              Constant().amountShow(amount: totalTax.toString()),
            ),
          ],
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                l10n.totalAmount,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                Constant().amountShow(amount: totalAmount.toString()),
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF0D47A1), // blue900
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow(
            'Payment Status',
            _getPaymentStatusText(rideData.paymentStatus),
          ),
          if (rideData.paymentMethod != null &&
              rideData.paymentMethod != 'null') ...[
            pw.Divider(),
            _buildInfoRow(l10n.paymentMethod, rideData.paymentMethod!),
          ],
        ],
      ),
    );
  }

  /// Build info row
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// Build footer
  static pw.Widget _buildFooter(AppLocalizations l10n) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Center(
        child: pw.Text(
          'Thank you for using our service!',
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
      ),
    );
  }

  /// Get status text
  static String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  /// Get payment status text
  static String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'yes':
        return 'Paid';
      case 'no':
        return 'Unpaid';
      default:
        return status;
    }
  }
}
