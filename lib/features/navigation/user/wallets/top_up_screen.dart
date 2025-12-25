import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      // enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TopUpScreen(),
    );
  }

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    // amountController.dispose();
    // passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPasswordPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBackToAmountPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage == 0 ? 'Top-Up Wallet' : 'Confirm Transaction',
        ),
        leading: IconButton(
          onPressed: () {
            if (_currentPage == 1) {
              _goBackToAmountPage();
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: PopScope(
        canPop: _currentPage == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _currentPage == 1) {
            _goBackToAmountPage();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [_buildAmountPage(), _buildPasswordPage()],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------ AMOUNT PAGE ------------------------
  Widget _buildAmountPage() {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Form(
      key: _formkey,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 10),

          Center(child: Image.asset('assets/icons/top_up_wallet.webp')),
          // SizedBox(height: 10),
          CustomTextField(
            controller: amountController,
            prefixIcon: Icon(Iconsax.wallet),
            label: 'Amount',
            isRequired: true,
            validate: (value) {
              if (value != null && (int.tryParse(value) ?? 0) <= 0) {
                return "Please value amount";
              }
              return null;
            },
            textInputType: TextInputType.number,
          ),
          SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () {
                if (!(_formkey.currentState?.validate() ?? false)) {
                  return;
                }
                _goToPasswordPage();
              },
              text: 'Continue',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPage() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isLoading = false;
    return Form(
      key: _formKey,
      child: StatefulBuilder(
        builder: (_,refresh){
          return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/icons/transaction_password.webp',
                height: 250,
              ),
            ),

            CustomTextField(
              controller: passwordController,
              obscureText: true,
              label: 'Transaction Password',
              isRequired: true,
              textInputType: TextInputType.visiblePassword,
              prefixIcon: Icon(Iconsax.password_check),
            ),
            SizedBox(height: 25),
            isLoading ? CustomCircularIndicator(): CustomButton(
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                refresh((){
                  isLoading = true;
                });

                final values = await WalletApiService(context: context)
                    .topUp(
                  amount: double.parse(amountController.text),
                  password: passwordController.text,
                );

                if(values != null){
                  RecallProvider(context: context).recallAll();
                  final message = values['message'];
                  CustomMessageDialog.show(context, title: 'Wallet TopUp', message: message,onConfirm: (){
                    Navigator.pop(context,);
                  });
                }refresh((){
                  isLoading = false;
                });

              },
              text: 'Submit',
            ),
          ],
          );
        },
      ),
    );
  }
}
