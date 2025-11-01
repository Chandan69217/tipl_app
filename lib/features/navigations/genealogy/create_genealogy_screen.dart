import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/genealogy_api/genealogy_api_service.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';



class CreateGenealogyScreen extends StatefulWidget {
  const CreateGenealogyScreen({super.key,this.member_id,this.sponsor_id,this.postion,this.onSave});
  final String? member_id;
  final String? sponsor_id;
  final String? postion;
  final Function(Map<String,dynamic> data)? onSave;
  @override
  State<CreateGenealogyScreen> createState() => _CreateGenealogyScreenState();

  static Future<Map<String, dynamic>?> show(BuildContext context,{String? member_id,String? sponsor_id,String? position,Function(Map<String,dynamic> data)? onSave}) async {
    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CreateGenealogyScreen(
         member_id: member_id,
        postion: position,
        sponsor_id: sponsor_id,
        onSave: onSave,
      ),
    );
  }
}

class _CreateGenealogyScreenState extends State<CreateGenealogyScreen> {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController sponsorIdController = TextEditingController();
  String? selectedPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    memberIdController.dispose();
    sponsorIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init()async{
    memberIdController.text = widget.member_id??'';
    sponsorIdController.text = widget.sponsor_id??'';
    selectedPosition = widget.postion;
  }
  void _saveMember() async{

    if(!(_formKey.currentState?.validate()??false)){
      return;
    }

    setState(() {
      _isLoading=true;
    });

    final Map<String, dynamic> memberData = {
      "member_id": memberIdController.text.trim(),
      "sponsor_id": sponsorIdController.text.trim(),
      "position": selectedPosition,
    };
    var status = false;
    if(widget.member_id == null && widget.sponsor_id == null && widget.postion == null){
      status = await GenealogyAPIService(context: context).createGenealogy(
          member_id: memberData['member_id'],
          sponsor_id: memberData['sponsor_id'],
          position: memberData['position'],
      );
    }else{
      status = await GenealogyAPIService(context: context).updateGenealogy(
        member_id: memberData['member_id'],
        sponsor_id: memberData['sponsor_id'],
        position: memberData['position'],
      );
    }

    if(status){
      widget.onSave?.call(memberData);
      CustomMessageDialog.show(context, title: 'Genealogy', message: 'Genealogy Updated successfully',onConfirm: (){
        if(status)
          Navigator.pop(context, memberData);
      });
    }

    if(mounted){
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Add Member Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sponsor ID
              CustomTextField(
                controller: sponsorIdController,
                isRequired: true,
                label: 'Sponsor ID',
                prefixIcon: Icon(Iconsax.card),
                textInputFormatter: [
                  UpperCaseTextFormatter()
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              // Member ID
              if(widget.member_id == null)...[
                CustomTextField(
                  label: 'Member ID',
                  controller: memberIdController,
                  prefixIcon: const Icon(Iconsax.card),
                  isRequired: true,
                  textInputFormatter: [
                    UpperCaseTextFormatter()
                  ],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
              ],

              // Position Dropdown
              CustomDropdown(
                  label: 'Position',
                  items: const [
                    DropdownMenuItem(value: 'Left', child: Text('Left')),
                    DropdownMenuItem(value: 'Right', child: Text('Right')),
                  ],
                  value: selectedPosition,
                  isRequired: true,
                  onChanged: (value) {
                    setState(() {
                      selectedPosition = value;
                    });
                  }
              ),
              const SizedBox(height: 24),

              // Save Button
              _isLoading ? CustomCircularIndicator() : CustomButton(
                text: 'Save',
                onPressed: _saveMember,
                iconData: Iconsax.save_2,
              ),
            ],
          ),
        ),
      ),
    );
  }

}


