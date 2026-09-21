abstract interface class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> scheduleDaily({required int hour, required int minute});
  Future<void> cancelDaily();
}
