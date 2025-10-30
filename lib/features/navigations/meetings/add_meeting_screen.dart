import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/meeting_api/meeting_api_service.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';

class AddMeetingScreen extends StatefulWidget {
  final void Function(bool isSuccess) onSave;
  final Map<String,dynamic>? data;
  const AddMeetingScreen({super.key, required this.onSave,this.data});

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();

  static void show(BuildContext context, {Function(bool)? onSave,Map<String,dynamic>? data}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: AddMeetingScreen(
          data: data,
          onSave: (isSuccess) {
            if (onSave != null) {
              onSave(isSuccess);
            }
          },
        ),
      ),
    );

  }

}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if(widget.data != null)
    init();
  }

  init()async{
    _titleController.text = widget.data?['title']??'';
    _descriptionController.text = widget.data?['description']??'';
    _dateTimeController.text = widget.data?['meeting_date']??'';
    _linkController.text = widget.data?['meeting_link']??'';
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Text(
                    "Add New Meeting",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 📝 Title
                  CustomTextField(
                    controller: _titleController,
                    label: "Meeting Title",
                    isRequired: true,
                  ),

                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: _pickDateTime,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _dateTimeController,
                        suffixIcon: Icon(Iconsax.calendar),
                        label: "Date & Time",
                        isRequired: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔗 Meeting Link
                  CustomTextField(
                    controller: _linkController,
                    prefixIcon: Icon(Iconsax.link_1),
                    label: "Meeting Link",
                    isRequired: true,
                  ),

                  const SizedBox(height: 16),

                  // 📖 Description
                  CustomTextField(
                    controller: _descriptionController,
                    label: "Description",
                    maxLine: 3,
                  ),

                  const SizedBox(height: 20),

                  // ✅ Save Button
                  _isLoading ? CustomCircularIndicator() : CustomButton(
                      text: "Save Meeting",
                      onPressed: _saveMeeting,
                    iconData: Iconsax.save_2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _selectedDateTime = selected;
      _dateTimeController.text = DateFormat("yyyy-MM-dd HH:mm").format(selected);
    });
  }

  void _saveMeeting() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    final isScheduled = await MeetingApiService(context: context).addNewMeeting(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        meeting_date: _selectedDateTime?.toIso8601String()??'',
        meeting_link: _linkController.text.trim(),
    );

    widget.onSave(isScheduled);
    if(isScheduled){
      setState(() {
        _titleController.text = '';
        _descriptionController.text = '';
        _selectedDateTime = null;
        _linkController.text = '';
        _dateTimeController.text = '';
      });
    }

    setState(() {
      _isLoading =false;
    });
  }
}
