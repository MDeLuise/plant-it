package com.github.mdeluise.plantit.notification.password;

import java.util.Date;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.UserRepository;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TemporaryPasswordService {
    private final TemporaryPasswordRepository temporaryPasswordRepository;
    private final TemporaryPasswordGenerator temporaryPasswordGenerator;
    private final UserRepository userRepository;
    private final Logger logger = LoggerFactory.getLogger(TemporaryPasswordService.class);


    @Autowired
    public TemporaryPasswordService(TemporaryPasswordRepository temporaryPasswordRepository,
                                    TemporaryPasswordGenerator temporaryPasswordGenerator,
                                    UserRepository userRepository) {
        this.temporaryPasswordRepository = temporaryPasswordRepository;
        this.temporaryPasswordGenerator = temporaryPasswordGenerator;
        this.userRepository = userRepository;
    }


    public String generateNew(String username) {
        userRepository.findByUsername(username).orElseThrow(() -> new ResourceNotFoundException("username", username));
        final TemporaryPassword temporaryPassword = temporaryPasswordGenerator.generateTemporaryPassword(30, username);
        logger.info("Generated temporary password for user {} with expiration {}", temporaryPassword.getUsername(),
                    temporaryPassword.getExpiration()
        );
        temporaryPasswordRepository.save(temporaryPassword);
        return temporaryPassword.getPlainPassword();
    }


    public void removeExpired() {
        temporaryPasswordRepository.findAll().forEach(tmpPsw -> {
            if (tmpPsw.getExpiration().before(new Date())) {
                logger.debug(
                    "Temporary password for {} expired at {}, removing...", tmpPsw.getUsername(), tmpPsw.getExpiration());
                temporaryPasswordRepository.delete(tmpPsw);
            }
        });
    }


    public void remove(String username) {
        get(username).orElseThrow(() -> new ResourceNotFoundException("username", username));
        temporaryPasswordRepository.deleteById(username);
    }

    public void removeIfExists(String username) {
        try {
            remove(username);
        } catch (ResourceNotFoundException ignored) { }
    }


    public Optional<TemporaryPassword> get(String id) {
        return temporaryPasswordRepository.findById(id);
    }
}
