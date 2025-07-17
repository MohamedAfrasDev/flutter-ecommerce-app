import 'package:flutter/material.dart';


class MonthlySalesStats {
 final String month;
  final double totalSales;
  final int totalOrders;
  double percentageGrowthTotalSales;
  final int visitors;
  final String id;
  double percentageGrowthAverageOrderValue;
  double percentageGrowthTotalOrders;
  double percentageGrowthVisitors;

  MonthlySalesStats({
    required this.month,
    required this.totalSales,
    required this.totalOrders,
    this.percentageGrowthTotalSales = 0,
    required this.visitors,
    required this.id,
    this.percentageGrowthAverageOrderValue = 0,
    this.percentageGrowthTotalOrders = 0,
    this.percentageGrowthVisitors = 0,
  });


    Map<String, dynamic> toJson() => {
    'month': month,
    'totalSales': totalSales,
    'totalOrders': totalOrders,
    'percentageGrowthTotalSales': percentageGrowthTotalSales,
    'visitors': visitors,
    'id':id,
    'percentageGrowthAverageOrderValue':percentageGrowthAverageOrderValue,
    'percentageGrowthTotalOrders':percentageGrowthTotalOrders,
    'percentageGrowthVisitors':percentageGrowthVisitors,
  };

  factory MonthlySalesStats.fromJson(Map<String, dynamic> json) => MonthlySalesStats(
    month: json['month'],
    totalSales: json['totalSales'],
    totalOrders: json['totalOrders'],
    percentageGrowthTotalSales: json['percentageGrowthTotalSales'],
    visitors: json['visitors'],
    id: json['id'],
    percentageGrowthAverageOrderValue: json['percentageGrowthAverageOrderValue'],
    percentageGrowthTotalOrders: json['percentageGrowthTotalOrders'],
    percentageGrowthVisitors: json['percentageGrowthVisitors'],
  );

}