import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/chat_message_model.dart';

/// Chat Message Widget - Displays chat message bubble
class ChatMessageWidget extends StatelessWidget {
  final ChatMessageModel message;
  final bool isDarkMode;
  final VoidCallback? onImageTap;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.isDarkMode = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isSentByUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppThemeData.primary200
                    : isDarkMode
                        ? AppThemeData.grey800Dark
                        : AppThemeData.grey100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Content
                  if (message.isTextMessage)
                    CustomText(
                      text: message.message,
                      size: 14,
                      color: isUser
                          ? Colors.white
                          : isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                    ),
                  
                  // Image Message
                  if (message.isImageMessage && message.imageUrl != null)
                    GestureDetector(
                      onTap: onImageTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: message.imageUrl!,
                          width: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 200,
                            height: 150,
                            color: isDarkMode ? AppThemeData.grey800 : AppThemeData.grey200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 200,
                            height: 150,
                            color: isDarkMode ? AppThemeData.grey800 : AppThemeData.grey200,
                            child: Icon(
                              Iconsax.gallery_slash,
                              color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Timestamp
                  const SizedBox(height: 4),
                  CustomText(
                    text: _formatTime(message.createdAt),
                    size: 11,
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.7)
                        : isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildReadStatus(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppThemeData.primary50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Iconsax.user,
        size: 18,
        color: AppThemeData.primary200,
      ),
    );
  }

  Widget _buildReadStatus() {
    return Icon(
      message.isRead ? Iconsax.tick_circle5 : Iconsax.tick_circle,
      size: 16,
      color: message.isRead ? AppThemeData.primary200 : AppThemeData.grey400,
    );
  }

  String _formatTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
