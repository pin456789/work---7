import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Shipment.dart';

/// แท็บ 1: Form ลงทะเบียนตู้คอนเทนเนอร์/ล็อตยา
class RegisterTab extends StatefulWidget {
  final void Function(Shipment) onSave;
  const RegisterTab({super.key, required this.onSave});

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  @override
  void dispose() {
    _idCtrl.dispose();
    _typeCtrl.dispose();
    _emailCtrl.dispose();
    _tempCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(Shipment(
        containerId: _idCtrl.text.trim(),
        productType: _typeCtrl.text.trim(),
        qaEmail: _emailCtrl.text.trim(),
        maxTemp: double.parse(_tempCtrl.text.trim()),
        hoursLeft: int.parse(_hoursCtrl.text.trim()),
      ));
      _formKey.currentState!.reset();
      _idCtrl.clear();
      _typeCtrl.clear();
      _emailCtrl.clear();
      _tempCtrl.clear();
      _hoursCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลงทะเบียนตู้สินค้าเรียบร้อย')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _idCtrl,
              decoration: const InputDecoration(
                labelText: 'รหัสตู้สินค้า (Container Unit ID)',
                hintText: 'เช่น COLD-TH-9941',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'กรุณากรอกรหัสตู้สินค้า'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeCtrl,
              decoration: const InputDecoration(
                labelText: 'ประเภทสินค้า (Product Type)',
                hintText: 'เช่น mRNA Vaccine, Plasma',
                prefixIcon: Icon(Icons.medical_services),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'กรุณากรอกประเภทสินค้า'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'อีเมลเจ้าหน้าที่ QA',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'กรุณากรอกอีเมล';
                }
                final emailReg =
                    RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$');
                if (!emailReg.hasMatch(v.trim())) {
                  return 'รูปแบบอีเมลไม่ถูกต้อง';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tempCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                // อนุญาตเฉพาะตัวเลข (รองรับติดลบและทศนิยม เช่น -70 หรือ 8.5)
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: 'ขีดจำกัดอุณหภูมิสูงสุด (°C)',
                prefixIcon: Icon(Icons.thermostat),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'กรุณากรอกอุณหภูมิ';
                }
                if (double.tryParse(v.trim()) == null) {
                  return 'กรุณากรอกเป็นตัวเลขเท่านั้น';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hoursCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'ระยะเวลาขนส่งคงเหลือ (ชั่วโมง)',
                prefixIcon: Icon(Icons.timer),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'กรุณากรอกจำนวนชั่วโมง';
                }
                if (int.tryParse(v.trim()) == null) {
                  return 'กรุณากรอกเป็นตัวเลขเท่านั้น';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('บันทึก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}