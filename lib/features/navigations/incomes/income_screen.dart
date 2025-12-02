import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> incomes = [
      {"title": "Salary", "amount": 50000, "date": "2025-11-01"},
      {"title": "Freelance Project", "amount": 15000, "date": "2025-10-25"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incomes"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text("Add Income"),
        onPressed: () {
          // Navigate to add-income form (future)
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green),
                title: Text(
                  income["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Date: ${income["date"]}"),
                trailing: Text(
                  "₹${income["amount"]}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
