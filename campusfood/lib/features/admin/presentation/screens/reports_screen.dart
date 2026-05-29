import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/admin/presentation/providers/admin_provider.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  String get _fromStr => DateFormat('yyyy-MM-01').format(_dateRange.start);
  String get _toStr => DateFormat('yyyy-MM-dd').format(_dateRange.end);

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _exportCsv() async {
    final url = Uri.parse('${ApiService.baseUrl}/admin/reports/export');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(
      adminReportsProvider(startDate: _fromStr, endDate: _toStr),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: _exportCsv),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const Gap(12),
                    Text(
                      'Period: ${DateFormat('MMM dd').format(_dateRange.start)} - ${DateFormat('MMM dd, yyyy').format(_dateRange.end)}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: reportsAsync.when(
              data: (data) => _buildReportContent(data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (err, _) => AppErrorWidget(
                    message: err.toString(),
                    onRetry:
                        () => ref.invalidate(
                          adminReportsProvider(
                            startDate: _fromStr,
                            endDate: _toStr,
                          ),
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(Map<String, dynamic> data) {
    final topViewed = data['top_viewed'] as List;
    final topRated = data['top_rated'] as List;
    final categoryStats = data['category_stats'] as List;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildChartCard(
          title: 'Top 10 Most Viewed Foods',
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY:
                  topViewed.isEmpty
                      ? 10
                      : (topViewed[0]['views'] as int).toDouble() * 1.2,
              barGroups:
                  topViewed.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: (e.value['views'] as int).toDouble(),
                          color: AppColors.primary,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
        const Gap(16),
        _buildChartCard(
          title: 'Highest Rated Items',
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: 5,
              barGroups:
                  topRated.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: double.parse(e.value['avg_rating'].toString()),
                          color: Colors.amber,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
        const Gap(16),
        _buildChartCard(
          title: 'Category Distribution',
          height: 300,
          child: PieChart(
            PieChartData(
              sections:
                  categoryStats.asMap().entries.map((e) {
                    return PieChartSectionData(
                      value: (e.value['item_count'] as int).toDouble(),
                      title: '${e.value['item_count']}',
                      color: Colors.primaries[e.key % Colors.primaries.length],
                      radius: 50,
                    );
                  }).toList(),
            ),
          ),
        ),
        const Gap(16),
        _buildVendorRanking(data['vendor_stats'] as List),
        const Gap(32),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required double height,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h3),
            const Gap(24),
            SizedBox(height: height - 80, child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorRanking(List stats) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vendor Performance', style: AppTextStyles.h3),
            const Gap(16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [_th('Vendor'), _th('Items'), _th('Rating')],
                ),
                ...stats.map(
                  (s) => TableRow(
                    children: [
                      _td(s['business_name']),
                      _td(s['food_count'].toString()),
                      _td('${s['avg_rating']} ★'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _th(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
    ),
  );

  Widget _td(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
    ),
  );
}
