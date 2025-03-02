import 'package:account/model/performanceItem.dart';
import 'package:account/provider/performance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  PerformanceItem item;

  EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final ticketPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.item.title;
    locationController.text = widget.item.location;
    descriptionController.text = widget.item.description;
    ticketPriceController.text = widget.item.ticketPrice.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Performance'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(label: const Text('ชื่อการแสดง')),
              autofocus: true,
              controller: titleController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "กรุณาป้อนชื่อการแสดง";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: const Text('สถานที่จัดการแสดง')),
              controller: locationController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "กรุณาป้อนสถานที่จัดการแสดง";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: const Text('รายละเอียดการแสดง')),
              controller: descriptionController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "กรุณาป้อนรายละเอียดการแสดง";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: const Text('ราคาตั๋ว')),
              keyboardType: TextInputType.number,
              controller: ticketPriceController,
              validator: (String? value) {
                try {
                  double ticketPrice = double.parse(value!);
                  if (ticketPrice <= 0) {
                    return "กรุณาป้อนราคาตั๋วที่มากกว่า 0";
                  }
                } catch (e) {
                  return "กรุณาป้อนราคาตั๋วเป็นตัวเลขเท่านั้น";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // ทำการอัปเดตข้อมูล
                  var provider = Provider.of<PerformanceProvider>(context, listen: false);

                  PerformanceItem item = PerformanceItem(
                    keyID: widget.item.keyID,
                    title: titleController.text,
                    location: locationController.text,
                    description: descriptionController.text,
                    ticketPrice: double.parse(ticketPriceController.text),
                    date: widget.item.date,
                  );

                  provider.updatePerformance(item);

                  // ปิดหน้าจอ
                  Navigator.pop(context);
                }
              },
              child: const Text('แก้ไขข้อมูลการแสดง'),
            ),
          ],
        ),
      ),
    );
  }
}