import 'package:cabme/features/ride_new/data/models/chat_message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/chat_repository.dart';
import 'chat_state.dart';

/// Chat Cubit - Manages chat with driver
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(ChatInitial());

  /// Load chat messages
  Future<void> loadMessages(String rideId) async {
    emit(ChatLoading());
    try {
      final messages = await repository.getChatMessages(rideId);
      
      if (messages.isEmpty) {
        emit(ChatEmpty());
      } else {
        emit(ChatLoaded(messages));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// Send text message
  Future<void> sendMessage(String rideId, String message) async {
    final currentState = state;
    final currentMessages = currentState is ChatLoaded ? currentState.messages : <ChatMessageModel>[];
    
    emit(ChatSendingMessage(currentMessages));
    
    try {
      final sentMessage = await repository.sendMessage(rideId, message);
      final updatedMessages = [...currentMessages, sentMessage];
      
      emit(ChatMessageSent(sentMessage, updatedMessages));
      emit(ChatLoaded(updatedMessages));
    } catch (e) {
      emit(ChatSendError(e.toString()));
      if (currentMessages.isNotEmpty) {
        emit(ChatLoaded(currentMessages));
      }
    }
  }

  /// Send image message
  Future<void> sendImage(String rideId, String imagePath) async {
    final currentState = state;
    final currentMessages = currentState is ChatLoaded ? currentState.messages : <ChatMessageModel>[];
    
    emit(ChatSendingMessage(currentMessages));
    
    try {
      final sentMessage = await repository.sendImage(rideId, imagePath);
      final updatedMessages = [...currentMessages, sentMessage];
      
      emit(ChatMessageSent(sentMessage, updatedMessages));
      emit(ChatLoaded(updatedMessages));
    } catch (e) {
      emit(ChatSendError(e.toString()));
      if (currentMessages.isNotEmpty) {
        emit(ChatLoaded(currentMessages));
      }
    }
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await repository.markAsRead(messageId);
    } catch (e) {
      // Silent fail - not critical
    }
  }

  /// Refresh messages
  Future<void> refresh(String rideId) async {
    await loadMessages(rideId);
  }
}
