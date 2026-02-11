import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../cubit/chat/chat_cubit.dart';
import '../cubit/chat/chat_state.dart';
import '../widgets/chat_message_widget.dart';

/// Chat Page - Real-time chat with driver
class ChatPage extends StatefulWidget {
  final String rideId;

  const ChatPage({
    super.key,
    required this.rideId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<ChatCubit>()..loadMessages(widget.rideId),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.chatWithDriver,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            // Messages List
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatMessageSent) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: isDark ? Colors.white : AppThemeData.primary200,
                      ),
                    );
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.message_remove,
                              size: 64,
                              color: AppThemeData.error200,
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              text: 'Error loading messages',
                              size: 16,
                              weight: FontWeight.w600,
                              color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              text: state.message,
                              size: 14,
                              color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                              align: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ChatEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.message,
                            size: 64,
                            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey400,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            text: 'No messages yet',
                            size: 16,
                            weight: FontWeight.w600,
                            color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: 'Start a conversation with your driver',
                            size: 14,
                            color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                          ),
                        ],
                      ),
                    );
                  }

                  final messages = state is ChatLoaded 
                      ? state.messages 
                      : state is ChatSendingMessage
                          ? state.currentMessages
                          : state is ChatMessageSent
                              ? state.allMessages
                              : <dynamic>[];

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageWidget(
                        message: messages[index],
                        isDarkMode: isDark,
                      );
                    },
                  );
                },
              ),
            ),
            
            // Message Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppThemeData.grey800Dark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppThemeData.grey800 : AppThemeData.grey100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: l10n.typeAMessage,
                          hintStyle: TextStyle(
                            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                          fontSize: 14,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      final isSending = state is ChatSendingMessage;
                      
                      return InkWell(
                        onTap: isSending ? null : () {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            context.read<ChatCubit>().sendMessage(widget.rideId, message);
                            _messageController.clear();
                          }
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSending 
                                ? AppThemeData.grey400 
                                : AppThemeData.primary200,
                            shape: BoxShape.circle,
                          ),
                          child: isSending
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Icon(
                                  Iconsax.send_1,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      );
                    },
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
