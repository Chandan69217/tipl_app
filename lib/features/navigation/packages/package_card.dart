import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/packages_api/packages_api.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';


class PackageCard extends StatefulWidget {
  final Map<String, dynamic> plan;
  final Color color;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final bool canSelect;
  final bool canEdit;
  final bool canDelete;

  const PackageCard({
    super.key,
    required this.plan,
    required this.color,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
    this.canSelect = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.canSelect ? widget.onSelect : null,
      child: Stack(
        children: [

        Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected ? widget.color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: widget.color.withOpacity(0.2),
                      child: Icon(Icons.workspace_premium,
                          size: 32, color: widget.color),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.plan["package_name"] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if(widget.canEdit || widget.canDelete)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "${widget.plan["duration_in_days"]} Days",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            widget.plan["description"] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹ ${widget.plan["amount"]}",
                                style: TextStyle(
                                  color: widget.color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if(!widget.canDelete || !widget.canEdit)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${widget.plan["duration_in_days"]} Days",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Column(
                    children: [
                      _roiRow("Monthly ROI",
                          "${widget.plan["monthly_roi_percent"]}%"),
                      _roiRow("Half-Yearly ROI",
                          "${widget.plan["halfyearly_roi_percent"]}%"),
                      _roiRow("Yearly ROI",
                          "${widget.plan["yearly_roi_percent"]}%"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ========= ACTION BUTTONS (Edit / Delete) =========
                // if (widget.canEdit || widget.canDelete)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       if (widget.canEdit)
                //         IconButton(
                //           icon: const Icon(Icons.edit, color: Colors.blue),
                //           onPressed: widget.onEdit,
                //         ),
                //
                //       if (widget.canDelete)
                //         _isLoading ? CustomCircularIndicator():IconButton(
                //           icon: const Icon(Icons.delete, color: Colors.red),
                //           onPressed: ()async{
                //             setState(() {
                //               _isLoading = true;
                //             });
                //             final deleted = await PackagesApiService().deletePackage((widget.plan['id']??'').toString());
                //             if(deleted){
                //               widget.onDelete?.call();
                //             }
                //             setState(() {
                //               _isLoading = false;
                //             });
                //           },
                //         ),
                //     ],
                //   ),
              ],
            ),
          ),

          // ========= Selection Indicator =========
          if (widget.canSelect)
            Positioned(
              right: 10,
              bottom: 0,
              top: 0,
              child: Icon(
                widget.isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: widget.isSelected ? widget.color : Colors.grey,
                size: 28,
              ),
            ),

          // ========= Selected Label =========
          if (widget.isSelected && widget.canSelect)
            Positioned(
              right: 18,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Selected Plan",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.canEdit)
                  IconButton(
                    icon: const Icon(Iconsax.edit, color: Colors.blue),
                    onPressed: widget.onEdit,
                  ),

                if (widget.canDelete)
                  _isLoading ? CustomCircularIndicator():IconButton(
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                    onPressed: ()async{
                      setState(() {
                        _isLoading = true;
                      });
                      final deleted = await PackagesApiService().deletePackage((widget.plan['id']??'').toString());
                      if(deleted){
                        widget.onDelete?.call();
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roiRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}







// class PackageCard extends StatelessWidget {
//   final Map<String, dynamic> plan;
//   final Color color;
//   final bool isSelected;
//   final VoidCallback onSelect;
//
//   const PackageCard({
//     super.key,
//     required this.plan,
//     required this.color,
//     required this.isSelected,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onSelect,
//       child: Stack(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.10),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: isSelected ? color : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 28,
//                       backgroundColor: color.withOpacity(0.2),
//                       child: Icon(Icons.workspace_premium,
//                           size: 32, color: color),
//                     ),
//
//                     const SizedBox(width: 14),
//
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Package Name
//                           Text(
//                             plan["package_name"] ?? 'N/A',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//
//                           const SizedBox(height: 4),
//
//                           // Description
//                           Text(
//                             plan["description"] ?? '',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.black54,
//                             ),
//                           ),
//
//                           const SizedBox(height: 10),
//
//                           // Amount & Duration Row
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "₹ ${plan["amount"]}",
//                                 style: TextStyle(
//                                   color: color,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//
//                             ],
//                           ),
//
//                         ],
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         "${plan["duration_in_days"]} Days",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     // Radio icon
//
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//
//                 // ROI DETAILS
//                 Padding(
//                   padding: const EdgeInsets.only(right: 24.0),
//                   child: Column(
//                     children: [
//                       _roiRow("Monthly ROI", "${plan["monthly_roi_percent"]}%"),
//                       _roiRow("Half-Yearly ROI",
//                           "${plan["halfyearly_roi_percent"]}%"),
//                       _roiRow(
//                           "Yearly ROI", "${plan["yearly_roi_percent"]}%"),
//                     ],
//                   ),
//                 )
//
//                 // const SizedBox(height: 8),
//
//                 // // Status Badge
//                 // Align(
//                 //   alignment: Alignment.bottomRight,
//                 //   child: Container(
//                 //     padding: const EdgeInsets.symmetric(
//                 //         horizontal: 10, vertical: 4),
//                 //     decoration: BoxDecoration(
//                 //       color: plan["status"] == "Active"
//                 //           ? Colors.green
//                 //           : Colors.red,
//                 //       borderRadius: BorderRadius.circular(12),
//                 //     ),
//                 //     child: Text(
//                 //       plan["status"] ?? "N/A",
//                 //       style: const TextStyle(
//                 //           color: Colors.white, fontSize: 11),
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//           Positioned(
//             right: 10,
//             bottom: 0,
//             top: 0,
//             child: Icon(
//               isSelected
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: isSelected ? color : Colors.grey,
//               size: 28,
//             ),
//           ),
//           // Selected Label
//           if (isSelected)
//             Positioned(
//               right: 18,
//               top: 0,
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   "Selected Plan",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _roiRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Text(label,
//               style: const TextStyle(fontSize: 12, color: Colors.black54)),
//           const Spacer(),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }