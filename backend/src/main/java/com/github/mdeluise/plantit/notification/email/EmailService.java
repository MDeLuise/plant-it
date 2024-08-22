package com.github.mdeluise.plantit.notification.email;

import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.notification.dispatcher.config.NotificationDispatcherConfig;
import com.github.mdeluise.plantit.notification.otp.OtpService;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import com.github.mdeluise.plantit.reminder.Reminder;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.MimeMessage;
import org.apache.logging.log4j.util.Strings;
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
public class EmailService implements NotificationDispatcher {
    private final JavaMailSender emailSender;
    private final SpringTemplateEngine templateEngine;
    private final OtpService otpService;
    private final TemporaryPasswordService temporaryPasswordService;
    private final String contactEmail;
    private final boolean enabled;
    private final String from;
    private final Logger logger = LoggerFactory.getLogger(EmailService.class);


    @SuppressWarnings("ParameterNumber") //FIXME
    @Autowired
    public EmailService(JavaMailSender emailSender, SpringTemplateEngine templateEngine, OtpService otpService,
                        TemporaryPasswordService temporaryPasswordService,
                        @Value("${server.owner.contact}") String contactEmail,
                        @Value("${spring.mail.host}") String smtpHost,
                        @Value("${spring.mail.username}") String from) throws EmailException {
        this.emailSender = emailSender;
        this.templateEngine = templateEngine;
        this.otpService = otpService;
        this.temporaryPasswordService = temporaryPasswordService;
        this.contactEmail = contactEmail;
        this.enabled = Strings.isNotEmpty(smtpHost);
        this.from = from;
        if (isEnabled()) {
            checkConnection();
        }
    }


    public void sendOtpMessage(String username, String to) throws EmailException {
        final MimeMessage message = emailSender.createMimeMessage();
        final MimeMessageHelper helper = createMessageHelper(message, to, "Welcome to Plant-It: Confirm Your Account");

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
        final JavaMailSenderImpl emailSenderImpl = (JavaMailSenderImpl) emailSender;
        final Session session = emailSenderImpl.getSession();
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
        final MimeMessageHelper helper = createMessageHelper(message, to, "Password reset");

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
        final MimeMessageHelper helper = createMessageHelper(message, newEmail, "Email change");

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
        final MimeMessageHelper helper = createMessageHelper(message, email, "Password change");

        final Context context = new Context();
        context.setVariable("supportEmail", contactEmail);
        context.setVariable("username", username);

        final String emailContent = getEmailContent("passwordChange.html", context);

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            throw new EmailException(e);
        }

        emailSender.send(message);
    }


    @Override
    public void notifyReminder(Reminder reminder) throws NotifyException {
        final MimeMessage message = emailSender.createMimeMessage();
        final String email = reminder.getTarget().getOwner().getEmail();
        final String subject = "Reminder: Time to Care for " + reminder.getTarget().getInfo().getPersonalName();
        final MimeMessageHelper helper;
        try {
            helper = createMessageHelper(message, email, subject);
        } catch (EmailException e) {
            logger.error("Error while notify about the reminder", e);
            throw new NotifyException(e);
        }

        final Context context = new Context();
        context.setVariable("username", reminder.getTarget().getOwner().getUsername());
        context.setVariable("plantName", reminder.getTarget().getInfo().getPersonalName());
        context.setVariable("action", reminder.getAction());
        final String emailContent;
        try {
            emailContent = getEmailContent("reminder.html", context);
        } catch (EmailException e) {
            logger.error("Error while get the email template content", e);
            throw new NotifyException(e);
        }

        try {
            helper.setText(emailContent, true);
        } catch (MessagingException e) {
            logger.error("Error while set text of the email", e);
            throw new NotifyException(e);
        }

        emailSender.send(message);
    }


    @Override
    public NotificationDispatcherName getName() {
        return NotificationDispatcherName.EMAIL;
    }


    @Override
    public boolean isEnabled() {
        return enabled;
    }


    @Override
    public void loadConfig(NotificationDispatcherConfig config) {
    }


    @Override
    public void initConfig() {
    }


    private MimeMessageHelper createMessageHelper(MimeMessage mimeMessage, String to, String subject)
        throws EmailException {
        final MimeMessageHelper helper;
        try {
            helper = new MimeMessageHelper(mimeMessage, true);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setFrom(from);
        } catch (MessagingException e) {
            logger.error("Error while setting mail to send", e);
            throw new EmailException(e);
        }
        return helper;
    }
}
