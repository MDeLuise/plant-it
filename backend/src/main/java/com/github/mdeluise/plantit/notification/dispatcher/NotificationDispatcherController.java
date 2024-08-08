package com.github.mdeluise.plantit.notification.dispatcher;

import java.util.Collection;
import java.util.Set;

import com.github.mdeluise.plantit.common.MessageResponse;
import com.github.mdeluise.plantit.notification.dispatcher.config.AbstractNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.gotify.GotifyNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.gotify.GotifyNotificationDispatcherConfigDTO;
import com.github.mdeluise.plantit.notification.gotify.GotifyNotificationDispatcherDTOConverter;
import com.github.mdeluise.plantit.notification.ntfy.NtfyNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.ntfy.NtfyNotificationDispatcherConfigDTO;
import com.github.mdeluise.plantit.notification.ntfy.NtfyNotificationDispatcherDTOConverter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/notification-dispatcher")
@Tag(name = "Notifications", description = "Endpoints for notifications management")
public class NotificationDispatcherController {
    private final NotificationDispatcherService notificationDispatcherService;
    private final NtfyNotificationDispatcherDTOConverter ntfyNotificationDispatcherDTOConverter;
    private final GotifyNotificationDispatcherDTOConverter gotifyNotificationDispatcherDTOConverter;


    @Autowired
    public NotificationDispatcherController(NotificationDispatcherService notificationDispatcherService,
                                            NtfyNotificationDispatcherDTOConverter ntfyNotificationDispatcherDTOConverter,
                                            GotifyNotificationDispatcherDTOConverter gotifyNotificationDispatcherDTOConverter) {
        this.notificationDispatcherService = notificationDispatcherService;
        this.ntfyNotificationDispatcherDTOConverter = ntfyNotificationDispatcherDTOConverter;
        this.gotifyNotificationDispatcherDTOConverter = gotifyNotificationDispatcherDTOConverter;
    }


    @GetMapping
    public ResponseEntity<Collection<NotificationDispatcherName>> getUserEnabled() {
        final Collection<NotificationDispatcherName> result =
            notificationDispatcherService.getNotificationDispatchersForUser();
        return ResponseEntity.ok(result);
    }


    @PutMapping
    public ResponseEntity<MessageResponse> setUserEnabled(@RequestBody Set<NotificationDispatcherName> toEnable) {
        notificationDispatcherService.setNotificationDispatchersForUser(toEnable);
        return ResponseEntity.ok(new MessageResponse("Success"));
    }


    @GetMapping("/config/ntfy")
    public NtfyNotificationDispatcherConfigDTO getNtfyConfig() {
        final NtfyNotificationDispatcherConfig result =
            (NtfyNotificationDispatcherConfig) notificationDispatcherService.getUserConfig(NotificationDispatcherName.NTFY)
                                                                            .orElse(new NtfyNotificationDispatcherConfig());
        return ntfyNotificationDispatcherDTOConverter.convertToDTO(result);
    }


    @PostMapping("/config/ntfy")
    public ResponseEntity<MessageResponse> setNtfyConfig(@RequestBody NtfyNotificationDispatcherConfigDTO config) {
        final AbstractNotificationDispatcherConfig toSave = ntfyNotificationDispatcherDTOConverter.convertFromDTO(config);
        notificationDispatcherService.setUserConfig(NotificationDispatcherName.NTFY, toSave);
        return ResponseEntity.ok(new MessageResponse("Success"));
    }


    @GetMapping("/config/gotify")
    public GotifyNotificationDispatcherConfigDTO getGotifyConfig() {
        final GotifyNotificationDispatcherConfig result =
            (GotifyNotificationDispatcherConfig) notificationDispatcherService.getUserConfig(NotificationDispatcherName.GOTIFY)
                                                                              .orElse(new GotifyNotificationDispatcherConfig());
        return gotifyNotificationDispatcherDTOConverter.convertToDTO(result);
    }


    @PostMapping("/config/gotify")
    public ResponseEntity<MessageResponse> setGotifyConfig(@RequestBody GotifyNotificationDispatcherConfigDTO config) {
        final AbstractNotificationDispatcherConfig toSave = gotifyNotificationDispatcherDTOConverter.convertFromDTO(config);
        notificationDispatcherService.setUserConfig(NotificationDispatcherName.GOTIFY, toSave);
        return ResponseEntity.ok(new MessageResponse("Success"));
    }
}
