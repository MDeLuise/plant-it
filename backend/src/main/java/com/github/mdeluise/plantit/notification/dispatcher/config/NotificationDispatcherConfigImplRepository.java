package com.github.mdeluise.plantit.notification.dispatcher.config;

import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationDispatcherConfigImplRepository extends JpaRepository<AbstractNotificationDispatcherConfig, Long> {
    Optional<AbstractNotificationDispatcherConfig> findByServiceAndUser(NotificationDispatcherName service, User user);
}
