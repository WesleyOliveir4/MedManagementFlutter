import 'package:flutter/material.dart';
import 'package:med_management/core/services/shared_prefs_service.dart';
import 'package:med_management/features/data/models/medicine.dart';
import 'package:med_management/features/presentation/pages/add_medicine_page.dart';
import 'package:med_management/features/presentation/widgets/medicine_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SharedPrefsService _prefsService = SharedPrefsService();
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() async {
    medicines = await _prefsService.loadMedicines();
    setState(() {});
  }

  void _addOrEditMedicine({Medicine? medicine, int? index}) async {
    final updatedMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicinePage(medicine: medicine),
      ),
    );

    if (updatedMedicine != null) {
      setState(() {
        if (index == null) {
          medicines.add(updatedMedicine);
        } else {
          medicines[index] = updatedMedicine;
        }
        _prefsService.saveMedicines(medicines);
      });
    }
  }

  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
      _prefsService.saveMedicines(medicines);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Remédios')),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return MedicineTile(
            medicine: medicines[index],
            onEdit: () => _addOrEditMedicine(medicine: medicines[index], index: index),
            onDelete: () => _removeMedicine(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditMedicine(),
      ),
    );
  }
}
