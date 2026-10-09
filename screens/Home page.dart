import 'package:flutter/material.dart';
import '../models/Shipment.dart';
import 'Register tab.dart';
import 'Shipment list tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Shipment> _shipments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addShipment(Shipment s) {
    setState(() => _shipments.add(s));
    _tabController.animateTo(1); // ไปแท็บรายการหลังบันทึก
  }

  void _deleteShipment(int index) {
    setState(() => _shipments.removeAt(index));
  }

  void _updateShipment(int index, int hours, String route) {
    setState(() {
      _shipments[index].hoursLeft = hours;
      _shipments[index].route = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColdTrack'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_box), text: 'ลงทะเบียน'),
            Tab(icon: Icon(Icons.local_shipping), text: 'ระหว่างทาง'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RegisterTab(onSave: _addShipment),
          ShipmentListTab(
            shipments: _shipments,
            onDelete: _deleteShipment,
            onUpdate: _updateShipment,
          ),
        ],
      ),
    );
  }
}