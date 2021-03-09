class Message {
  final String? message;
  final String senderUid;
  final String? receiverUid;
  final String? senderName;
  final int time;
  final String type;
  Message({
    this.senderName,
    required this.type,
    required this.time,
    required this.message,
    required this.senderUid,
    required this.receiverUid,
  });
}
