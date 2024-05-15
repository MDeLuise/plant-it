package com.github.mdeluise.plantit.notification.dispatcher.config;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;

public interface NotificationDispatcherConfig {
    User getUser();

    void setUser(User user);

    NotificationDispatcherName getServiceName();

    void setServiceName(NotificationDispatcherName name);

    void update(NotificationDispatcherConfig updated);
}
