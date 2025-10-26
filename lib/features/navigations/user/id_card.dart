// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:tipl_app/api_service/api_url.dart';
// import 'package:tipl_app/api_service/handle_reposone.dart';
// import 'package:tipl_app/api_service/log_api_response.dart';
// import 'package:tipl_app/core/utilities/preference.dart';
// import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
//
// class IdCardScreen extends StatefulWidget {
//   const IdCardScreen({super.key});
//
//   @override
//   State<IdCardScreen> createState() => _IdCardScreenState();
// }
//
// class _IdCardScreenState extends State<IdCardScreen> {
//
//   // final Map<String, dynamic> userData = {
//   //   "idNo": "TIPL275542",
//   //   "name": "DHARMENDRA KUMAR",
//   //   "mobile": "8271323204",
//   //   "address": "Vill Manichak, PO Deepnagar, Nalanda",
//   //   "companyAddress":
//   //   "1st Floor, Madhu Heritage, Tribhuvan Mor, Vijay Singh Yadav Path, Patna - 801503",
//   //   "website": "www.tipl.one",
//   //   "email": "info@tipl.one",
//   // };
//
//   Map<String, dynamic> userData = {};
//
//   Future<Uint8List> _generatePdf() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a6,
//         build: (context) => pw.Container(
//           decoration: pw.BoxDecoration(
//             borderRadius: pw.BorderRadius.circular(10),
//             border: pw.Border.all(color: PdfColors.blueGrey, width: 2),
//           ),
//           padding: const pw.EdgeInsets.all(12),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Center(
//                 child: pw.Text(
//                   "IDENTITY CARD",
//                   style: pw.TextStyle(
//                     fontSize: 18,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blue,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text("Identity No. : ${userData['idNo']}"),
//               pw.Text("Name : ${userData['name']}"),
//               pw.Text("Mobile No. : ${userData['mobile']}"),
//               pw.Text("Address : ${userData['address']}"),
//               pw.SizedBox(height: 15),
//               pw.Divider(),
//               pw.Text(userData['companyAddress']),
//               pw.Text("Website : ${userData['website']}"),
//               pw.Text("Email : ${userData['email']}"),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     return pdf.save();
//   }
//
//   Future<void> _sharePdf() async {
//     await Printing.sharePdf(
//       bytes: await _generatePdf(),
//       filename: 'ID Card.pdf',
//     );
//   }
//
//
//   Future<Map<String,dynamic>?> _getIDCardDetails()async{
//     final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
//     final token = Pref.instance.getString(PrefConst.TOKEN);
//     try{
//       final url = Uri.https(Urls.baseUrl,Urls.userIdCard,{
//         'member_id' : member_id
//       });
//
//       final response = await get(url,headers: {
//         'Authorization' : 'Bearer $token',
//         'Content-type' : 'Application/json'
//       });
//       printAPIResponse(response);
//       if(response.statusCode == 200){
//         final body = json.decode(response.body) as Map<String,dynamic>;
//         final status = body['isSuccess']??false;
//         if(status){
//           final data = body['data'] as List<dynamic>;
//           return data.first as Map<String,dynamic>;
//         }
//       }else{
//         handleApiResponse(context, response);
//       }
//     }catch(exception,trace){
//       print("Exception: ${exception},Trace: ${trace}");
//     }
//     return null;
//   }
//
//   void _printPdf() async {
//     final pdfBytes = await _generatePdf();
//     await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final data = userData;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ID Card"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: _sharePdf,
//           ),
//           IconButton(
//             icon: const Icon(Icons.print),
//             onPressed: _printPdf,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(12),
//         child: Card(
//           elevation: 8,
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade50, Colors.blue.shade100],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: FutureBuilder<Map<String,dynamic>?>(
//                 future: _getIDCardDetails(),
//                 builder: (context,snapshot){
//                   if(snapshot.connectionState == ConnectionState.waiting){
//                     return CustomCircularIndicator();
//                   }
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "IDENTITY CARD",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 35,
//                             backgroundColor: Colors.blue[200],
//                             child: const Icon(Icons.person, size: 40),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Name: ${data['full_name']??'N/A'}",
//                                     style:
//                                     const TextStyle(fontWeight: FontWeight.bold)),
//                                 Text("Member ID: ${data['member_id']??'N/A'}"),
//                                 Text("Mobile: ${data['mobile_no']??'N/A'}"),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const Divider(height: 12),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Address: ${data['address']??'N/A'}"),
//                             const SizedBox(height: 6),
//                             Text("Website: www.neuralpool.in"),
//                             Text("Email: ${data['email']}"),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         data['companyAddress'],
//                         style: const TextStyle(fontSize: 12, color: Colors.black54),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   );
//                 }
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await _getIDCardDetails();
    if (data != null) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _getIDCardDetails() async {
    final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try {
      final url = Uri.https(Urls.baseUrl, Urls.userIdCard, {'member_id': memberId});

      final response = await get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isSuccess'] ?? false;
        if (status) {
          final data = body['data'] as List<dynamic>;
          return data.first as Map<String, dynamic>;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: $exception, Trace: $trace");
    }
    return null;
  }


  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (context) => pw.Container(
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(10),
            border: pw.Border.all(color: PdfColors.blueGrey, width: 2),
          ),
          padding: const pw.EdgeInsets.all(12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "IDENTITY CARD",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Member ID : ${userData['member_id'] ?? 'N/A'}"),
              pw.Text("Full Name : ${userData['full_name'] ?? 'N/A'}"),
              pw.Text("Mobile No. : ${userData['mobile_no'] ?? 'N/A'}"),
              pw.Text("Email : ${userData['email'] ?? 'N/A'}"),
              pw.Text("Gender : ${userData['gender'] ?? 'N/A'}"),
              pw.Text("State : ${userData['state'] ?? 'N/A'}"),
              pw.Text("District : ${userData['district'] ?? 'N/A'}"),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text(
                  "Company: Neural Pool Pvt. Ltd.\n1st Floor, Madhu Heritage, Tribhuvan Mor, Vijay Singh Yadav Path, Patna - 801503"),
              pw.Text("Website : www.neuralpool.in"),
              pw.Text("Email : info@neuralpool.in"),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  void _printPdf() async {
    final pdfBytes = await _generatePdf();
    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  Future<void> _sharePdf() async {
    await Printing.sharePdf(
      bytes: await _generatePdf(),
      filename: 'ID_Card_${userData['member_id'] ?? 'N/A'}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ID Card"),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _sharePdf),
          IconButton(icon: const Icon(Icons.print), onPressed: _printPdf),
        ],
      ),
      body: isLoading
          ? const Center(child: CustomCircularIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "IDENTITY CARD",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue[200],
                      child: const Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ${userData['full_name'] ?? 'N/A'}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "Member ID: ${userData['member_id'] ?? 'N/A'}"),
                          Text(
                              "Mobile: ${userData['mobile_no'] ?? 'N/A'}"),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gender: ${userData['gender'] ?? 'N/A'}"),
                      Text("State: ${userData['state'] ?? 'N/A'}"),
                      Text("District: ${userData['district'] ?? 'N/A'}"),
                      const SizedBox(height: 6),
                      Text("Email: ${userData['email'] ?? 'N/A'}"),
                      const Text("Website: www.neuralpool.in"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "1st Floor, Madhu Heritage, Tribhuvan Mor, Vijay Singh Yadav Path, Patna - 801503",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
