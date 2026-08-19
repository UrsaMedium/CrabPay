import 'dart:async';

import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SupportPageState extends Equatable {
  final bool showDownScrollArrow;
  final ScrollController scrollController;
  final TextEditingController messageInputController;
  final bool isSubscribed;
  final AppAuthUser currentUser;
  final List<ChatMessage>? messages;

  const SupportPageState({
    this.showDownScrollArrow = false,
    required this.scrollController,
    required this.messageInputController,
    this.isSubscribed = false,
    required this.currentUser,
    this.messages,
  });

  SupportPageState copyWith({
    bool? showDownScrollArrow,
    ScrollController? scrollController,
    TextEditingController? messageInputController,
    bool? isSubscribed,
    AppAuthUser? currentUser,
    List<ChatMessage>? messages,
  }) {
    return SupportPageState(
      showDownScrollArrow: showDownScrollArrow ?? this.showDownScrollArrow,
      scrollController: scrollController ?? this.scrollController,
      messageInputController:
          messageInputController ?? this.messageInputController,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      currentUser: currentUser ?? this.currentUser,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
    showDownScrollArrow,
    scrollController,
    messageInputController,
    isSubscribed,
    currentUser,
    messages,
  ];
}

class SupportPageCubit extends Cubit<SupportPageState> {
  final ChatBloc _chatBloc;
  late final StreamSubscription _chatSubscription;
  SupportPageCubit({
    required ChatBloc chatBloc,
    required ScrollController scrollController,
    required TextEditingController textEdditingController,
    required AppAuthUser user,
  }) : _chatBloc = chatBloc,
       super(
         SupportPageState(
           scrollController: scrollController,
           messageInputController: textEdditingController,
           currentUser: user,
         ),
       ) {
    final msgs = chatBloc.state.messages;
    emit(state.copyWith(messages: msgs));
    _chatSubscription = _chatBloc.stream.listen((chatState) {
      if (chatState.status == ChatStates.messagesUpdated) {
        _onNewMessage(chatState.messages ?? []);
      }
      _whatchSubStatus(chatState);
    });
  }

  void _whatchSubStatus(ChatState chatState) {
    if (state.isSubscribed != chatState.isSubscribed) {
      emit(state.copyWith(isSubscribed: chatState.isSubscribed));
    }
  }

  void _onNewMessage(List<ChatMessage> messages) {
    emit(state.copyWith(messages: messages));
    if (state.scrollController.hasClients) {
      final currentOffset = state.scrollController.offset;
      if (currentOffset <= 300) {
        state.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _setArrowState(true);
      }
    }
  }

  void onDonwArrowPressed() {
    state.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _setArrowState(false);
  }

  void _setArrowState(bool doShow) {
    emit(state.copyWith(showDownScrollArrow: doShow));
  }

  @override
  Future<void> close() {
    _chatSubscription.cancel();
    return super.close();
  }
}
