enum UserSettingsKeys {
  notificationEnabled('notification_enabled'),
  notificationTimeMonday('notification_time_monday'),
  notificationTimeTuesday('notification_time_tuesday'),
  notificationTimeWednesday('notification_time_wednesday'),
  notificationTimeThursday('notification_time_thursday'),
  notificationTimeFriday('notification_time_friday'),
  notificationTimeSaturday('notification_time_saturday'),
  notificationTimeSunday('notification_time_sunday');

  final String key;

  const UserSettingsKeys(this.key);
}
