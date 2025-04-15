import 'package:flutter/material.dart';
import '../../models/energy_trade.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Energy Trading')),
      body: Column(
        children: [
          _buildTradeForm(),
          const Divider(),
          _buildActiveTradesList(),
        ],
      ),
    );
  }

  Widget _buildTradeForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Amount (kW)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Create Trade Request'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTradesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 5, // Dummy count
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text('Trade Request #123'),
            subtitle: Text('Amount: 25 kW'),
            trailing: Text('Pending'),
          );
        },
      ),
    );
  }
}
