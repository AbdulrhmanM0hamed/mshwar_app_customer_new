/// Chat Message Model - Messages between user and driver
class ChatMessageModel {
  final String id;
  final String rideId;
  final String senderId;
  final String senderType;
  final String message;
  final String? imageUrl;
  final String? videoUrl;
  final String messageType;
  final bool isRead;
  final String createdAt;
  final String? updatedAt;

  ChatMessageModel({
    required this.id,
    required this.rideId,
    required this.senderId,
    required this.senderType,
    required this.message,
    this.imageUrl,
    this.videoUrl,
    this.messageType = 'text',
    this.isRead = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      rideId: json['ride_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? 'user',
      message: json['message']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      videoUrl: json['video_url']?.toString(),
      messageType: json['message_type']?.toString() ?? 'text',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'sender_id': senderId,
      'sender_type': senderType,
      'message': message,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'message_type': messageType,
      'is_read': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  bool get isTextMessage => messageType == 'text';
  bool get isImageMessage => messageType == 'image';
  bool get isVideoMessage => messageType == 'video';
  bool get isSentByUser => senderType == 'user';
  bool get isSentByDriver => senderType == 'driver';

  ChatMessageModel copyWith({
    String? id,
    String? rideId,
    String? senderId,
    String? senderType,
    String? message,
    String? imageUrl,
    String? videoUrl,
    String? messageType,
    bool? isRead,
    String? createdAt,
    String? updatedAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      rideId: rideId ?? this.rideId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
