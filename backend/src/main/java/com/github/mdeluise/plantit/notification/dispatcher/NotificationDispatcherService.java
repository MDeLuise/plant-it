package com.github.mdeluise.plantit.notification.dispatcher;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.notification.dispatcher.config.AbstractNotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfigImplRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NotificationDispatcherService {
    private final AuthenticatedUserService authenticatedUserService;
    private final UserService userService;
    private final List<NotificationDispatcher> notificationDispatchers;
    private final NotificationDispatcherConfigImplRepository notificationDispatcherConfigImplRepository;


    @Autowired
    public NotificationDispatcherService(AuthenticatedUserService authenticatedUserService, UserService userService,
                                         List<NotificationDispatcher> listNotificationDispatchers,
                                         NotificationDispatcherConfigImplRepository notificationDispatcherConfigImplRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.userService = userService;
        this.notificationDispatchers = listNotificationDispatchers;
        this.notificationDispatcherConfigImplRepository = notificationDispatcherConfigImplRepository;
    }


    public void setNotificationDispatchersForUser(Set<NotificationDispatcherName> notificationDispatchers) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        authenticatedUser.setNotificationDispatchers(notificationDispatchers);
        userService.save(authenticatedUser);
    }


    public Collection<NotificationDispatcherName> getNotificationDispatchersForUser() {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        return authenticatedUser.getNotificationDispatchers();
    }


    public Collection<NotificationDispatcherName> getAvailableNotificationDispatchers() {
        return notificationDispatchers.stream()
                                      .filter(NotificationDispatcher::isEnabled)
                                      .map(NotificationDispatcher::getName)
                                      .collect(Collectors.toSet());
    }


    public Optional<AbstractNotificationDispatcherConfig> getUserConfig(NotificationDispatcherName name) {
        return notificationDispatcherConfigImplRepository.findByServiceAndUser(
            name, authenticatedUserService.getAuthenticatedUser());
    }


    public void setUserConfig(NotificationDispatcherName name, AbstractNotificationDispatcherConfig updated) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        final Optional<AbstractNotificationDispatcherConfig> existingConfig =
            notificationDispatcherConfigImplRepository.findByServiceAndUser(name, authenticatedUser);
        AbstractNotificationDispatcherConfig toSave;
        if (existingConfig.isPresent()) {
            existingConfig.get().update(updated);
            toSave = existingConfig.get();
        } else {
            updated.setUser(authenticatedUser);
            updated.setServiceName(name);
            toSave = updated;
        }
        notificationDispatcherConfigImplRepository.save(toSave);
    }
}
