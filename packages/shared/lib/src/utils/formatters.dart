import 'package:intl/intl.dart';

String formatKw(num? value) {
  if (value == null) return '—';
  final f = NumberFormat('#,##0.#', 'tr_TR');
  return '${f.format(value)} kW';
}

String formatMm(int? value) {
  if (value == null) return '—';
  return '$value mm';
}

String formatKg(num? value) {
  if (value == null) return '—';
  final f = NumberFormat('#,##0.#', 'tr_TR');
  return '${f.format(value)} kg';
}

String formatPct(num? value) {
  if (value == null) return '—';
  final f = NumberFormat('#,##0.#', 'tr_TR');
  return '%${f.format(value)}';
}

String formatM2Range(int? min, int? max) {
  if (min == null && max == null) return '—';
  if (min != null && max != null) return '$min–$max m²';
  if (min != null) return '$min+ m²';
  return '0–$max m²';
}
