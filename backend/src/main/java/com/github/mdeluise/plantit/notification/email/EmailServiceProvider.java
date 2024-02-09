package com.github.mdeluise.plantit.notification.email;

import java.util.Optional;

import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceProvider {
    private final EmailService emailService;
    private final String smtpHost;


    @Autowired
    public EmailServiceProvider(@Value("${spring.mail.host}") String smtpHost, EmailService emailService)
        throws EmailException {
        this.emailService = emailService;
        this.smtpHost = smtpHost;
        if (Strings.isNotEmpty(smtpHost)) {
            emailService.checkConnection();
        }
    }


    public Optional<EmailService> get() {
        if (Strings.isNotEmpty(smtpHost)) {
            return Optional.of(emailService);
        }
        return Optional.empty();
    }
}
