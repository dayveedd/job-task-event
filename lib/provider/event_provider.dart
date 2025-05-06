import 'package:flutter/material.dart';
import 'package:job_task_event/model/event_model.dart';
import 'package:job_task_event/services/get_all_events.dart';

enum EventStatus { loading, loaded, error }

class EventProvider extends ChangeNotifier {
  final EventRepository repository;
  EventProvider(this.repository);

  EventStatus status = EventStatus.loading;
  List<EventModel> events = [];
  String? error;

  Future<void> fetchEvents() async {
    try {
      status = EventStatus.loading;
      notifyListeners();

      final data = await repository.getAllEvents();
      events = data.map((e) => EventModel.fromJson(e)).toList();
      status = EventStatus.loaded;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      status = EventStatus.error;
      notifyListeners();
    }
  }
}
