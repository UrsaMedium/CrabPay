import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/support_page/driver/support_page_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/support_page/material_support_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SupportPageDriver extends StatefulWidget {
  static final routeName = AppRoutes.support.name;
  const SupportPageDriver({super.key});

  @override
  State<SupportPageDriver> createState() => _SupportPageDriverState();
}

class _SupportPageDriverState extends State<SupportPageDriver>
    with AutomaticKeepAliveClientMixin {
  late final SupportPageCubit _supportPageCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _supportPageCubit = SupportPageCubit(
      user: context.read<AuthBloc>().state.currentUser,
      chatBloc: context.read<ChatBloc>(),
      scrollController: ScrollController(),
      textEdditingController: TextEditingController(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _supportPageCubit.close();
    super.dispose();
  }

  void _onSendPressed(BuildContext context) {
    if (context.read<ChatBloc>().state.activeThread != null) {
      context.read<ChatBloc>().add(
        ChatEventSendMessage(
          threadId: context.read<ChatBloc>().state.activeThread!.id,
          content: _supportPageCubit.state.messageInputController.text.trim(),
          senderId: _supportPageCubit.state.currentUser.id,
        ),
      );
      _supportPageCubit.state.messageInputController.clear();
    } else {
      Fluttertoast.showToast(msg: 'Oops, no chat thread');
    }
  }

  void _onDownArrowPressed(BuildContext context) {
    _supportPageCubit.onDonwArrowPressed();
  }

  void _onStartChatPressed(BuildContext context) {
    context.read<ChatBloc>().add(
      ChatEventInitializeThread(userId: _supportPageCubit.state.currentUser.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _supportPageCubit,
      child: Builder(
        builder: (context) {
          return MaterialSupportPageView(
            onDonwArrowPressed: () => _onDownArrowPressed(context),
            onSendPressed: () => _onSendPressed(context),
            onStartChatPressed: () => _onStartChatPressed(context),
          );
        },
      ),
    );
  }
}
