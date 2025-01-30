import 'package:shared_preferences/shared_preferences.dart';
import 'package:med_management/features/data/models/medicine.dart';

class SharedPrefsService {
  static const String _keyMedicines = 'medicines';

  Future<List<Medicine>> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyMedicines);
    return data != null ? Medicine.fromJsonList(data) : [];
  }

  Future<void> saveMedicines(List<Medicine> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMedicines, Medicine.toJsonList(medicines));
  }
}