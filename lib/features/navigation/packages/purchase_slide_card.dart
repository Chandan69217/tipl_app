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
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.purchasedPlan.length,
            padEnds: false,
            itemBuilder: (context, index) {
              final plan = widget.purchasedPlan[index];

              final formatter = DateFormat("dd MMM yyyy");
              final createdDate = DateTime.tryParse(plan['createdAt'] ?? '');
              final createdDateFormatted =
              createdDate != null ? formatter.format(createdDate) : 'N/A';
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
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.transparent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   right: 0,
                    //   bottom: 0,
                    //   child: Container(
                    //     height: 110,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(24),
                    //       gradient: LinearGradient(
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //         stops: const [0.0, 0.30, 1.0],
                    //         colors: [
                    //           Colors.white.withOpacity(0.55),       // intense glossy reflection
                    //           Colors.white.withOpacity(0.18),       // fade
                    //           Colors.transparent,                   // blend
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

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
                                  color: const Color(0xFFE8C46A).withOpacity(0.2),
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
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ------------ Details Row 1 ------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _goldDetail("Status", plan["status"] ?? "N/A"),
                              _goldDetail("Amount", "₹${plan["amount"] ?? '0'}"),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // ------------ Details Row 2 ------------
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _goldDetail("Start", createdDateFormatted),
                                _goldDetail("Expires", plan["expiry_date"] ?? "N/A"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              );

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ---------- HEADER ----------
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Iconsax.verify5,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Active Membership",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              plan["package_type"] ?? 'N/A',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// ---------- DETAILS ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _detailItem("Status", plan["status"] ?? 'N/A'),
                        _detailItem("Amount", "₹${plan["amount"] ?? '0'}"),
                        _detailItem("Start", createdDateFormatted),
                        _detailItem("Expires", plan["expiry_date"] ?? 'N/A'),
                      ],
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