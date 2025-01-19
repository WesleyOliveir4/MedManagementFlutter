import 'package:flutter/material.dart';

void main() => runApp(RemedyApp());

class RemedyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Remédios',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RemedyListScreen(),
    );
  }
}

class RemedyListScreen extends StatefulWidget {
  @override
  _RemedyListScreenState createState() => _RemedyListScreenState();
}

class _RemedyListScreenState extends State<RemedyListScreen> {
  List<Map<String, dynamic>> remedies = [];

  void _addRemedy(String name, List<String> times) {
    setState(() {
      remedies.add({'name': name, 'times': times});
    });
  }

  void _showAddRemedyDialog() {
    final _nameController = TextEditingController();
    final List<String> _times = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Adicionar Remédio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Remédio'),
              ),
              SizedBox(height: 10),
              Text(
                'Horários:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._times.map((time) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(time, style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _times.remove(time);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                onPressed: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeOfDay != null) {
                    final formattedTime =
                    timeOfDay.format(context); // Formata o horário (ex.: 08:00)
                    setState(() {
                      _times.add(formattedTime);
                    });
                  }
                },
                icon: Icon(Icons.add),
                label: Text('Adicionar Horário'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _times.isNotEmpty) {
                  _addRemedy(_nameController.text, _times);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Remédios'),
      ),
      body: remedies.isEmpty
          ? Center(
        child: Text(
          'Nenhum remédio adicionado ainda!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: remedies.length,
        itemBuilder: (context, index) {
          final remedy = remedies[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(remedy['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...remedy['times'].map((time) => Text('• $time')).toList(),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    remedies.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRemedyDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
