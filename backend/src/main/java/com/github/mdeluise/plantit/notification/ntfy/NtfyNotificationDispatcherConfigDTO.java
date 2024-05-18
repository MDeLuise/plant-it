package com.github.mdeluise.plantit.notification.ntfy;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Ntfy notification config", description = "Represents the ntfy notifier configuration")
public class NtfyNotificationDispatcherConfigDTO {
    @Schema(description = "id of the config", accessMode = Schema.AccessMode.READ_ONLY)
    private String id;
    @Schema(description = "url of the ntfy server")
    private String url;
    @Schema(description = "topic of the ntfy server")
    private String topic;
    @Schema(description = "username for auth in the ntfy server")
    private String username;
    @Schema(description = "password for auth in the ntfy server")
    private String password;
    @Schema(description = "token for auth in the ntfy server")
    private String token;


    public String getId() {
        return id;
    }


    public void setId(String id) {
        this.id = id;
    }


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
}
