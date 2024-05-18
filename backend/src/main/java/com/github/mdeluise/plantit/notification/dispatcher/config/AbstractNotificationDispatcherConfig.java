package com.github.mdeluise.plantit.notification.dispatcher.config;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class AbstractNotificationDispatcherConfig implements NotificationDispatcherConfig {
    @Id
    @GeneratedValue
    private Long id;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    @NotNull
    @Enumerated(EnumType.STRING)
    private NotificationDispatcherName service;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    @Override
    public User getUser() {
        return user;
    }


    @Override
    public void setUser(User user) {
        this.user = user;
    }


    @Override
    public NotificationDispatcherName getServiceName() {
        return service;
    }


    @Override
    public void setServiceName(NotificationDispatcherName name) {
        this.service = name;
    }
}
