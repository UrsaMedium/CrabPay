import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/chat_bubble.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/support_page/driver/support_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialSupportPageView extends StatelessWidget {
  final VoidCallback onSendPressed;
  final VoidCallback onDonwArrowPressed;
  final VoidCallback onStartChatPressed;
  const MaterialSupportPageView({
    super.key,
    required this.onSendPressed,
    required this.onDonwArrowPressed,
    required this.onStartChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    final messages = context.select<SupportPageCubit, List<ChatMessage>>(
      (cubit) => cubit.state.messages ?? [],
    );
    final isChatStarted = context.select<SupportPageCubit, bool>(
      (cubit) => cubit.state.isSubscribed,
    );
    final showDownArrow = context.select<SupportPageCubit, bool>(
      (cubit) => cubit.state.showDownScrollArrow,
    );
    final isGettingThread = context.select<SupportPageCubit, bool>(
      (cubit) => cubit.state.isGettingThread,
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            ListView.builder(
              controller: context
                  .read<SupportPageCubit>()
                  .state
                  .scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              // addAutomaticKeepAlives: true,
              reverse: true,
              itemCount: messages.length,
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 102,
                bottom:
                    MediaQuery.paddingOf(context).bottom +
                    64, // - cornerRadius,
              ),
              itemBuilder: (context, index) {
                return ChatBubbleDriver(
                  message: messages[messages.length - 1 - index],
                  author: context.read<SupportPageCubit>().state.currentUser,
                );
              },
            ),
            if (!isChatStarted && !isGettingThread)
              Center(
                child: TextButton(
                  onPressed: () => onStartChatPressed(),
                  child: Text(context.l10n.startTheChat),
                ),
              ),
            if (isGettingThread) Center(child: CircularProgressIndicator()),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              right: 32,
              left: 32,
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      final highGraphics = context
                          .select<GlobalGraphicBloc, bool>(
                            (bloc) => bloc.state.highGraphics,
                          );
                      return Material(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(cornerRadius),
                        ),
                        clipBehavior: .antiAlias,
                        child: BackdropFilter(
                          enabled: highGraphics,
                          filter: .blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            height: 100,
                            color: context.appColorScheme.surfaceContainer
                                .withValues(alpha: highGraphics ? .5 : .97),
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
                                      context.l10n.contctOurSupportTeamFoAssistance,
                                      textAlign: .center,
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
                      );
                    },
                  ),
                  IgnorePointer(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          context.appColorScheme.outline.withValues(alpha: .2),
                          context.appColorScheme.outline.withValues(alpha: .1),
                          Colors.transparent,
                          Colors.transparent,
                          context.appColorScheme.outline.withValues(alpha: .1),
                        ],
                      ).createShader(bounds),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: .circular(cornerRadius),
                          border: .all(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showDownArrow)
              Positioned(
                bottom:
                    MediaQuery.paddingOf(context).bottom +
                    84, // - cornerRadius,
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
              bottom:
                  MediaQuery.paddingOf(context).bottom + 10, // - cornerRadius,
              right: 4,
              left: 4,
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      final highGraphics = context
                          .select<GlobalGraphicBloc, bool>(
                            (bloc) => bloc.state.highGraphics,
                          );
                      return Material(
                        color: Colors.transparent,
                        borderRadius: .circular(22),
                        clipBehavior: .antiAlias,
                        child: BackdropFilter(
                          enabled: highGraphics,
                          filter: .blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            height: 48,
                            color: context.appColorScheme.primaryContainer
                                .withValues(alpha: highGraphics ? .4 : .97),
                            child: Row(
                              crossAxisAlignment: .end,
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: isChatStarted,
                                    controller: context
                                        .read<SupportPageCubit>()
                                        .state
                                        .messageInputController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hint: Text(context.l10n.typeYourQuestion),
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    final isSendingMessage = context
                                        .select<SupportPageCubit, bool>(
                                          (cubit) =>
                                              cubit.state.isSenndingMessage,
                                        );
                                    return IconButton(
                                      onPressed: !isChatStarted
                                          ? null
                                          : isSendingMessage
                                          ? null
                                          : onSendPressed,
                                      icon: isSendingMessage
                                          ? CircularProgressIndicator()
                                          : Icon(Icons.send),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  IgnorePointer(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          context.appColorScheme.outline.withValues(alpha: .2),
                          context.appColorScheme.outline.withValues(alpha: .1),
                          Colors.transparent,
                          Colors.transparent,
                          context.appColorScheme.outline.withValues(alpha: .1),
                        ],
                      ).createShader(bounds),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: .circular(22),
                          border: .all(color: Colors.white),
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
