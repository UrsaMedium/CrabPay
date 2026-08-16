import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalGraphicState extends Equatable {
  final bool highGraphics;

  const GlobalGraphicState({required this.highGraphics});

  @override
  List<Object?> get props => [highGraphics];
}

abstract class GlobalGraphicEvent {
  const GlobalGraphicEvent();
}

class GlobalGraphicEventSetHigh extends GlobalGraphicEvent {}

class GlobalGraphicEventSetLow extends GlobalGraphicEvent {}

class GlobalGraphicBloc extends Bloc<GlobalGraphicEvent, GlobalGraphicState> {
  GlobalGraphicBloc() : super(const GlobalGraphicState(highGraphics: false)) {
    //
    on<GlobalGraphicEventSetLow>(
      (event, emit) => emit(const GlobalGraphicState(highGraphics: false)),
    );

    on<GlobalGraphicEventSetHigh>(
      (event, emit) => emit(const GlobalGraphicState(highGraphics: true)),
    );
  }
}
