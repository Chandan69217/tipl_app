import 'package:flutter/material.dart';

class AddFundScreen extends StatefulWidget {
  @override
  _AddFundScreenState createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedSource = "Admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Fund"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Wallet banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Funds",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Enter the details to add money to user wallet",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Member ID
              Text("Member ID", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              TextFormField(
                controller: memberIdController,
                decoration: InputDecoration(
                  hintText: "Enter Member ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value.toString().isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16),

              // Amount (highlighted)
              Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  prefixIcon: Icon(Icons.currency_rupee),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value.toString().isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16),

              // Source dropdown
              Text("Source", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  value: selectedSource,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: ["Admin", "Bank Transfer", "UPI", "Manual Recharge"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedSource = val;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),

              // Reference
              Text("Reference ID", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              TextFormField(
                controller: referenceController,
                decoration: InputDecoration(
                  hintText: "Example: ManualRecharge001",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value.toString().isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16),

              // Transaction password
              Text("Transaction Password",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Transaction Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value.toString().isEmpty ? "Required" : null,
              ),
              SizedBox(height: 30),

              // Add Fund Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final body = {
                        "member_id": memberIdController.text,
                        "amount": int.parse(amountController.text),
                        "source": selectedSource,
                        "reference": referenceController.text,
                        "transaction_password": passwordController.text
                      };

                      print(body);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fund Added Successfully")),
                      );
                    }
                  },
                  child: Text(
                    "ADD FUND",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
