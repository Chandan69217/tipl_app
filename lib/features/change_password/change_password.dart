import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/change_pass_api.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

// void showChangePasswordBottomSheet(BuildContext context,{bool? updateForTnx = false}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     useSafeArea: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) => const ChangePasswordScreen(),
//   );
// }
//
// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//
//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _validateAndConfirm() {
//     if (_formKey.currentState!.validate()) {
//       CustomMessageDialog.show(
//           context,
//           title: 'Confirm Change',
//           message: 'Are you sure you want to change your password?',
//         confirmText: 'Yes',
//         onCancel: (){
//
//         },
//           cancelText: 'No',
//         onConfirm: ()async{
//           final value = await ChangePasswordAPIService(context: context).changeTransactionPass(newPassword: _newPasswordController.text);
//           if(value)
//             SnackBarHelper.show(
//               context,
//               message: 'Your password has been updated successfully!',
//               backgroundColor: Colors.green,
//             );
//
//           else
//             SnackBarHelper.show(
//               context,
//               message: 'We couldn’t update your password. Please try again later.',
//               backgroundColor: Colors.red,
//             );
//           Navigator.pop(context);
//         }
//       );
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 16,
//         right: 16,
//         top: 16,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 5,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const Center(
//                 child: Text(
//                   'Change Password',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               CustomTextField(
//                   label: 'New Password',
//                   controller: _newPasswordController,
//                 obscureText: _obscureNew,
//                   prefixIcon: const Icon(Iconsax.lock),
//                 validate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Enter a new password';
//                   } else if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               CustomTextField(
//                 label: 'Confirm Password',
//                 controller: _confirmPasswordController,
//                 obscureText: _obscureConfirm,
//                 prefixIcon: const Icon(Iconsax.lock),
//                 validate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm your password';
//                   } else if (value != _newPasswordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 25),
//
//
//               CustomButton(
//                 onPressed: _validateAndConfirm,
//                 text:'Change Password',
//                 iconData: Iconsax.key,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


void showChangePasswordBottomSheet(
    BuildContext context, {
      bool? updateForTnx = false,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChangePasswordScreen(updateForTnx: updateForTnx ?? false),
  );
}

class ChangePasswordScreen extends StatefulWidget {
  final bool updateForTnx;

  const ChangePasswordScreen({
    Key? key,
    required this.updateForTnx,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  void _validateAndConfirm() {
    if (_formKey.currentState!.validate()) {
      CustomMessageDialog.show(
        context,
        title: widget.updateForTnx
            ? 'Confirm Transaction Password Update'
            : 'Confirm Change',
        message: widget.updateForTnx
            ? 'Are you sure you want to update your transaction password?'
            : 'Are you sure you want to change your password?',
        confirmText: 'Yes',
        cancelText: 'No',
        onConfirm: _processPasswordUpdate,
        onCancel: () {},
      );
    }
  }


  Future<void> _processPasswordUpdate() async {
    bool result = false;
    setState(() {
      isLoading = true;
    });
    if (widget.updateForTnx) {
      //  UPDATE TRANSACTION PASSWORD
      result = await ChangePasswordAPIService(context: context)
          .changeWalletTransactionPass(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    } else {
      //  NORMAL PASSWORD UPDATE
      result = await ChangePasswordAPIService(context: context)
          .changeTransactionPass(newPassword: _newPasswordController.text);
    }

    if (result) {
      SnackBarHelper.show(
        context,
        message: widget.updateForTnx
            ? 'Transaction password updated successfully!'
            : 'Password changed successfully!',
        backgroundColor: Colors.green,
      );
    } else {
      SnackBarHelper.show(
        context,
        message: widget.updateForTnx
            ? 'Failed to update transaction password. Try again.'
            : 'Failed to update password. Try again.',
        backgroundColor: Colors.red,
      );

    }

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              Center(
                child: Text(
                  widget.updateForTnx
                      ? 'Update Transaction Password'
                      : 'Change Password',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),


              if (widget.updateForTnx)
                Column(
                  children: [
                    CustomTextField(
                      label: 'Old Password',
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      prefixIcon: const Icon(Iconsax.lock),
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your old password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),


              CustomTextField(
                label: widget.updateForTnx
                    ? "New Transaction Password"
                    : "New Password",
                controller: _newPasswordController,
                obscureText: _obscureNew,
                prefixIcon: const Icon(Iconsax.lock),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a new password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              CustomTextField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                prefixIcon: const Icon(Iconsax.lock),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              isLoading ? CustomCircularIndicator() : CustomButton(
                onPressed: _validateAndConfirm,
                text: widget.updateForTnx
                    ? 'Update Transaction Password'
                    : 'Change Password',
                iconData: Iconsax.key,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
