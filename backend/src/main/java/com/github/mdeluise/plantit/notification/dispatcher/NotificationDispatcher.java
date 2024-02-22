package com.github.mdeluise.plantit.notification.dispatcher;

import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.reminder.Reminder;

public interface NotificationDispatcher {
    void notifyReminder(Reminder reminder) throws NotifyException;

    NotificationDispatcherName getName();

    boolean isEnabled();
}
