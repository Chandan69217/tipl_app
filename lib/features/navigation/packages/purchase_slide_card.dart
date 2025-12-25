import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

              final formatter = DateFormat("dd MMM yyyy");
              final startDate = DateTime.tryParse(plan['start_date'] ?? '');
              final endDate = DateTime.tryParse(plan['end_date'] ?? '');
              final startDateFormatted =
              startDate != null ? formatter.format(startDate) : 'N/A';
              final endDateFormatted =
              endDate != null ? formatter.format(endDate) : 'N/A';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1A1A1A),
                      Color(0xFF3D3D3D),
                      Color(0xFF8B6A29), // Dark gold shade
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE8C46A), // Soft gold border
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

                    // -------- Glossy Shine Overlay --------
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

                    Positioned(
                      top: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                      child: Text('Active',
                      style: TextStyle(
                        color:  Color(0xFFFFD54F),
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    )),


                    // -------- Content --------
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
                                  color: const Color(0xFFE8C46A).withValues(alpha: 0.2),
                                ),
                                child: const Icon(
                                  Icons.workspace_premium_rounded,
                                  color: Color(0xFFE8C46A),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Title + Plan
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${plan["package_type"] ?? "N/A"} Membership",
                                      style: TextStyle(
                                        color: Color(0xFFEEDFB5),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      plan["package_type"] ?? "N/A",
                                      style: const TextStyle(
                                        color: Color(0xFFD6C48B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                          const SizedBox(height: 18),
                          PackageProgressBar(
                            durationInDays: plan['durationInDays']??0,
                            progressDay: plan['progress_day']??0,
                            totalAmount: (plan['amount']??0 as num).toDouble(),
                            usedAmount: (plan['usedAmount']??0 as num).toDouble(),
                            perDayAmount: (plan['perDayAmount']??0 as num).toDouble(),
                          ),

                          // const SizedBox(height: 14),
                          //
                          // // ------------ Details Row 1 ------------
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     _goldDetail("Status", plan["status"] ?? "N/A"),
                          //     _goldDetail("Amount", "₹${plan["amount"] ?? '0'}"),
                          //   ],
                          // ),

                          // const SizedBox(height: 6),
                          //
                          // // ------------ Details Row 2 ------------
                          // Expanded(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       _goldDetail("Start", startDateFormatted),
                          //       _goldDetail("Expires", endDateFormatted),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),


                  ],
                ),
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

  Widget _goldDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD8C07A),
            fontSize: 11,
            fontWeight: FontWeight.w400,
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



  Widget _detailItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}




class PackageProgressBar extends StatelessWidget {
  final int durationInDays;
  final int progressDay;
  final double totalAmount;
  final double usedAmount;
  final double perDayAmount;

  const PackageProgressBar({
    super.key,
    required this.durationInDays,
    required this.progressDay,
    required this.totalAmount,
    required this.usedAmount,
    required this.perDayAmount,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
    (progressDay / durationInDays).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount Text
        Text(
          "₹${usedAmount.toStringAsFixed(2)} / ₹${totalAmount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEDFB5)
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${perDayAmount.toStringAsFixed(2)} / day",
              style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
            ),
            Text(
              "$progressDay / $durationInDays days",
              style: TextStyle(fontSize: 12, color: Color(0xFFFFE9A8)),
            ),
          ],
        ),
      ],
    );
  }
}
