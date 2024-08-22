package com.github.mdeluise.plantit.unit.service;

import com.github.mdeluise.plantit.notification.email.EmailException;
import com.github.mdeluise.plantit.notification.email.EmailService;
import com.github.mdeluise.plantit.notification.otp.OtpService;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import jakarta.mail.NoSuchProviderException;
import jakarta.mail.Transport;
import jakarta.mail.internet.MimeMessage;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.thymeleaf.spring6.SpringTemplateEngine;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for EmailService")
class EmailServiceUnitTests {
    @Mock
    private JavaMailSenderImpl emailSender;
    @Mock
    private SpringTemplateEngine templateEngine;
    @Mock
    private OtpService otpService;
    @Mock
    private TemporaryPasswordService temporaryPasswordService;
    //@Mock
    //private Session session;
    @Mock
    private Transport transport;
    @Mock
    private MimeMessage mimeMessage;
    private final String from = "test@test.com";
    private EmailService emailService;


    @BeforeEach
    void setup() throws EmailException, NoSuchProviderException {
        //Mockito.when(session.getTransport("smtp")).thenReturn(transport);
        Mockito.when(emailSender.createMimeMessage()).thenReturn(mimeMessage);
        emailService =
            new EmailService(emailSender, templateEngine, otpService, temporaryPasswordService, "contact", "smtp", from);
    }


    //@Test
    @DisplayName("")
    void shouldSendOtpMessage() {
        // TODO
        final String email = "email";
        final String otpCode = "1234";
        Mockito.when(otpService.generateNew(email)).thenReturn(otpCode);
    }
}
