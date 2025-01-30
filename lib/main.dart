import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Medicine {
  String name;
  int pillsInBox;
  int timesPerDay;
  DateTime startDate;

  Medicine({
    required this.name,
    required this.pillsInBox,
    required this.timesPerDay,
    required this.startDate,
  });

  int get remainingDays => (pillsInBox / timesPerDay).floor();

  Map<String, dynamic> toJson() => {
    'name': name,
    'pillsInBox': pillsInBox,
    'timesPerDay': timesPerDay,
    'startDate': startDate.toIso8601String(),
  };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      pillsInBox: json['pillsInBox'],
      timesPerDay: json['timesPerDay'],
      startDate: DateTime.parse(json['startDate']),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('medicines') ?? '[]';
    setState(() {
      medicines = (json.decode(data) as List)
          .map((e) => Medicine.fromJson(e))
          .toList();
    });
  }

  void _saveMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('medicines', json.encode(medicines));
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
        _saveMedicines();
      });
    }
  }

  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
      _saveMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Remédios')),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return ListTile(
            title: Text(medicine.name),
            subtitle: Text('Dias restantes: ${medicine.remainingDays}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _addOrEditMedicine(
                    medicine: medicine,
                    index: index,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeMedicine(index),
                ),
              ],
            ),
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

class AddMedicinePage extends StatefulWidget {
  final Medicine? medicine;

  AddMedicinePage({this.medicine});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _timesController = TextEditingController();
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      _nameController.text = widget.medicine!.name;
      _pillsController.text = widget.medicine!.pillsInBox.toString();
      _timesController.text = widget.medicine!.timesPerDay.toString();
      _startDate = widget.medicine!.startDate;
    }
  }

  void _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _saveMedicine() {
    if (_formKey.currentState!.validate() && _startDate != null) {
      final newMedicine = Medicine(
        name: _nameController.text,
        pillsInBox: int.parse(_pillsController.text),
        timesPerDay: int.parse(_timesController.text),
        startDate: _startDate!,
      );
      Navigator.pop(context, newMedicine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine == null ? 'Adicionar Remédio' : 'Editar Remédio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // ALINHA A DATA À ESQUERDA
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Remédio'),
                validator: (value) => value!.isEmpty ? 'Digite um nome' : null,
              ),
              TextFormField(
                controller: _pillsController,
                decoration: InputDecoration(labelText: 'Quantidade na caixa'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Digite um número' : null,
              ),
              TextFormField(
                controller: _timesController,
                decoration: InputDecoration(labelText: 'Vezes ao dia'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Digite um número' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickStartDate,
                child: Text('Escolher Data de Início'),
              ),
              if (_startDate != null) // MOSTRA A DATA ESCOLHIDA APÓS SELECIONAR
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Data escolhida: ${DateFormat('dd/MM/yyyy').format(_startDate!)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}