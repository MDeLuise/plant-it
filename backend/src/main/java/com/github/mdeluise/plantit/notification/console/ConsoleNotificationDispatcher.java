package com.github.mdeluise.plantit.notification.console;

import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.reminder.Reminder;
import org.springframework.stereotype.Component;

@Component
public class ConsoleNotificationDispatcher implements NotificationDispatcher {

    @Override
    public void notifyReminder(Reminder reminder) {
        final String message = String.format(
            "[reminder for user %s] Time to care care for %s, action required: %s",
            reminder.getTarget().getOwner().getUsername(),
            reminder.getTarget().getInfo().getPersonalName(),
            reminder.getAction()
        );
        System.out.println(message);
    }


    @Override
    public NotificationDispatcherName getName() {
        return NotificationDispatcherName.CONSOLE;
    }


    @Override
    public boolean isEnabled() {
        return true;
    }
}
