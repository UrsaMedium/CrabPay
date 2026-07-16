import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialSupportPageView extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController textEditingController;
  final VoidCallback onSendPressed;
  const MaterialSupportPageView({
    super.key,
    required this.messages,
    required this.textEditingController,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Text(messages[index].content);
              },
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 8,
              right: 8,
              left: 8,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: .multiline,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.appColorScheme.primaryFixed,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.appColorScheme.primaryFixed,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        hint: Text('Type your question...'),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: IconButton(onPressed: onSendPressed, icon: Icon(Icons.send)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
