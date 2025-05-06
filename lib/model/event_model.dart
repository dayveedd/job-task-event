class EventModel {
  final String eventName;
  final String eventSubtitle;
  final String eventPrice;
  final String eventDate;
  final String eventTime;

  const EventModel({
    required this.eventName,
    required this.eventSubtitle,
    required this.eventPrice,
    required this.eventDate,
    required this.eventTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventName: json['eventName'] ?? '',
      eventSubtitle: json['eventSubtitle'] ?? '',
      eventPrice: json['eventPrice'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventTime: json['eventTime'] ?? '',
    );
  }
}
