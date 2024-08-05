import 'package:equatable/equatable.dart';
import '../../data/models/transport_model.dart';

abstract class TransportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransportInitial extends TransportState {}

class TransportLoading extends TransportState {}

class TransportSuccess extends TransportState {
  final List<TransportModel> transports;

  TransportSuccess({required this.transports});

  @override
  List<Object?> get props => [transports];
}

class TransportError extends TransportState {
  final String message;

  TransportError({required this.message});

  @override
  List<Object?> get props => [message];
}
