package com.github.mdeluise.plantit.unit.controller;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;

import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherService;
import com.github.mdeluise.plantit.systeminfo.SystemInfoController;
import com.github.mdeluise.plantit.systeminfo.SystemVersionInfo;
import com.github.mdeluise.plantit.systeminfo.SystemVersionService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for SystemInfoController")
class SystemInfoControllerUnitTests {
    @Mock
    private SystemVersionService systemVersionService;
    @Mock
    private NotificationDispatcherService notificationDispatcherService;
    @InjectMocks
    private SystemInfoController systemInfoController;


    @Test
    @DisplayName("Test get system version")
    void testGetVersion() throws IOException, InterruptedException {
        final SystemVersionInfo systemVersionInfo = new SystemVersionInfo();
        Mockito.when(systemVersionService.getLatestVersion()).thenReturn(systemVersionInfo);

        final ResponseEntity<SystemVersionInfo> responseEntity = systemInfoController.getVersion();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(systemVersionInfo, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get system version with IOException")
    void testGetVersionWithIOException() throws IOException, InterruptedException {
        Mockito.when(systemVersionService.getLatestVersion()).thenThrow(IOException.class);

        Assertions.assertThrows(IOException.class, () -> systemInfoController.getVersion());
    }


    @Test
    @DisplayName("Test get system version with InterruptedException")
    void testGetVersionWithInterruptedException() throws IOException, InterruptedException {
        Mockito.when(systemVersionService.getLatestVersion()).thenThrow(InterruptedException.class);

        Assertions.assertThrows(InterruptedException.class, () -> systemInfoController.getVersion());
    }


    @Test
    @DisplayName("Test get notification dispatchers")
    void testGetNotificationDispatchers() {
        final Collection<NotificationDispatcherName> notificationDispatchers =
            Collections.singletonList(NotificationDispatcherName.CONSOLE);
        Mockito.when(notificationDispatcherService.getAvailableNotificationDispatchers())
               .thenReturn(notificationDispatchers);

        final ResponseEntity<Collection<NotificationDispatcherName>> responseEntity =
            systemInfoController.notificationsDispatchers();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(notificationDispatchers, responseEntity.getBody());
    }
}