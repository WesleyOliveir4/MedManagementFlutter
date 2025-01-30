import 'package:flutter/material.dart';
import 'package:med_management/features/data/models/medicine.dart';

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  MedicineTile({
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(medicine.name),
      subtitle: Text('Dias restantes: ${medicine.remainingDays}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
