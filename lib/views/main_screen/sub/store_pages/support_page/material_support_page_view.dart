import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class MaterialSupportPageView extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final VoidCallback onSendPressed;
  final AppAuthUser currentUser;
  final bool showDownArrow;
  final VoidCallback onDonwArrowPressed;
  const MaterialSupportPageView({
    super.key,
    required this.messages,
    required this.textEditingController,
    required this.onSendPressed,
    required this.currentUser,
    required this.scrollController,
    required this.showDownArrow,
    required this.onDonwArrowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              addAutomaticKeepAlives: true,
              reverse: true,
              itemCount: messages.length,
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 148,
                bottom: MediaQuery.paddingOf(context).bottom + 64,
              ),
              itemBuilder: (context, index) {
                return ChatBubbleDriver(
                  message: messages[messages.length - 1 - index],
                  author: currentUser,
                );
              },
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 46 + 8,
              right: 32,
              left: 32,
              child: Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(cornerRadius),
                ),
                clipBehavior: .antiAlias,
                child: BackdropFilter(
                  filter: .blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: context.appColorScheme.surfaceContainer.withValues(
                      alpha: .8,
                    ),
                    // height: 64,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.support_agent_rounded),
                            Text(
                              textAlign: .center,
                              'Contact our support team\n for assistance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (showDownArrow)
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 84,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.appColorScheme.surface,
                    borderRadius: .circular(cornerRadius),
                  ),
                  child: Badge(
                    isLabelVisible: true,
                    smallSize: 10,
                    child: IconButton(
                      onPressed: onDonwArrowPressed,
                      icon: Icon(Icons.arrow_downward_rounded),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 8,
              right: 8,
              left: 8,
              child: Row(
                crossAxisAlignment: .end,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(cornerRadius),
                      ),
                      clipBehavior: .antiAlias,
                      child: BackdropFilter(
                        filter: .blur(sigmaX: 5, sigmaY: 5),
                        child: TextField(
                          controller: textEditingController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            fillColor: context.appColorScheme.primaryContainer
                                .withValues(alpha: 0.6),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hint: Text('Type your question...'),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ClipRRect(
                      borderRadius: .circular(30),
                      child: BackdropFilter(
                        filter: .blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.appColorScheme.primaryContainer
                                .withValues(alpha: 0.6),
                            borderRadius: .circular(cornerRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: IconButton(
                              onPressed: onSendPressed,
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                      ),
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
