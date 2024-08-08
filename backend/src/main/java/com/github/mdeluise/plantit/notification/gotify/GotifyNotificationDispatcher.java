package com.github.mdeluise.plantit.notification.gotify;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfig;
import com.github.mdeluise.plantit.reminder.Reminder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

@Component
public class GotifyNotificationDispatcher implements NotificationDispatcher {
    private final boolean enabled;
    private String url;
    private String token;
    private final Logger logger = LoggerFactory.getLogger(GotifyNotificationDispatcher.class);


    public GotifyNotificationDispatcher(@Value("${server.notification.gotify.enabled}") boolean enabled) {
        this.enabled = enabled;
    }


    public void notifyReminder(Reminder reminder) throws NotifyException {
        final HttpClient httpClient = HttpClient.newHttpClient();
        final URI uri = URI.create(url).resolve("/message?token=" + token);
        final String title = reminder.getTarget().getInfo().getPersonalName();
        final String message = "Time to take care of " + title + ", action required: " + reminder.getAction();
        final String body = String.format("{\"title\": \"%s\", \"message\": \"%s\"}", title, message);

        final HttpRequest request = HttpRequest.newBuilder()
                                               .uri(uri)
                                               .header(HttpHeaders.CONTENT_TYPE, "application/json")
                                               .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                                               .build();

        try {
            final HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            final int statusCode = response.statusCode();
            if (statusCode < 200 || statusCode >= 300) {
                throw new NotifyException("Failed to send notification. Response code: " + statusCode +
                                              " Response body: " + response.body());
            }
        } catch (Exception e) {
            throw new NotifyException(e);
        }
    }


    @Override
    public NotificationDispatcherName getName() {
        return NotificationDispatcherName.GOTIFY;
    }


    @Override
    public boolean isEnabled() {
        return enabled;
    }


    @Override
    public void loadConfig(NotificationDispatcherConfig config) {
        if (!(config instanceof GotifyNotificationDispatcherConfig gotifyConfig)) {
            throw new UnsupportedOperationException(
                "Configuration provided must be of type GotifyNotificationDispatcherConfig");
        }
        checkConfigParameters(gotifyConfig);
        url = gotifyConfig.getUrl();
        token = gotifyConfig.getToken();
    }


    @Override
    public void initConfig() {
        url = null;
        token = null;
    }


    private void checkConfigParameters(GotifyNotificationDispatcherConfig gotifyConfig) {
        if (gotifyConfig.getUrl() == null || gotifyConfig.getToken() == null) {
            final String errorMsg = "Gotify url and token must be provided.";
            logger.error(errorMsg);
            throw new IllegalArgumentException(errorMsg);
        }
    }
}
