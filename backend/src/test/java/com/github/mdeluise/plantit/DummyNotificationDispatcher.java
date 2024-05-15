package com.github.mdeluise.plantit;

import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfig;
import com.github.mdeluise.plantit.reminder.Reminder;

public class DummyNotificationDispatcher implements NotificationDispatcher {
    private final boolean enabled;
    public DummyNotificationDispatcher(boolean enabled) {
        this.enabled = enabled;
    }


    @Override
    public void notifyReminder(Reminder reminder) {
    }


    @Override
    public NotificationDispatcherName getName() {
        return null;
    }


    @Override
    public boolean isEnabled() {
        return enabled;
    }


    @Override
    public void loadConfig(NotificationDispatcherConfig config) {
    }


    @Override
    public void initConfig() {
    }
}
