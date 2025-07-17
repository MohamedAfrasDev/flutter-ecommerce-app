import 'dart:io';
import 'package:online_shop/utils/formatters/formatters.dart';
import 'package:online_shop/utils/http/app/app_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:pdf/widgets.dart' show Font, FontWeight;
import 'package:pdf/widgets.dart' as pw;
import 'package:online_shop/utils/constants/text_strings.dart';

class TPDFFormateGenerator {
  Future<void> generatePdfBill({
    required List<CartItem> products,
    required AddressModel address,
    required bool? isShipping,
    required double totalAmount,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // App/Company Name Header
              pw.Container(
                width: double.infinity,
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.all(12),
                child: pw.Text(
                  TText.appName,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 22,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              // Invoice title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                "INVOICE",
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              pw.Text(
                TFormatters.formatDate(DateTime.now()),
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
                ]
              ),
              pw.Divider(),

              // Customer Details
              pw.SizedBox(height: 10),
              pw.Text("Customer Details", style: pw.TextStyle(font: boldFont, fontSize: 14)),
              pw.SizedBox(height: 4),
              pw.Text("Name: ${address.name}", style: pw.TextStyle(font: font)),
              pw.Text("Address: ${address.street}, ${address.city}", style: pw.TextStyle(font: font)),
              pw.Text("Phone: ${address.phone}", style: pw.TextStyle(font: font)),
              pw.Text("Email: ${address.state}", style: pw.TextStyle(font: font)),

              pw.SizedBox(height: 20),

              // Table Header
              pw.Container(
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text("Product", style: pw.TextStyle(font: boldFont))),
                    pw.Text("Qty", style: pw.TextStyle(font: boldFont)),
                    pw.SizedBox(width: 20),
                    pw.Text("Price", style: pw.TextStyle(font: boldFont)),
                  ],
                ),
              ),

              if(isShipping == true)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: pw.Text("Shipping Fee: LKR ${TAppConfig.shipping_cost}", style: pw.TextStyle(font: font)),
              ),

              // Products
              ...products.map(
                (product) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(product.title, style: pw.TextStyle(font: font)),
                      ),
                      pw.Text("${product.quantity}", style: pw.TextStyle(font: font)),
                      pw.SizedBox(width: 20),
                      pw.Text("LKR ${(product.price * product.quantity).toStringAsFixed(2)}", style: pw.TextStyle(font: font)),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 12),

              // Total
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: LKR ${(totalAmount + TAppConfig.shipping_cost).toStringAsFixed(2)}",
                  style: pw.TextStyle(font: boldFont, fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Preview
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
