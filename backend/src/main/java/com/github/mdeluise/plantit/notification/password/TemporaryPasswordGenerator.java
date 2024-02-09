package com.github.mdeluise.plantit.notification.password;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class TemporaryPasswordGenerator {
    private final PasswordEncoder encoder;


    @Autowired
    public TemporaryPasswordGenerator(PasswordEncoder encoder) {
        this.encoder = encoder;
    }


    public TemporaryPassword generateTemporaryPassword(int expireMins, String username) {
        final TemporaryPassword temporaryPassword = new TemporaryPassword();
        temporaryPassword.setUsername(username);
        final UUID uuid = UUID.randomUUID();
        final String temporaryPasswordValue = uuid.toString().replaceAll("-", "");
        temporaryPassword.setPassword(encoder.encode(temporaryPasswordValue));
        temporaryPassword.setPlainPassword(temporaryPasswordValue);
        final LocalDateTime currentDateTime = LocalDateTime.now();
        final LocalDateTime newDateTime = currentDateTime.plusMinutes(expireMins);
        temporaryPassword.setExpiration(Date.from(newDateTime.atZone(ZoneId.systemDefault()).toInstant()));
        return temporaryPassword;
    }
}
