import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:med_management/features/data/models/medicine.dart';

class MedicineRepository {
  static const String _storageKey = 'medicines';

  Future<List<Medicine>> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey) ?? '[]';
    return (json.decode(data) as List)
        .map((e) => Medicine.fromJson(e))
        .toList();
  }

  Future<void> saveMedicines(List<Medicine> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_storageKey, json.encode(medicines));
  }
}
