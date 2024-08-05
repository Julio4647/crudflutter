import 'package:crud_flutter/data/models/transport_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/transport_repository.dart';
import '../cubit/transport_cubit.dart';
import '../cubit/transport_state.dart';
import 'update_transport_form.dart';
import 'add_transport_form.dart';

class TransportListView extends StatelessWidget {
  const TransportListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransportCubit(
        transportRepository: RepositoryProvider.of<TransportRepository>(context),
      )..fetchAllTransport(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transport List')
        ),
        body: const TransportListScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTransportForm()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TransportListScreen extends StatelessWidget {
  const TransportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<TransportCubit>().fetchAllTransport();
          },
          child: const Text('Fetch Transports'),
        ),
        Expanded(
          child: BlocBuilder<TransportCubit, TransportState>(
            builder: (context, state) {
              if (state is TransportLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TransportSuccess) {
                final transports = state.transports;
                return ListView.builder(
                  itemCount: transports.length,
                  itemBuilder: (context, index) {
                    final transport = transports[index];
                    return ListTile(
                      title: Text(transport.nombre),
                      subtitle: Text('Tipo: ${transport.tipo}, Capacidad: ${transport.capacidad}, Longitud: ${transport.longitud}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTransportForm(transport: transport),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _deleteTransport(context, transport.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${transport.nombre} eliminado correctamente')),
                              );
                              // Refrescar la lista después de eliminar
                              context.read<TransportCubit>().fetchAllTransport();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is TransportError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Press the button to fetch transport'));
            },
          ),
        ),
      ],
    );
  }

  Future<void> _deleteTransport(BuildContext context, int id) async {
    try {
      await context.read<TransportCubit>().deleteTransport(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando el transporte: $e')),
      );
    }
  }
}
