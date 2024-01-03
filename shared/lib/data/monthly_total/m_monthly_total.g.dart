// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_monthly_total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MonthlyTotal _$$_MonthlyTotalFromJson(Map<String, dynamic> json) =>
    _$_MonthlyTotal(
      month: json['month'] as int,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$_MonthlyTotalToJson(_$_MonthlyTotal instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total': instance.total,
    };
