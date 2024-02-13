package com.github.mdeluise.plantit.security.services;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class PasswordUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;


    @Autowired
    public PasswordUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        final User user = userRepository.findByUsername(username)
                                        .orElseThrow(() -> new UsernameNotFoundException(
                                            "User not found with username: " + username));
        return UserDetailsImpl.build(user);
    }
}
