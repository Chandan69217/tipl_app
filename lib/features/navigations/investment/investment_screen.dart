import 'package:flutter/material.dart';

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> investments = [
      {"title": "Mutual Funds", "amount": 20000, "date": "2025-10-20"},
      {"title": "Stocks", "amount": 10000, "date": "2025-09-30"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Investments"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add_chart),
        label: const Text("Add Investment"),
        onPressed: () {
          // Navigate to add-investment form (future)
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: investments.length,
          itemBuilder: (context, index) {
            final investment = investments[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.blue),
                title: Text(
                  investment["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Date: ${investment["date"]}"),
                trailing: Text(
                  "₹${investment["amount"]}",
                  style: const TextStyle(
                    color: Colors.blue,
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
