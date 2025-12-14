import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/providers/income_provider/income_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';


import '../packages/purchase_slide_card.dart';

class UserHomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Balance & Actions
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
          //       child: BalanceCard(),
          //     ),
          //     // My Cards Header
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:0),
          //       child: const Text(
          //         "My Cards",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 12.0,),
          //     // const SizedBox(height: 12),
          //     // Cards Horizontalcroll
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 8),
          //       child: SizedBox(
          //         height: 180,
          //         child: ClipRRect(
          //           borderRadius: BorderRadiusGeometry.circular(20),
          //           child: ListView(
          //             scrollDirection: Axis.horizontal,
          //             children: const [
          //               BankCard(
          //                 cardlabel: 'Balance Withdraw',
          //                 balance: "\₹157,578.00",
          //                 cardNumber: "xxxx xxxx xxxx 6789",
          //                 validThru: "18/29",
          //                 logo: 'Wallet',
          //               ),
          //               SizedBox(width: 16),
          //               BankCard(
          //                 cardlabel: 'Balance',
          //                 balance: "\₹20,560.00",
          //                 cardNumber: "xxxx xxxx xxxx 8469",
          //                 validThru: "03/27",
          //                 logo: 'Wallet',
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 20,),
          //     // Bottom Navigation
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         BottomAction(
          //           icon: Iconsax.send,
          //           label: "Send",
          //           colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Purple → Blue
          //         ),
          //         BottomAction(
          //           icon: Iconsax.wallet,
          //           label: "Wallet",
          //           colors: [Color(0xFF11998E), Color(0xFF38EF7D)], // Teal → Green
          //         ),
          //         BottomAction(
          //           icon: Iconsax.shopping_bag,
          //           label: "Shop",
          //           colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)], // Pink → Red
          //         ),
          //         BottomAction(
          //           icon: Iconsax.star,
          //           label: "Rewards",
          //           colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)], // Orange → Red
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          // Consumer<IncomeProvider>(
          //   builder: (BuildContext context, IncomeProvider value, Widget? child) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //       child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children:[
          //             const Text("Summary",
          //                 style: TextStyle(
          //                     fontSize: 16, fontWeight: FontWeight.w600)),
          //             const SizedBox(height: 8,),
          //             Row(
          //               children: const [
          //                 _SummaryCard(
          //                   title: "Total Income",
          //                   value: "₹2,50,000",
          //                   icon: Icons.trending_up,
          //                   gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)], // Green gradient
          //                 ),
          //                 _SummaryCard(
          //                   title: "Cashback Earned",
          //                   value: "₹3,560",
          //                   icon: Icons.card_giftcard,
          //                   gradientColors: [Color(0xFFFF416C), Color(0xFFFF4B2B)], // Pink → Red
          //                 ),
          //               ],
          //             ),
          //           ]
          //       ),
          //     );
          //   },
          // ),


          // membership
         Consumer<WalletProvider>(
           builder: (BuildContext context, WalletProvider value, Widget? child) {
             return child??SizedBox.shrink();
           },
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Purchased Packages',
                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                 ),
                 const SizedBox(height: 10,),
                 Consumer<WalletProvider>(

                   builder: (BuildContext context, WalletProvider value, Widget? child) {
                     return PurchasedPlanSlider(purchasedPlan: value.memberships);
                   },
                 ),
               ],
             ),
           ),
         ),

          // Summary Section
      Consumer<IncomeProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Summary Grid
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    _SummaryCard(
                      title: "Total Income",
                      value: "₹${provider.totalAllIncome}",
                      icon: Icons.trending_up,
                      gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                    ),
                    _SummaryCard(
                      title: "Cashback Income",
                      value: "₹${provider.totalCashbackIncome}",
                      icon: Icons.card_giftcard,
                      gradientColors: const [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                    ),
                    // _SummaryCard(
                    //   title: "Direct Income",
                    //   value: "₹${provider.totalDirectIncome}",
                    //   icon: Icons.person_add_alt,
                    //   gradientColors: const [Color(0xFF0061FF), Color(0xFF60EFFF)],
                    // ),
                    // _SummaryCard(
                    //   title: "Level Income",
                    //   value: "₹${provider.totalLevelIncome}",
                    //   icon: Icons.stacked_line_chart,
                    //   gradientColors: const [Color(0xFFFC4A1A), Color(0xFFF7B733)],
                    // ),
                    // _SummaryCard(
                    //   title: "Matching Income",
                    //   value: "₹${provider.totalMatchingIncome}",
                    //   icon: Icons.join_inner,
                    //   gradientColors: const [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    // ),
                    // _SummaryCard(
                    //   title: "Daily Income",
                    //   value: "₹${provider.totalDailyIncome}",
                    //   icon: Icons.calendar_today,
                    //   gradientColors: const [Color(0xFF1FA2FF), Color(0xFF12D8FA)],
                    // ),
                    _SummaryCard(
                      title: "Salary Income",
                      value: "₹${provider.totalSalaryIncome}",
                      icon: Icons.payments,
                      gradientColors: const [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                    ),
                    // _SummaryCard(
                    //   title: "Rewards Income",
                    //   value: "₹${provider.totalRewardsIncome}",
                    //   icon: Icons.card_giftcard_outlined,
                    //   gradientColors: const [Color(0xFFFF8008), Color(0xFFFFC837)],
                    // ),
                  ],
                ),
              ],
            ),
          );
        },
      ),


      const SizedBox(height: 20,),
          // Chart & Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Spending Overview",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 200, child: _SpendingChart()),

                const SizedBox(height: 20),
                const Text("Recent Transactions",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),

                Consumer<WalletProvider>(
                  builder: (context, value, child) {
                    return value.transaction.isEmpty ? Text("No transaction available"):ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: value.transaction.length < 5 ?value.transaction.length : 5,
                      itemBuilder: (BuildContext context, int index) {
                        return _transactionItem(
                            data:  value.transaction[index]
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),

        ],
      ),
    );
  }


  Widget _transactionItem({
    required WalletTransaction data
  }) {
    final isCredit = data.txnType.toLowerCase() == 'credit';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCredit ? Colors.green.withValues(alpha: 0.1):Colors.red.withValues(alpha: 0.1),
        child: Icon(
          isCredit ? Iconsax.received : Iconsax.send,
          color: isCredit ? Colors.green:Colors.red,
        ),
      ),
      title: Text(data.source,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(data.formattedDate, style: const TextStyle(fontSize: 12)),
      trailing: Text('${isCredit ? '+' : '-'}'+'${data.amount}',
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: isCredit ? Colors.green:Colors.red,)
      ),
    );
  }



}



// Spending Chart
// class _SpendingChart extends StatelessWidget {
//   const _SpendingChart();
//
//   @override
//   Widget build(BuildContext context) {
//     return PieChart(
//       PieChartData(
//         sectionsSpace: 2,
//         centerSpaceRadius: 40,
//         sections: [
//           PieChartSectionData(
//               color: Colors.blue, value: 40, title: "Food", radius: 50),
//           PieChartSectionData(
//               color: Colors.orange, value: 30, title: "Bills", radius: 50),
//           PieChartSectionData(
//               color: Colors.green, value: 20, title: "Shopping", radius: 50),
//           PieChartSectionData(
//               color: Colors.purple, value: 10, title: "Other", radius: 50),
//         ],
//       ),
//     );
//   }
// }

class _SpendingChart extends StatelessWidget {
  const _SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        final data = [
          {"label": "Direct", "value": provider.totalDirectIncome},
          {"label": "Level", "value": provider.totalLevelIncome},
          {"label": "Cashback", "value": provider.totalCashbackIncome},
          {"label": "Matching", "value": provider.totalMatchingIncome},
          {"label": "Daily", "value": provider.totalDailyIncome},
          {"label": "Salary", "value": provider.totalSalaryIncome},
          {"label": "Rewards", "value": provider.totalRewardsIncome},
        ];

        final filtered = data.where((e) => (e["value"] as num) > 0).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text("No income data available"),
          );
        }

        final colors = [
          Colors.blueAccent,
          Colors.orangeAccent,
          Colors.green,
          Colors.purpleAccent,
          Colors.teal,
          Colors.redAccent,
          Colors.pinkAccent,
        ];

        return PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 36,
            sections: List.generate(
              filtered.length,
                  (i) {
                final label = filtered[i]["label"] as String;
                final value = (filtered[i]["value"] as num).toDouble();

                return PieChartSectionData(
                  title: label,
                  value: value,
                  color: colors[i % colors.length],
                  radius: 55,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}




// class _SummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final List<Color> gradientColors;
//
//   const _SummaryCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.gradientColors,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 6),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: gradientColors),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: gradientColors.last.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: Colors.white, size: 28),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(color: Colors.white70, fontSize: 13),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: gradientColors),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BankCard extends StatelessWidget {
  final String balance;
  final String cardNumber;
  final String validThru;
  final String logo;
  final String cardlabel;

  const BankCard({
    super.key,
    required this.balance,
    required this.cardNumber,
    required this.validThru,
    required this.logo,
    required this.cardlabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A11CB),
            Color(0xFF2575FC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative background circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardlabel,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    // Placeholder for logo text
                    // Icon(
                    //   logo,
                    //   color: CustColors.white,
                    // )
                    Text(
                      logo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  balance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // Card number and validity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      validThru,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final List<Color> colors;

  const BottomAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.colors = const [Color(0xFF6A11CB), Color(0xFF2575FC)], // default gradient
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: colors.last.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}


class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    double totalCreditLimit = 50000;
    double usedCredit = 20560;
    double remainingCredit = totalCreditLimit - usedCredit;
    double progress = usedCredit / totalCreditLimit;


    const List<Color> cardGradient = [
      Color(0xFF373B44), // Dark Gray-Blue
      Color(0xFF4286f4), // Bright Blue
      Color(0xFF6dd5ed), // Aqua
    ];


    const List<Color> progressGradient = [
      Color(0xFFFFA751), // Orange
      Color(0xFFFF5858), // Reddish
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Credit",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "\₹ ${usedCredit.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // Credit limit info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Credit Use: \₹${totalCreditLimit.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Remaining: \₹${remainingCredit.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.transparent, // placeholder
              ),
            ),
          ),
          // Overlay gradient on progress
          LayoutBuilder(
            builder: (context, constraints) {
              return Transform.translate(
                offset: const Offset(0, -12), // overlay on top
                child: Container(
                  height: 12,
                  width: constraints.maxWidth * progress,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: progressGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


