import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class GlobalLanguageState extends Equatable {
  final bool isRu;
  const GlobalLanguageState({this.isRu = false});

  GlobalLanguageState copyWith({bool? isRu}) =>
      GlobalLanguageState(isRu: isRu ?? this.isRu);

  @override
  List<Object?> get props => [isRu];
}

class GlobalLanguageCubit extends Cubit<GlobalLanguageState> {
  GlobalLanguageCubit() : super(GlobalLanguageState());

  void setRuLang({required bool isRu}) {
    emit(state.copyWith(isRu: isRu));
  }
}
