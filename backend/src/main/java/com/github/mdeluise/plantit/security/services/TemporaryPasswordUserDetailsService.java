package com.github.mdeluise.plantit.security.services;

import java.util.Collections;
import java.util.Date;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserRepository;
import com.github.mdeluise.plantit.notification.password.TemporaryPassword;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordRepository;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class TemporaryPasswordUserDetailsService implements UserDetailsService {
    private final TemporaryPasswordRepository temporaryPasswordRepository;
    private final UserRepository userRepository;
    private final Logger logger = LoggerFactory.getLogger(TemporaryPasswordService.class);


    @Autowired
    public TemporaryPasswordUserDetailsService(TemporaryPasswordRepository temporaryPasswordRepository,
                                               UserRepository userRepository) {
        this.temporaryPasswordRepository = temporaryPasswordRepository;
        this.userRepository = userRepository;
    }


    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        final Optional<User> optionalUser = userRepository.findByUsername(username);
        final Optional<TemporaryPassword> optionalTemporaryPassword = temporaryPasswordRepository.findById(username);
        if (optionalTemporaryPassword.isEmpty() || optionalTemporaryPassword.get().getExpiration().before(new Date()) ||
                optionalUser.isEmpty()) {
            logger.error("Temporary password not found for user {}", username);
            throw new UsernameNotFoundException("Temporary password not found for user: " + username);
        }
        final TemporaryPassword temporaryPassword = optionalTemporaryPassword.get();
        return new UserDetailsImpl(
            optionalUser.get().getId(), optionalUser.get().getUsername(), temporaryPassword.getPassword(),
            Collections.emptyList()
        );
    }
}
