package com.github.mdeluise.plantit.notification.ntfy;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.reminder.Reminder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

@Component
public class NtfyNotificationDispatcher implements NotificationDispatcher {
    private final String url;
    private final String topic;
    private final String username;
    private final String password;
    private final String token;
    private final Logger logger = LoggerFactory.getLogger(NtfyNotificationDispatcher.class);


    public NtfyNotificationDispatcher(@Value("${server.notification.ntfy.url}") String url,
                                      @Value("${server.notification.ntfy.topic}") String topic,
                                      @Value("${server.notification.ntfy.username}") String username,
                                      @Value("${server.notification.ntfy.password}") String password,
                                      @Value("${server.notification.ntfy.token}") String token) {
        if (!username.isEmpty() ^ !password.isEmpty()) {
            final String errorMsg = "Either both username and password must be provided or both left empty.";
            logger.error(errorMsg);
            throw new IllegalArgumentException(errorMsg);
        }
        if (!url.isBlank() && topic.isBlank()) {
            final String errorMsg = "NTFY topic must be provided.";
            logger.error(errorMsg);
            throw new IllegalArgumentException(errorMsg);
        }
        this.url = url;
        this.topic = topic;
        this.username = username;
        this.password = password;
        this.token = token;
    }


    public void notifyReminder(Reminder reminder) throws NotifyException {
        final HttpClient httpClient = HttpClient.newHttpClient();
        final HttpRequest.Builder requestBuilder = HttpRequest.newBuilder().uri(URI.create(url + "/" + topic))
                                                              .header(HttpHeaders.CONTENT_TYPE, "application/json")
                                                              .header("X-Title",
                                                                  reminder.getTarget().getInfo().getPersonalName())
                                                              .header("X-Tags", "seedling");

        // Set request body
        final String requestBody =
            "Time to take care of " + reminder.getTarget().getInfo().getPersonalName() + ", action required: " +
                reminder.getAction();
        final HttpRequest.BodyPublisher bodyPublisher =
            HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8);
        requestBuilder.method("POST", bodyPublisher);

        // Set authentication based on provided credentials
        if (username != null && password != null) {
            final String credentials = username + ":" + password;
            final String basicAuth = "Basic " + Base64.getEncoder().encodeToString(credentials.getBytes());
            requestBuilder.header(HttpHeaders.AUTHORIZATION, basicAuth);
        } else if (token != null) {
            requestBuilder.header(HttpHeaders.AUTHORIZATION, "Bearer " + token);
        }

        try {
            final HttpRequest httpRequest = requestBuilder.build();
            final HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());

            // Handle response
            int statusCode = response.statusCode();
            if (statusCode < 200 || statusCode >= 300) {
                throw new NotifyException("Failed to send notification. Response code: " + statusCode);
            }
        } catch (Exception e) {
            throw new NotifyException(e);
        }
    }


    @Override
    public NotificationDispatcherName getName() {
        return NotificationDispatcherName.NTFY;
    }


    @Override
    public boolean isEnabled() {
        return !url.isBlank();
    }
}
