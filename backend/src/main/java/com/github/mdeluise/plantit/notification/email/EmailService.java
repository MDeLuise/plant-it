package com.github.mdeluise.plantit.notification.email;

import com.github.mdeluise.plantit.notification.otp.OtpService;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;

@Service
public class EmailService {
    private final JavaMailSender emailSender;
    private final SpringTemplateEngine templateEngine;
    private final OtpService otpService;
    private final TemporaryPasswordService temporaryPasswordService;
    private final String contactEmail;
    private final Logger logger = LoggerFactory.getLogger(EmailService.class);


    @Autowired
    public EmailService(JavaMailSender emailSender, SpringTemplateEngine templateEngine, OtpService otpService,
                        TemporaryPasswordService temporaryPasswordService,
                        @Value("${server.owner.contact}") String contactEmail) {
        this.emailSender = emailSender;
        this.templateEngine = templateEngine;
        this.otpService = otpService;
        this.temporaryPasswordService = temporaryPasswordService;
        this.contactEmail = contactEmail;
    }


    public void sendOtpMessage(String username, String to) throws EmailException {
        final MimeMessage message = emailSender.createMimeMessage();
        final MimeMessageHelper helper;
        try {
            helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Welcome to Plant-It: Confirm Your Account");
        } catch (MessagingException e) {
            logger.error("Error while setting mail to send", e);
            throw new EmailException(e);
        }

        final String otpCode = otpService.generateNew(to);
        final Context context = new Context();
        context.setVariable("supportEmail", contactEmail);
        context.setVariable("username", username);
        context.setVariable("otpCode", otpCode);

        final String emailContent = getEmailContent("signup.html", context);

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            otpService.remove(otpCode);
            throw new RuntimeException(e);
        }

        emailSender.send(message);
    }


    private String getEmailContent(String templateName, Context context) throws EmailException {
        try {
            return templateEngine.process(templateName, context);
        } catch (Exception e) {
            logger.error("Error while processing email template {}", templateName, e);
            throw new EmailException(e);
        }
    }


    public void checkConnection() throws EmailException {
        JavaMailSenderImpl emailSenderImpl = (JavaMailSenderImpl) emailSender;
        Session session = emailSenderImpl.getSession();
        try {
            final Transport transport = session.getTransport("smtp");
            transport.connect(emailSenderImpl.getHost(), emailSenderImpl.getUsername(), emailSenderImpl.getPassword());
            transport.close();
            logger.info("SMTP successfully connected.");
        } catch (MessagingException e) {
            logger.error("SMTP connection failed.", e);
            throw new EmailException(e);
        }
    }


    public void sendTemporaryPasswordMessage(String username, String to) throws EmailException {
        final MimeMessage message = emailSender.createMimeMessage();
        final MimeMessageHelper helper;
        try {
            helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Password reset");
        } catch (MessagingException e) {
            logger.error("Error while setting mail to send", e);
            throw new EmailException(e);
        }

        final String temporaryPassword = temporaryPasswordService.generateNew(username);
        final Context context = new Context();
        context.setVariable("supportEmail", contactEmail);
        context.setVariable("username", username);
        context.setVariable("temporaryPassword", temporaryPassword);

        final String emailContent = getEmailContent("resetPsw.html", context);

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            otpService.remove(temporaryPassword);
            throw new RuntimeException(e);
        }

        emailSender.send(message);
    }


    public void sendEmailChangeNotification(String username, String newEmail) throws EmailException {
        final MimeMessage message = emailSender.createMimeMessage();
        final MimeMessageHelper helper;
        try {
            helper = new MimeMessageHelper(message, true);
            helper.setTo(newEmail);
            helper.setSubject("Email change");
        } catch (MessagingException e) {
            logger.error("Error while setting mail to send", e);
            throw new EmailException(e);
        }

        final Context context = new Context();
        context.setVariable("supportEmail", contactEmail);
        context.setVariable("username", username);
        context.setVariable("newEmail", newEmail);

        final String emailContent = getEmailContent("emailChange.html", context);

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            throw new RuntimeException(e);
        }

        emailSender.send(message);
    }


    public void sendPasswordChangeNotification(String username, String email) throws EmailException {
        final MimeMessage message = emailSender.createMimeMessage();
        final MimeMessageHelper helper;
        try {
            helper = new MimeMessageHelper(message, true);
            helper.setTo(email);
            helper.setSubject("Password change");
        } catch (MessagingException e) {
            logger.error("Error while setting mail to send", e);
            throw new EmailException(e);
        }

        final Context context = new Context();
        context.setVariable("supportEmail", contactEmail);
        context.setVariable("username", username);

        final String emailContent = getEmailContent("passwordChange.html", context);

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            throw new RuntimeException(e);
        }

        emailSender.send(message);
    }
}
