import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_alrayada/data/order/m_order.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

class PrintOrder extends ConsumerWidget {
  const PrintOrder(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDark = FluentTheme.of(context).brightness == Brightness.dark;
    const isDark = false;
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 150, child: pw.FlutterLogo()),
              pw.SizedBox(height: 50),
              pw.Text(
                'Order #${order.orderNumber}',
                style: pw.Theme.of(context).header0,
              ),
              pw.Text(
                  'Order total after discount: \$${order.totalOriginalPrice.toStringAsFixed(2)}, before discount \$${order.totalSalePrice.toStringAsFixed(2)}'),
              pw.Divider(),
              pw.Text(
                'Order items:',
                textAlign: pw.TextAlign.center,
                style: pw.Theme.of(context).header0,
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey, width: 1),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        // ignore: dead_code
                        color: isDark ? PdfColors.red : PdfColors.white,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Name',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Price',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Quantity',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...order.items.map((orderItem) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(
                              orderItem.product.name,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(
                              '\$${orderItem.product.salePrice}',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(
                              orderItem.quantity.toString(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList()
                  ],
                ),
              ),
              pw.Spacer(),
            ],
          );
        },
      ),
    );

    return AlertDialog(
      content: ListView.builder(
        itemCount: order.items.length,
        itemBuilder: (context, index) {
          final orderItem = order.items[index];
          return ListTile(
            trailing: Text('\$${orderItem.product.salePrice}'),
            leading: Text(order.status.name),
            subtitle: const Text('Hi'),
            title: Text('#${order.orderNumber}'),
            onTap: () {},
          );
        },
      ),
      title: Text('Print order #${order.orderNumber}'),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
            child: const Text('print'),
            onPressed: () {
              Printing.layoutPdf(onLayout: (format) async => doc.save());
            }),
      ],
    );
  }
}
