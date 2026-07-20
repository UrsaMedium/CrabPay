import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class ChatBubbleDriver extends StatefulWidget {
  final ChatMessage message;
  final AppAuthUser author;
  const ChatBubbleDriver({
    super.key,
    required this.message,
    required this.author,
  });

  @override
  State<ChatBubbleDriver> createState() => _ChatBubbleDriverState();
}

class _ChatBubbleDriverState extends State<ChatBubbleDriver> {
  @override
  Widget build(BuildContext context) {
    return MaterialChatBubble(
      content: widget.message.content,
      isMe: widget.message.senderId == widget.author.id,
      createdAt: widget.message.createdAt,
    );
  }
}

class MaterialChatBubble extends StatelessWidget {
  final bool isMe;
  final String content;
  final DateTime createdAt;
  const MaterialChatBubble({
    super.key,
    required this.isMe,
    required this.content,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 4.0,
        right: isMe ? 8 : 64,
        left: isMe ? 64 : 8,
      ),
      child: Align(
        alignment: isMe
            ? AlignmentGeometry.centerRight
            : AlignmentGeometry.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe
                ? context.appColorScheme.primary
                : context.appColorScheme.secondary,
                borderRadius: .circular(24)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Wrap(
              alignment: .end,
              crossAxisAlignment: .end,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  content,
                  textAlign: .left,
                  style: TextStyle(
                    fontSize: 16,
                    color: isMe
                        ? context.appColorScheme.onPrimary
                        : context.appColorScheme.onSecondary,
                  ),
                ),
                Text(
                  '${createdAt.hour}:${createdAt.minute}',
                  style: TextStyle(
                    color: context.appColorScheme.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
