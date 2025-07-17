import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/utils/helpers/models/monthly_sales_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MonthlySalesController extends GetxController {
  static MonthlySalesController get instance => Get.find();
  final supabase = Supabase.instance.client;
Future<void> updateMonthlySales(double saleAmount, int orderCount, int visitorsCount) async {
  final currentDate = DateTime.now();
  final currentMonthLabel = DateFormat('MMMM yyyy').format(currentDate);
  final previousMonth = DateTime(currentDate.year, currentDate.month - 1);
  final previousMonthLabel = DateFormat('MMMM yyyy').format(previousMonth);

  try {
    final prevResponse = await supabase
        .from('monthly_stats')
        .select()
        .eq('month', previousMonthLabel)
        .maybeSingle();

    final previousTotalSales = prevResponse?['totalSales'] is int
        ? (prevResponse?['totalSales'] as int).toDouble()
        : (prevResponse?['totalSales'] ?? 0.0) as double;

    final previousTotalOrders = prevResponse?['totalOrders'] ?? 0;
    final previousVisitors = prevResponse?['visitors'] ?? 0;

    final currentResponse = await supabase
        .from('monthly_stats')
        .select()
        .eq('month', currentMonthLabel)
        .maybeSingle();

    double updatedTotalSales = saleAmount;
    int updatedTotalOrders = orderCount;
    int updatedVisitors = visitorsCount;

    if (currentResponse != null) {
      final totalSalesFromDb = currentResponse['totalSales'] ?? 0;
      updatedTotalSales += totalSalesFromDb is int
          ? totalSalesFromDb.toDouble()
          : totalSalesFromDb as double;

      final totalOrdersFromDb = currentResponse['totalOrders'] ?? 0;
      updatedTotalOrders += totalOrdersFromDb is int
          ? totalOrdersFromDb
          : int.tryParse(totalOrdersFromDb.toString()) ?? 0;

      final visitorsFromDb = currentResponse['visitors'] ?? 0;
      updatedVisitors += visitorsFromDb is int
          ? visitorsFromDb
          : int.tryParse(visitorsFromDb.toString()) ?? 0;
    }

    final percentageGrowthTotalSales = previousTotalSales > 0
        ? ((updatedTotalSales - previousTotalSales) / previousTotalSales) * 100
        : 0.0;

    final percentageGrowthTotalOrders = previousTotalOrders > 0
        ? ((updatedTotalOrders - previousTotalOrders) / previousTotalOrders) * 100
        : 0.0;

    final previousAverageOrderValue = previousTotalOrders > 0
        ? previousTotalSales / previousTotalOrders
        : 0.0;

    final currentAverageOrderValue = updatedTotalOrders > 0
        ? updatedTotalSales / updatedTotalOrders
        : 0.0;

    final percentageGrowthAverageOrderValue = previousAverageOrderValue > 0
        ? ((currentAverageOrderValue - previousAverageOrderValue) / previousAverageOrderValue) * 100
        : 0.0;

    final percentageGrowthVisitors = previousVisitors > 0
        ? ((updatedVisitors - previousVisitors) / previousVisitors) * 100
        : 0.0;

    if (currentResponse != null) {
      await supabase.from('monthly_stats').update({
        'totalSales': updatedTotalSales,
        'totalOrders': updatedTotalOrders,
        'visitors': updatedVisitors,
        'percentageGrowthTotalSales': percentageGrowthTotalSales,
        'percentageGrowthTotalOrders': percentageGrowthTotalOrders,
        'percentageGrowthAverageOrderValue': percentageGrowthAverageOrderValue,
        'percentageGrowthVisitors': percentageGrowthVisitors,
      }).eq('month', currentMonthLabel);

      print("🟢 Updated existing month: $currentMonthLabel");
    } else {
      final newRecord = MonthlySalesStats(
        id: Uuid().v4(),
        month: currentMonthLabel,
        totalSales: updatedTotalSales,
        totalOrders: updatedTotalOrders,
        visitors: updatedVisitors,
        percentageGrowthTotalSales: percentageGrowthTotalSales,
        percentageGrowthTotalOrders: percentageGrowthTotalOrders,
        percentageGrowthAverageOrderValue: percentageGrowthAverageOrderValue,
        percentageGrowthVisitors: percentageGrowthVisitors,
      );

      await supabase.from('monthly_stats').insert(newRecord.toJson());
      print("🟢 Inserted new month: $currentMonthLabel");
    }
  } catch (e) {
    print("🔴 Error updating monthly sales: ${e.toString()}");
  }
}

}
