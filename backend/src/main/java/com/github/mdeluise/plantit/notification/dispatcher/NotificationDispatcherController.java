package com.github.mdeluise.plantit.notification.dispatcher;

import java.util.Collection;
import java.util.Set;

import com.github.mdeluise.plantit.notification.dispatcher.config.AbstractNotificationDispatcherConfig;
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


    @Autowired
    public NotificationDispatcherController(NotificationDispatcherService notificationDispatcherService,
                                            NtfyNotificationDispatcherDTOConverter ntfyNotificationDispatcherDTOConverter) {
        this.notificationDispatcherService = notificationDispatcherService;
        this.ntfyNotificationDispatcherDTOConverter = ntfyNotificationDispatcherDTOConverter;
    }


    @GetMapping
    public ResponseEntity<Collection<NotificationDispatcherName>> getUserEnabled() {
        final Collection<NotificationDispatcherName> result =
            notificationDispatcherService.getNotificationDispatchersForUser();
        return ResponseEntity.ok(result);
    }


    @PutMapping
    public ResponseEntity<String> setUserEnabled(@RequestBody Set<NotificationDispatcherName> toEnable) {
        notificationDispatcherService.setNotificationDispatchersForUser(toEnable);
        return ResponseEntity.ok("Success");
    }


    @GetMapping("/config/ntfy")
    public NtfyNotificationDispatcherConfigDTO getConfig() {
        final NtfyNotificationDispatcherConfig result =
            (NtfyNotificationDispatcherConfig) notificationDispatcherService.getUserConfig(NotificationDispatcherName.NTFY)
                                                                            .orElse(new NtfyNotificationDispatcherConfig());
        return ntfyNotificationDispatcherDTOConverter.convertToDTO(result);
    }


    @PostMapping("/config/ntfy")
    public ResponseEntity<String> setConfig(@RequestBody NtfyNotificationDispatcherConfigDTO config) {
        final AbstractNotificationDispatcherConfig toSave = ntfyNotificationDispatcherDTOConverter.convertFromDTO(config);
        notificationDispatcherService.setUserConfig(NotificationDispatcherName.NTFY, toSave);
        return ResponseEntity.ok("Success");
    }
}
