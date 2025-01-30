import 'package:flutter/material.dart';
import 'package:med_management/core/utils/date_formatter.dart';
import 'package:med_management/features/data/models/medicine.dart';

class AddMedicinePage extends StatefulWidget {
  final Medicine? medicine;

  const AddMedicinePage({this.medicine, Key? key}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (_startDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Data escolhida: ${DateFormatter.format(_startDate!)}',
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