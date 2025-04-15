import 'package:flutter/material.dart';
import '../../models/grid_status.dart';

class GridAdminScreen extends StatelessWidget {
  const GridAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Administration')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGridStatusCard(),
          const SizedBox(height: 16),
          _buildUsersList(),
          const SizedBox(height: 16),
          _buildMaintenanceSection(),
        ],
      ),
    );
  }

  Widget _buildGridStatusCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Grid Status: Optimal'),
            Text('Total Load: 750 kW / 1000 kW'),
            LinearProgressIndicator(value: 0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Connected Users'),
      ),
    );
  }

  Widget _buildMaintenanceSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Maintenance Schedule'),
      ),
    );
  }
}
