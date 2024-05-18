package com.github.mdeluise.plantit.notification.ntfy;

import com.github.mdeluise.plantit.notification.dispatcher.config.AbstractNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfig;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "ntfy_notification_configs")
public class NtfyNotificationDispatcherConfig extends AbstractNotificationDispatcherConfig {
    private String url;
    private String topic;
    private String username;
    private String password;
    private String token;


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }


    public String getTopic() {
        return topic;
    }


    public void setTopic(String topic) {
        this.topic = topic;
    }


    public String getUsername() {
        return username;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public String getPassword() {
        return password;
    }


    public void setPassword(String password) {
        this.password = password;
    }


    public String getToken() {
        return token;
    }


    public void setToken(String token) {
        this.token = token;
    }


    @Override
    public void update(NotificationDispatcherConfig updated) {
        if (!(updated instanceof NtfyNotificationDispatcherConfig)) {
            throw new UnsupportedOperationException("Updated class must be of type NtfyNotificationDispatcherConfig");
        }
        final NtfyNotificationDispatcherConfig ntfyUpdated = (NtfyNotificationDispatcherConfig) updated;
        this.setUrl(ntfyUpdated.getUrl());
        this.setTopic(ntfyUpdated.getTopic());
        this.setUsername(ntfyUpdated.getUsername());
        this.setPassword(ntfyUpdated.getPassword());
        this.setToken(ntfyUpdated.getToken());
    }
}
