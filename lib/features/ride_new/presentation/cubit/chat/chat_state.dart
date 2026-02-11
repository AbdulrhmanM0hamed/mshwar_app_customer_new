import 'package:equatable/equatable.dart';
import '../../../data/models/chat_message_model.dart';

/// Chat States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatEmpty extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatSendingMessage extends ChatState {
  final List<ChatMessageModel> currentMessages;

  const ChatSendingMessage(this.currentMessages);

  @override
  List<Object?> get props => [currentMessages];
}

class ChatMessageSent extends ChatState {
  final ChatMessageModel message;
  final List<ChatMessageModel> allMessages;

  const ChatMessageSent(this.message, this.allMessages);

  @override
  List<Object?> get props => [message, allMessages];
}

class ChatSendError extends ChatState {
  final String message;

  const ChatSendError(this.message);

  @override
  List<Object?> get props => [message];
}
