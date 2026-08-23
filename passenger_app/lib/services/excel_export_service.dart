import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../models/trip_history_model.dart';

class ExcelExportService {
  static Future<String?> exportTripHistoryToExcel(List<TripHistoryModel> trips) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['TripHistory'];
      excel.setDefaultSheet('TripHistory');

      sheetObject.appendRow([
        TextCellValue('Driver ID'),
        TextCellValue('Bus ID'),
        TextCellValue('Distance (km)'),
        TextCellValue('Start Time'),
        TextCellValue('End Time'),
      ]);

      for (var trip in trips) {
        sheetObject.appendRow([
          TextCellValue(trip.driverId),
          TextCellValue(trip.busId),
          DoubleCellValue(trip.distanceKm),
          TextCellValue(trip.startTime.toLocal().toString().split('.')[0]),
          TextCellValue(trip.endTime.toLocal().toString().split('.')[0]),
        ]);
      }

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/trip_history_report.xlsx');
      final bytes = excel.encode();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
        return file.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error generating Excel: $e');
      return null;
    }
  }
}
