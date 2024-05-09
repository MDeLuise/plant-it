package com.github.mdeluise.plantit.notification;

public class NotifyException extends Exception {
    public NotifyException(Throwable cause) {
        super("Error while notify about the reminder", cause);
    }

    public NotifyException(String cause) {
        super(cause);
    }
}
