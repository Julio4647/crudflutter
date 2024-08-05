import 'package:bloc/bloc.dart';
import '../../data/models/transport_model.dart';
import '../../data/repository/transport_repository.dart';
import 'transport_state.dart';

class TransportCubit extends Cubit<TransportState> {
  final TransportRepository transportRepository;

  TransportCubit({required this.transportRepository}) : super(TransportInitial());

  Future<void> createTransport(TransportModel transport) async {
    try {
      emit(TransportLoading());
      await transportRepository.insertTransport(transport);
      final transports = await transportRepository.getAllTransports();
      emit(TransportSuccess(transports: transports));
    } catch (e) {
      emit(TransportError(message: e.toString()));
    }
  }

  Future<void> getTransport(int id) async {
    try {
      emit(TransportLoading());
      final transport = await transportRepository.getTransport(id);
      emit(TransportSuccess(transports: [transport]));
    } catch (e) {
      emit(TransportError(message: e.toString()));
    }
  }

  Future<void> updateTransport(TransportModel transport) async {
    try {
      emit(TransportLoading());
      await transportRepository.updateTransport(transport);
      final transports = await transportRepository.getAllTransports();
      emit(TransportSuccess(transports: transports));
    } catch (e) {
      emit(TransportError(message: e.toString()));
    }
  }

  Future<void> deleteTransport(int id) async {
    try {
      emit(TransportLoading());
      await transportRepository.deleteTransport(id);
      final transports = await transportRepository.getAllTransports();
      emit(TransportSuccess(transports: transports));
    } catch (e) {
      emit(TransportError(message: e.toString()));
    }
  }

  Future<void> fetchAllTransport() async {
    try {
      emit(TransportLoading());
      final transports = await transportRepository.getAllTransports();
      emit(TransportSuccess(transports: transports));
    } catch (e) {
      emit(TransportError(message: e.toString()));
    }
  }
}
