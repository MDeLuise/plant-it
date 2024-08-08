package com.github.mdeluise.plantit.notification.gotify;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Gotify notification config", description = "Represents the gotify notifier configuration")
public class GotifyNotificationDispatcherConfigDTO {
    @Schema(description = "id of the config", accessMode = Schema.AccessMode.READ_ONLY)
    private String id;
    @Schema(description = "url of the gotify server")
    private String url;
    @Schema(description = "token for auth in the gotify server")
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


    public String getToken() {
        return token;
    }


    public void setToken(String token) {
        this.token = token;
    }
}
