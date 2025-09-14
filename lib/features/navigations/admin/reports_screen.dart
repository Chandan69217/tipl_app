import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';


class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reports & Analytics",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Filters Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: "Monthly",
                  items: ["Daily", "Weekly", "Monthly", "Yearly"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    labelText: "Report Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: "2025",
                  items: ["2023", "2024", "2025"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    labelText: "Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Income vs Withdrawal Chart
          _chartCard(
            title: "Income vs Withdrawals",
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                          return Text(months[val.toInt() % months.length]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(6, (i) {
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: (i + 1) * 5.0, color: Colors.blue, width: 12),
                      BarChartRodData(toY: (i + 1) * 3.0, color: Colors.orange, width: 12),
                    ]);
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Pie Chart for Active vs Inactive
          _chartCard(
            title: "Active vs Inactive Consumers",
            child: SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                        value: 70, color: Colors.green, title: "Active"),
                    PieChartSectionData(
                        value: 30, color: Colors.red, title: "Inactive"),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Report Summary Stats
          const Text(
            "Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _summaryTile(Iconsax.money, "Total Income", "₹ 15,40,000", Colors.purple),
          _summaryTile(Iconsax.wallet, "Total Withdrawals", "₹ 8,20,000", Colors.orange),
          _summaryTile(Iconsax.user, "Total Consumers", "1200", Colors.blue),
        ],
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _summaryTile(IconData icon, String title, String value, Color color) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
