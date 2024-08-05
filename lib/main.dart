import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/transport_repository.dart';
import 'presentation/cubit/transport_cubit.dart';
import 'presentation/screens/get_all_transport.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TransportRepository(
            baseUrl: 'https://vb2lfs3fl5.execute-api.us-east-1.amazonaws.com/Prod',
          ),
        ),
        BlocProvider(
          create: (context) => TransportCubit(
            transportRepository: context.read<TransportRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Transport App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TransportListView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
