package com.github.mdeluise.plantit.authentication;

import java.util.List;
import java.util.Optional;
import javax.naming.AuthenticationException;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.notification.email.EmailException;
import com.github.mdeluise.plantit.notification.email.EmailService;
import com.github.mdeluise.plantit.notification.password.TemporaryPassword;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final TemporaryPasswordService temporaryPasswordService;
    private final Logger logger = LoggerFactory.getLogger(UserService.class);


    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder encoder,
                       EmailService emailService, TemporaryPasswordService temporaryPasswordService) {
        this.userRepository = userRepository;
        this.encoder = encoder;
        this.emailService = emailService;
        this.temporaryPasswordService = temporaryPasswordService;
    }


    public User get(String username) {
        return userRepository.findByUsername(username)
                             .orElseThrow(() -> new ResourceNotFoundException("username", username));
    }


    public User get(Long id) {
        return userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public List<User> getAll() {
        return userRepository.findAll();
    }


    public User save(String username, String plainPassword, String email) {
        final User user = new User();
        user.setUsername(username);
        user.setPassword(plainPassword);
        user.setEmail(email);
        return save(user);
    }


    @Transactional
    public User update(Long id, User updatedUser) {
        final User toUpdate = get(id);
        if (updatedUser.getUsername() != null && !updatedUser.getUsername().isBlank() &&
                !updatedUser.getUsername().equals(toUpdate.getUsername())) {
            toUpdate.setUsername(updatedUser.getUsername());
        }
        return userRepository.save(toUpdate);
    }


    public void updatePassword(Long userId, String currentPassword, String newPassword) throws AuthenticationException {
        final User toUpdate = get(userId);
        if (!encoder.matches(currentPassword, toUpdate.getPassword())) {
            final Optional<TemporaryPassword> optionalTemporaryPassword =
                temporaryPasswordService.get(toUpdate.getUsername());
            if (optionalTemporaryPassword.isEmpty() ||
                    !encoder.matches(currentPassword, optionalTemporaryPassword.get().getPassword())) {
                logger.error(
                    "Error while updating password for user {}, incorrect current password.", toUpdate.getUsername());
                throw new AuthenticationException("Current password does not match");
            } else {
                logger.debug("User {} update his password using a temporary password", toUpdate.getUsername());
            }
        }
        if (newPassword != null && !newPassword.isBlank() && !newPassword.equals(toUpdate.getPassword())) {
            final String encodedNewPassword = encoder.encode(newPassword);
            toUpdate.setPassword(encodedNewPassword);
            userRepository.save(toUpdate);
            temporaryPasswordService.remove(toUpdate.getUsername());
            logger.info("Password for user {} updated", toUpdate.getUsername());
            if (emailService.isEnabled()) {
                try {
                    emailService.sendPasswordChangeNotification(toUpdate.getUsername(), toUpdate.getEmail());
                    logger.info("Sent email to user in order to notify about the password change");
                } catch (EmailException e) {
                    logger.error("Error while sending password change notification to user", e);
                }
            }
        }
    }


    public void updateEmail(Long userId, String password, String newEmail) throws AuthenticationException {
        final User toUpdate = get(userId);
        if (!encoder.matches(password, toUpdate.getPassword())) {
            logger.error("Error while updating email for user {}, incorrect current password.", toUpdate.getUsername());
            throw new AuthenticationException("Incorrect password");
        }
        if (newEmail != null && !newEmail.isBlank() && !newEmail.equals(toUpdate.getPassword())) {
            toUpdate.setEmail(newEmail);
            userRepository.save(toUpdate);
            logger.info("Email for user {} updated", toUpdate.getUsername());
            if (emailService.isEnabled()) {
                try {
                    emailService.sendEmailChangeNotification(toUpdate.getUsername(), newEmail);
                    logger.info("Sent email to user in order to notify about the email change");
                } catch (EmailException e) {
                    logger.error("Error while sending email change notification to user", e);
                }
            }
        }
    }


    public void remove(Long id) {
        userRepository.deleteById(id);
    }


    @Transactional
    public User save(User entityToSave) {
        entityToSave.setPassword(encoder.encode(entityToSave.getPassword()));
        return userRepository.save(entityToSave);
    }


    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }


    public void removeAll() {
        userRepository.deleteAll();
    }


    public long count() {
        return userRepository.count();
    }


    public User getByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new ResourceNotFoundException("email", email));
    }


    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }
}
