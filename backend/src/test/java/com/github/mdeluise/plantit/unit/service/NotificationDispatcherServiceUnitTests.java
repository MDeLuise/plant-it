package com.github.mdeluise.plantit.unit.service;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherService;
import com.github.mdeluise.plantit.reminder.Reminder;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for NotificationDispatcherService")
class NotificationDispatcherServiceUnitTests {
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @Mock
    private UserService userService;
    private NotificationDispatcherService notificationDispatcherService;


    private class DummyNotificationDispatcher implements NotificationDispatcher {
        private final boolean isEnabled;


        private DummyNotificationDispatcher(boolean isEnabled) {
            this.isEnabled = isEnabled;
        }


        @Override
        public void notifyReminder(Reminder reminder) throws NotifyException {

        }


        @Override
        public NotificationDispatcherName getName() {
            return null;
        }


        @Override
        public boolean isEnabled() {
            return isEnabled;
        }
    }


    @Test
    @DisplayName("Should set notification dispatchers for user")
    void shouldSetNotificationDispatchersForUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final List<NotificationDispatcher> available =
            List.of(new DummyNotificationDispatcher(true), new DummyNotificationDispatcher(true));
        final Set<NotificationDispatcherName> availableNames =
            available.stream().map(NotificationDispatcher::getName).collect(Collectors.toSet());
        notificationDispatcherService =
            new NotificationDispatcherService(authenticatedUserService, userService, available);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);

        notificationDispatcherService.setNotificationDispatchersForUser(availableNames);

        Assertions.assertThat(authenticated.getNotificationDispatchers()).hasSameElementsAs(availableNames);
        Mockito.verify(userService).save(authenticated);
    }


    @Test
    @DisplayName("Should get available notification dispatchers")
    void shouldGetAvailableNotificationDispatchers() {
        final List<NotificationDispatcher> available =
            List.of(new DummyNotificationDispatcher(true), new DummyNotificationDispatcher(false));
        notificationDispatcherService =
            new NotificationDispatcherService(authenticatedUserService, userService, available);

        final Collection<NotificationDispatcherName> result =
            notificationDispatcherService.getAvailableNotificationDispatchers();

        Assertions.assertThat(result).hasSize(1);
    }
}
