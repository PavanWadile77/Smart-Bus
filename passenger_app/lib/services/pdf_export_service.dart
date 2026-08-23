import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../models/trip_history_model.dart';

class PDFExportService {
  static Future<String?> exportTripHistoryToPDF(List<TripHistoryModel> trips) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(level: 0, child: pw.Text('Smart Bus - Trip History Report')),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                headers: ['Driver ID', 'Bus ID', 'Distance (km)', 'Start Time', 'End Time'],
                data: trips.map((trip) {
                  return [
                    trip.driverId,
                    trip.busId,
                    trip.distanceKm.toStringAsFixed(2),
                    trip.startTime.toLocal().toString().split('.')[0],
                    trip.endTime.toLocal().toString().split('.')[0],
                  ];
                }).toList(),
              ),
            ];
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/trip_history_report.pdf');
      await file.writeAsBytes(await pdf.save());
      
      return file.path;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      return null;
    }
  }
}
