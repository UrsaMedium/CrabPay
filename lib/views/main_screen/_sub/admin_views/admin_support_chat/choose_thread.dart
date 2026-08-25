import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/admin_chat_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/adminchat_event.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseThreadView extends StatelessWidget {
  static final routeName = 'choose_thread_view';
  const ChooseThreadView({super.key});

  @override
  Widget build(BuildContext context) {
    final allThreads = context.select<ChatBlocAdmin, List<SupportThread>?>(
      (bloc) => bloc.state.allThreads,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<ChatBlocAdmin>().add(
              ChatEventInitializeThreadAdmin(
                userId: context.read<AuthBloc>().state.currentUser.id,
              ),
            );
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ChatBlocAdmin>().add(
                  ChatEventFetchAllThreadsAdmin(),
                );
              },
              child: Text(context.l10n.fetchAllThreads),
            ),
            if (allThreads != null)
              Expanded(
                child: ListView.builder(
                  itemCount: allThreads.length,
                  // itemExtent: 16,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        context.pushNamed(
                          AppRoutes.adminSupportChat.name,
                          pathParameters: {'threadId': allThreads[index].id},
                        );
                      },
                      child: Text('Chat with user ${allThreads[index].userId}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
