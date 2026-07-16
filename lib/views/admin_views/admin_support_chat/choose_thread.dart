import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseThreadView extends StatelessWidget {
  const ChooseThreadView({super.key});

  @override
  Widget build(BuildContext context) {
    final allThreads = context.select<ChatBloc, List<SupportThread>?>(
      (bloc) => bloc.state.allThreads,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: .stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ChatBloc>().add(ChatEventFetchAllThreads());
              },
              child: Text('Fetch all threads'),
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
                          'admin_support_chat_view',
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


// return ElevatedButton(
//                     onPressed: () {
//                       context.pushNamed(
//                         '/admin_tools_view/choose_thread_view/admin_support_chat_view',
//                         pathParameters: {'productId': allThreads[index].id},
//                       );
//                     },
//                     child: Text('Add complete product'),
//                   );