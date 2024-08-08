package com.github.mdeluise.plantit.notification.gotify;

import com.github.mdeluise.plantit.notification.dispatcher.config.AbstractNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfig;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "gotify_notification_configs")
public class GotifyNotificationDispatcherConfig extends AbstractNotificationDispatcherConfig {
    private String url;
    private String token;


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }


    public String getToken() {
        return token;
    }


    public void setToken(String token) {
        this.token = token;
    }


    @Override
    public void update(NotificationDispatcherConfig updated) {
        if (!(updated instanceof GotifyNotificationDispatcherConfig)) {
            throw new UnsupportedOperationException("Updated class must be of type GotifyNotificationDispatcherConfig");
        }
        final GotifyNotificationDispatcherConfig gotifyUpdated = (GotifyNotificationDispatcherConfig) updated;
        this.setUrl(gotifyUpdated.getUrl());
        this.setToken(gotifyUpdated.getToken());
    }
}
