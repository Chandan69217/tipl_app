import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/meeting_api/meeting_api_service.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/connectivity/on_internet_screen.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/features/navigations/meetings/add_meeting_screen.dart';
import 'package:url_launcher/url_launcher.dart';



class MeetingListScreen extends StatefulWidget {

  const MeetingListScreen({
    super.key,
  });

  @override
  State<MeetingListScreen> createState() => _MeetingListScreenState();

}

class _MeetingListScreenState extends State<MeetingListScreen> {
  String selectedStatus = "All";
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = "";
  List<dynamic> meetings =  [];
  bool _isLoading = false;

  List<dynamic> get filteredMeetings {
    return meetings.where((meeting) {
      final status = (meeting["status"] ?? "").toString();
      final title = (meeting["title"] ?? "").toLowerCase();
      final desc = (meeting["description"] ?? "").toLowerCase();
      final date = DateTime.tryParse(meeting["meeting_date"] ?? "");

      bool matchesStatus = selectedStatus == "All" || status == selectedStatus;
      bool matchesSearch = title.contains(searchQuery.toLowerCase()) || desc.contains(searchQuery.toLowerCase());
      bool matchesDate = true;

      if (startDate != null && date != null) {
        matchesDate = date.isAfter(startDate!.subtract(const Duration(days: 1)));
      }
      if (endDate != null && date != null) {
        matchesDate = matchesDate && date.isBefore(endDate!.add(const Duration(days: 1)));
      }

      return matchesStatus && matchesSearch && matchesDate;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  void init()async{
    _isLoading = true;
    meetings = await MeetingApiService(context: context).getAllMeetings();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: ConnectivityService().isConnected,
        builder: (context,value,child){
          if(value){
            return NoInternetScreen(onRetry: ()async{
              setState(() {
                _isLoading = true;
              });
              meetings = await MeetingApiService(context: context).getAllMeetings();
              setState(() {
                _isLoading = false;
              });
            });
          }
          return  Column(
            children: [
              // _searchBar(),
              _filterOptions(context),
              const Divider(height: 20),
              Align( alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Icon(Iconsax.profile_2user,color: Colors.blueAccent,),
                        const SizedBox(width: 6,),
                        Text('Meetings',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                      ],
                    ),
                  )),
              _isLoading ? CustomCircularIndicator():
              Expanded(
                child: filteredMeetings.isEmpty
                    ? const Center(
                  child: Text(
                    "No meetings found",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMeetings.length,
                  itemBuilder: (context, index) {
                    final meeting = filteredMeetings[index];
                    final dateTime = DateTime.tryParse(meeting["meeting_date"] ?? "");
                    final formattedDate = dateTime != null
                        ? DateFormat("dd MMM yyyy, hh:mm a").format(dateTime)
                        : "N/A";
                    return _meetingCard(context, meeting, formattedDate);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent, // Deep Purple Accent
        foregroundColor: Colors.white,
        icon: const Icon(Iconsax.video_add,),
        label: const Text(
          "Schedule",
        ),
        onPressed: () {
          AddMeetingScreen.show(context,onSave: (success){
            if(success){
              init();
            }
          });
        },
      ),

    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search meetings...",
          prefixIcon: const Icon(Iconsax.search_normal_1),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) => setState(() => searchQuery = value),
      ),
    );
  }


  Widget _filterOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [

              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: InputDecoration(
                    labelText: "Status",
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelStyle: TextStyle(color: Colors.black)
                  ),
                  items: ["All", "Scheduled", "Completed", "Cancelled"]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedStatus = value ?? "All"),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Iconsax.refresh, color: Colors.red),
                tooltip: "Reset Filters",
                onPressed: () {
                  setState(() {
                    selectedStatus = "All";
                    startDate = null;
                    endDate = null;
                    searchQuery = "";
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _datePickerField(
                  context,
                  "Start Date",
                  startDate,
                      (picked) => setState(() => startDate = picked),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _datePickerField(
                  context,
                  "End Date",
                  endDate,
                      (picked) => setState(() => endDate = picked),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _datePickerField(BuildContext context, String label, DateTime? selectedDate, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          suffixIcon: const Icon(Iconsax.calendar_1, size: 18),
        ),
        child: Text(
          selectedDate != null ? DateFormat("dd MMM yyyy").format(selectedDate) : "Select",
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }


Widget _meetingCard(BuildContext context, Map<String, dynamic> meeting, String formattedDate) {
  final status = (meeting["status"] ?? "Unknown").toString();
  final statusColor = _getStatusColor(status);

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧾 Title + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meeting["title"] ?? "Untitled Meeting",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Chip(
                label: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: statusColor.withValues(alpha: 0.15),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // 🗓️ Date & Time
          Row(
            children: [
              const Icon(Iconsax.calendar_1, color: Colors.teal, size: 18),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // 📝 Description
          Text(
            meeting["description"] ?? "No description available.",
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _joinMeeting(meeting["meeting_link"]),
                icon: const Icon(Iconsax.video, size: 18),
                label: const Text("Join Meeting"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12,),
              TextButton.icon(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: meeting["meeting_link"]??''));
                  },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey
                ),
                  label: Text('Copy link'),
                icon:  Icon(Iconsax.copy),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.green;
      case "completed":
        return Colors.blue;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _joinMeeting(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


}




