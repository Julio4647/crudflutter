import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/transport_cubit.dart';
import '../cubit/transport_state.dart';
import '../../data/models/transport_model.dart';

class UpdateTransportForm extends StatefulWidget {
  final TransportModel transport;

  const UpdateTransportForm({super.key, required this.transport});

  @override
  _UpdateTransportFormState createState() => _UpdateTransportFormState();
}

class _UpdateTransportFormState extends State<UpdateTransportForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _tipoController;
  late final TextEditingController _capacidadController;
  late final TextEditingController _longitudController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.transport.nombre);
    _tipoController = TextEditingController(text: widget.transport.tipo);
    _capacidadController = TextEditingController(text: widget.transport.capacidad.toString());
    _longitudController = TextEditingController(text: widget.transport.longitud.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _capacidadController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedTransport = TransportModel(
        id: widget.transport.id,
        nombre: _nombreController.text,
        tipo: _tipoController.text,
        capacidad: int.parse(_capacidadController.text),
        longitud: double.parse(_longitudController.text),
      );

      context.read<TransportCubit>().updateTransport(updatedTransport);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Transport'),
      ),
      body: BlocListener<TransportCubit, TransportState>(
        listener: (context, state) {
          if (state is TransportLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is TransportSuccess) {
            Navigator.pop(context); // Cierra el formulario
            Navigator.pop(context); // Vuelve a la pantalla de la lista
          } else if (state is TransportError) {
            Navigator.pop(context); // Cierra el spinner
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tipoController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el tipo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _capacidadController,
                  decoration: const InputDecoration(labelText: 'Capacidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la capacidad';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _longitudController,
                  decoration: const InputDecoration(labelText: 'Longitud'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la longitud';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Update Transport'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
