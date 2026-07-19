import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialSupportPageView extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController textEditingController;
  final VoidCallback onSendPressed;
  final AppAuthUser currentUser;
  const MaterialSupportPageView({
    super.key,
    required this.messages,
    required this.textEditingController,
    required this.onSendPressed,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            ListView.builder(
              reverse: true,
              itemCount: messages.length,
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 48 + 68,
                bottom: MediaQuery.paddingOf(context).bottom + 64,
              ),
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[messages.length - 1 - index],
                  author: currentUser,
                );
              },
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 48,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: .circular(30),
                child: BackdropFilter(
                  filter: .blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainer.withValues(
                        alpha: .8,
                      ),
                      borderRadius: .circular(30),
                    ),
                    height: 64,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 64.0,
                              vertical: 8,
                            ),
                            child: Text(
                              textAlign: .center,
                              'Contact our support team for assistance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 8,
              right: 8,
              left: 8,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: .circular(30),
                      child: BackdropFilter(
                        filter: .blur(sigmaX: 5, sigmaY: 5),
                        child: TextField(
                          controller: textEditingController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            fillColor: context.appColorScheme.primaryContainer
                                .withValues(alpha: 0.6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColorScheme.outlineVariant,
                              ),
                              borderRadius: .circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColorScheme.outline,
                              ),
                              borderRadius: .circular(30),
                            ),
                            hint: Text('Type your question...'),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: IconButton(
                      onPressed: onSendPressed,
                      icon: Icon(Icons.send),
                    ),
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

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final AppAuthUser author;
  const ChatBubble({super.key, required this.message, required this.author});

  bool isMe() {
    return message.senderId == author.id;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 4.0,
        right: isMe() ? 8 : 64,
        left: isMe() ? 64 : 8,
      ),
      child: Align(
        alignment: isMe()
            ? AlignmentGeometry.centerRight
            : AlignmentGeometry.centerLeft,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          color: isMe()
              ? context.appColorScheme.primary
              : context.appColorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text(
              message.content,
              style: TextStyle(
                color: isMe()
                    ? context.appColorScheme.onPrimary
                    : context.appColorScheme.onSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
