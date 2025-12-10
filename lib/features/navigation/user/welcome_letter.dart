import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/connectivity/on_internet_screen.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';


class WelcomeLetterScreen extends StatefulWidget {


  WelcomeLetterScreen({super.key,});

  @override
  State<WelcomeLetterScreen> createState() => _WelcomeLetterScreenState();

  static Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  static pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "$label:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(flex: 3, child: pw.Text(value)),
        ],
      ),
    );
  }
}

class _WelcomeLetterScreenState extends State<WelcomeLetterScreen> {
  late final Future<Map<String,dynamic>?> offerLetter;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    offerLetter = ProfileAPIService(context: context).getWelcomeLetterDetails();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Letter"),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: ConnectivityService().isConnected,
        builder: (BuildContext context, value, Widget? child) {
          if(value){
            return NoInternetScreen(onRetry: (){
              setState(() {
                offerLetter = ProfileAPIService(context: context).getWelcomeLetterDetails();
              });
            });
          }else{
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder(
                  future: offerLetter,
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CustomCircularIndicator();
                    }
                    if(snapshot.hasData && snapshot.data != null){
                      final data = snapshot.data!;
                      final joinDate = DateTime.parse(data["createdAt"]);
                      final formattedDate = DateFormat('dd MMMM yyyy').format(joinDate);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: const [
                                Text(
                                  "NEURALPOOL FINANCE INFRASTRUCTURE PVT. LTD.",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "1st Floor, Madhu Heritage, Tribhuvan Mor, Vijay Singh Yadav Path, Patna - 801503",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                Text(
                                  "Website: www.neuralpool.in  |   Email: info@tipl.one",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Congrats!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("${data["full_name"]}"),
                          Text("${data["district"]}, ${data["state"]}"),
                          Text("Mobile No: ${data["mobile_no"]}"),
                          const SizedBox(height: 12),
                          const Text(
                            "On joining hands with NEURALPOOL FINANCE INFRASTRUCTURE PVT. LTD., "
                                "you have taken a wise decision towards development and "
                                "fulfillment of your life's prosperity and dreams.",
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Membership Details",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          WelcomeLetterScreen._buildRow("Member ID", data["member_id"]),
                          WelcomeLetterScreen._buildRow("Sponsor ID", data["sponsor_id"]),
                          WelcomeLetterScreen._buildRow("Sponsor Name", data["sponsor_name"]),
                          WelcomeLetterScreen._buildRow("Position", data["position"]),
                          WelcomeLetterScreen._buildRow("Status", data["status"]),
                          WelcomeLetterScreen._buildRow("Date of Joining", formattedDate),
                          const SizedBox(height: 20),
                          const Text(
                            "Note: Being our member, you accept all terms and conditions of membership "
                                "and will abide by the same as a member. Your efforts will lead you to success. "
                                "We wish you a great future ahead.",
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () => _printLetter(data),
                                  iconData: Iconsax.printer,
                                  text: "Print Letter",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _isLoading ?CustomCircularIndicator() : CustomButton(
                                  onPressed: () => _exportPdf(data),
                                  iconData: Iconsax.share,
                                  text: 'Share as PDF',
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }else{
                      return Center(
                        child: Text('Something went wrong !'),
                      );
                    }
                  }
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _printLetter(Map<String, dynamic> data) async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, data));
  }

  Future<void> _exportPdf(Map<String, dynamic> data) async {
    setState(() {
      _isLoading = true;
    });
    await Printing.sharePdf(
      bytes: await _generatePdf(PdfPageFormat.a4, data),
      filename: 'Welcome_Letter_${data["member_id"]}.pdf',
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format,
      Map<String, dynamic> data,
      ) async {
    final pdf = pw.Document();
    final joinDate = DateFormat('dd MMMM yyyy').format(
      DateTime.parse(data["createdAt"]),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "NEURALPOOL FINANCE INFRASTRUCTURE PVT. LTD.",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "1st Floor, Madhu Heritage, Tribhuvan Mor, Vijay Singh Yadav Path, Patna - 801503",
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        "Website: www.tipl.one | Email: info@tipl.one",
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  "Congrats!",
                  style: pw.TextStyle(fontSize: 20, color: PdfColors.teal),
                ),
                pw.Text(data["full_name"]),
                pw.Text("${data["district"]}, ${data["state"]}"),
                pw.Text("Mobile No: ${data["mobile_no"]}"),
                pw.SizedBox(height: 10),
                pw.Text(
                  "On joining hands with TRSKGALAXY INFRASTRUCTURE PVT. LTD., you have taken a wise decision towards development and prosperity.",
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  "Membership Details",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                pw.Divider(),
                WelcomeLetterScreen._pdfRow("Member ID", data["member_id"]),
                WelcomeLetterScreen._pdfRow("Sponsor ID", data["sponsor_id"]),
                WelcomeLetterScreen._pdfRow("Sponsor Name", data["sponsor_name"]),
                WelcomeLetterScreen._pdfRow("Position", data["position"]),
                WelcomeLetterScreen._pdfRow("Status", data["status"]),
                WelcomeLetterScreen._pdfRow("Date of Joining", joinDate),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Note: Being our member, you accept all terms and conditions of membership and will abide by the same as a member. You bear all responsibilities of your information provided on www.tipl.one.",
                ),
                pw.SizedBox(height: 30),
                pw.Text("TRSKGALAXY INFRASTRUCTURE PVT. LTD."),
                pw.SizedBox(height: 10),
                pw.Text(
                  "(This is a computer-generated document and does not require a seal or signature.)",
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );

    setState(() {
      if(mounted){
        _isLoading = false;
      }
    });
    return await pdf.save();
  }
}
