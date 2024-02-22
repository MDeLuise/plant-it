package com.github.mdeluise.plantit.notification.dispatcher;

import java.util.Collection;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/notification-dispatcher")
public class NotificationDispatcherController {
    private final NotificationDispatcherService notificationDispatcherService;


    @Autowired
    public NotificationDispatcherController(NotificationDispatcherService notificationDispatcherService) {
        this.notificationDispatcherService = notificationDispatcherService;
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
}
