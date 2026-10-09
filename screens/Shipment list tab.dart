import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Shipment.dart';


/// แท็บ 2: Display รายการตู้ขนส่งระหว่างทาง
class ShipmentListTab extends StatelessWidget {
  final List<Shipment> shipments;
  final void Function(int) onDelete;
  final void Function(int, int, String) onUpdate;

  const ShipmentListTab({
    super.key,
    required this.shipments,
    required this.onDelete,
    required this.onUpdate,
  });

  Future<void> _confirmDelete(BuildContext context, int index) async {
    final s = shipments[index];
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text(
            'บันทึกตู้ ${s.containerId} ว่าตรวจรับเข้าคลังแล้ว / ตัดจำหน่ายของเสีย และลบออกจากรายการ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
    if (ok == true) {
      onDelete(index);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบตู้ ${s.containerId} แล้ว')),
        );
      }
    }
  }

  Future<void> _showEditDialog(BuildContext context, int index) async {
    final s = shipments[index];
    final hoursCtrl = TextEditingController(text: s.hoursLeft.toString());
    final routeCtrl = TextEditingController(text: s.route);
    final editKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('แก้ไขตู้ ${s.containerId}'),
        content: Form(
          key: editKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: hoursCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'ชั่วโมงเดินทางคงเหลือ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || int.tryParse(v.trim()) == null)
                    ? 'กรุณากรอกเป็นตัวเลข'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: routeCtrl,
                decoration: const InputDecoration(
                  labelText: 'เส้นทางใหม่ (ถ้ามี)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              if (editKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );

    if (ok == true) {
      onUpdate(index, int.parse(hoursCtrl.text.trim()), routeCtrl.text.trim());
    }
    // หมายเหตุ: ไม่ dispose controller ตรงนี้ เพราะ dialog ยังเล่นแอนิเมชันปิดอยู่
    // การ dispose ทันทีจะทำให้แอปค้าง/แดง (used after being disposed)
  }

  @override
  Widget build(BuildContext context) {
    if (shipments.isEmpty) {
      return const Center(
        child: Text('ยังไม่มีตู้สินค้าระหว่างทาง',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final s = shipments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: s.maxTemp <= 0
                  ? Colors.lightBlue.shade700
                  : Colors.orange.shade700,
              foregroundColor: Colors.white,
              child: Text(
                '${s.maxTemp}°C',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(s.containerId),
            subtitle: Text(
              '${s.productType}\n'
              'เหลือ ${s.hoursLeft} ชม.'
              '${s.route.isNotEmpty ? '  |  เส้นทาง: ${s.route}' : ''}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDialog(context, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}