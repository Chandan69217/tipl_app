import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tipl_app/core/utilities/capitalize_first.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/navigation/packages/package_transaction_screen.dart';
import 'package:tipl_app/features/navigation/user/wallets/add_fund_screen.dart';

class PurchasedPlanSlider extends StatefulWidget {
  final List<dynamic> purchasedPlan;

  const PurchasedPlanSlider({super.key, required this.purchasedPlan});

  @override
  State<PurchasedPlanSlider> createState() => _PurchasedPlanSliderState();
}

class _PurchasedPlanSliderState extends State<PurchasedPlanSlider> {
  final PageController _controller = PageController(viewportFraction: 0.90,);

  Widget _buildNoMembershipMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange.shade700),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "You have not purchased any membership yet.",
              style: TextStyle(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.purchasedPlan.isEmpty ? _buildNoMembershipMessage()
            :
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.purchasedPlan.length,
            padEnds: false,
            itemBuilder: (context, index) {
              final plan = widget.purchasedPlan[index];
              return GestureDetector(
                onTap: (){
                  navigateWithAnimation(context, PackageTransactionScreen(
                    plan: plan,
                  ));
                },
                  child: PurchasedPlanCard(plan: plan)
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        /// ----------- PAGE INDICATOR -----------
        SmoothPageIndicator(
          controller: _controller,
          count: widget.purchasedPlan.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
            activeDotColor: Colors.green.shade700,
            dotColor: Colors.green.shade200,
          ),
        ),
      ],
    );
  }


}




class PurchasedPlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;

  const PurchasedPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat("dd MMM yyyy");
    final startDate = DateTime.tryParse(plan['start_date'] ?? '');
    final endDate = DateTime.tryParse(plan['end_date'] ?? '');

    final startDateFormatted =
    startDate != null ? formatter.format(startDate) : 'N/A';
    final endDateFormatted =
    endDate != null ? formatter.format(endDate) : 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF3D3D3D),
            Color(0xFF8B6A29),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8C46A),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// -------- Glossy Overlay --------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.25,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          /// -------- Status Badge --------
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.4),
                  ],
                ),
              ),
              child: Text(
                plan['status'] ?? '',
                style: const TextStyle(
                  color: Color(0xFFFFD54F),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// -------- Content --------
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                        const Color(0xFFE8C46A).withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Color(0xFFE8C46A),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeFirst(plan["package_type"] ?? "N/A"),
                            style: const TextStyle(
                              color: Color(0xFFEEDFB5),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '₹ ${plan["amount"] ?? "0.0"}',
                            style: const TextStyle(
                              color: Color(0xFFD6C48B),
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              _goldDetail("Start", startDateFormatted),
                              _goldDetail("Expires", endDateFormatted),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                PackageProgressBar(
                  durationInDays: plan['total_membership_days'] ?? 0,
                  progressDay: plan['elapsed_days'] ?? 0,
                  billCycle: plan['bill_cycle']??'',
                  startDate: startDate,
                  endDate: endDate,
                  totalPaidAmount:  (plan['total_payout_received'] ?? 0 as num).toDouble(),
                  totalMonthlyAmount:  (plan['total_monthly_roi'] ?? 0 as num).toDouble(),
                  totalHalfYearlyAmount:  (plan['total_halfyearly_roi'] ?? 0 as num).toDouble(),
                  totalYearlyAmount:  (plan['total_yearly_roi'] ?? 0 as num).toDouble(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goldDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD8C07A),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFFFE9A8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}


class PackageProgressBar extends StatelessWidget {
  final int durationInDays;
  final int progressDay;
  final String billCycle;
  final double totalMonthlyAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalPaidAmount;
  final double totalHalfYearlyAmount;
  final double totalYearlyAmount;

  const PackageProgressBar({
    super.key,
    required this.durationInDays,
    required this.progressDay,
    required this.totalMonthlyAmount,
    required this.totalHalfYearlyAmount,
    required this.endDate,
    required this.totalPaidAmount,
    required this.totalYearlyAmount,
    required this.billCycle,
    required this.startDate,
  });


  double _getTotalAmount(String billCycle){
    
    switch(billCycle){
      case 'monthly':
        return totalMonthlyAmount;
      case 'halfYearly':
        return totalHalfYearlyAmount;
      case 'yearly':
        return totalYearlyAmount;
      default: return 0;
    }
    
  }

  int convertDaysIntoMonths(int days) {
    return (days / 30).round();
  }

  String _getBillCycleName(String billCycle){

    switch(billCycle){
      case 'monthly':
        return 'Monthly';

      case 'halfYearly':
        return 'Half Yearly';

      case 'yearly':
        return 'Yearly';

      default: return '';
    }

  }

  String _getBillNextBillCycleDate(
      DateTime? startDate,
      String billCycle,
      DateTime? endDate,
      ) {
    if (startDate == null || endDate == null) return 'Expired';

    final today = DateTime.now();

    int intervalMonths;

    switch (billCycle) {
      case 'monthly':
        intervalMonths = 1;
        break;
      case 'halfYearly':
        intervalMonths = 6;
        break;
      case 'yearly':
        intervalMonths = 12;
        break;
      default:
        return 'Expired';
    }

    DateTime nextDate = startDate;

    /// Move forward cycle-by-cycle until we reach future
    while (!nextDate.isAfter(today)) {
      nextDate = _safeAddMonths(nextDate, intervalMonths);
    }

    /// 🔥 If next cycle exceeds endDate → use endDate
    if (nextDate.isAfter(endDate)) {
      return DateFormat('dd MMM yyyy').format(endDate);
    }

    return DateFormat('dd MMM yyyy').format(nextDate);
  }



  DateTime _safeAddMonths(DateTime date, int monthsToAdd) {
    final int year = date.year + ((date.month + monthsToAdd - 1) ~/ 12);
    final int month = (date.month + monthsToAdd - 1) % 12 + 1;

    int day = date.day;
    final int lastDayOfMonth = DateTime(year, month + 1, 0).day;

    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(year, month, day).add(Duration(days: 2));
  }








  @override
  Widget build(BuildContext context) {

    final totalAmount = _getTotalAmount(billCycle);
    final progress =
    (totalPaidAmount /totalAmount ).clamp(0.0, 1.0);
    final perDayAmount = totalAmount/ durationInDays;
    // final paidAmount = perDayAmount * progressDay;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount Text
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${totalPaidAmount.toStringAsFixed(2)} / ₹${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEEDFB5)
              ),
            ),
            
            Text(
                _getBillCycleName(billCycle),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEEDFB5)
              ),
            )
          ],
        ),

        const SizedBox(height: 8),

        // Progress Bar
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: min(progress, 1),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.green,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // Footer Info
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "₹${perDayAmount.toStringAsFixed(2)} / day",
        //       style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
        //     ),
        //     Text(
        //       "$progressDay / $durationInDays days",
        //       style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
        //     ),
        //   ],
        // ),

        // const SizedBox(height: 2.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${calculateMonthsFromDays(totalAmount: totalAmount)} ${_getBillCycleName(billCycle)}",
              style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
            ),
            Text(
              '${_getBillNextBillCycleDate(startDate, billCycle, endDate)}',
              style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
            ),
          ],
        ),
      ],
    );
  }


  // String calculateMonthsFromDays(double totalAmount) {
  //   final monthCount = convertDaysIntoMonths(durationInDays);
  //   switch(billCycle){
  //     case 'monthly':
  //       return (totalAmount/monthCount).toStringAsFixed(2);
  //     case 'halfYearly':
  //       return (totalAmount/6).toStringAsFixed(2);
  //     case 'yearly':
  //       return (totalAmount).toStringAsFixed(2);
  //     default: return '0';
  //   }
  //
  // }

  String calculateMonthsFromDays({
    required double totalAmount,
  }) {
    final int totalMonths = convertDaysIntoMonths(durationInDays);

    switch (billCycle) {
      case 'monthly':
      // Always pro-rata
        return (totalAmount / totalMonths).toStringAsFixed(2);

      case 'halfYearly':
        if (totalMonths <= 6) {
          // Full amount for <= 6 months
          return totalAmount.toStringAsFixed(2);
        }
        // Pro-rata for more than 6 months
        return (totalAmount / (totalMonths / 6)).toStringAsFixed(2);

      case 'yearly':
        if (totalMonths <= 12) {

          return totalAmount.toStringAsFixed(2);
        }

        return (totalAmount / (totalMonths / 12)).toStringAsFixed(2);

      default:
        return '0.00';
    }
  }



}
