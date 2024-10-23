package com.github.mdeluise.plantit.common;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class AuthenticatedUserService {
    private final UserService userService;


    @Autowired
    public AuthenticatedUserService(UserService userService) {
        this.userService = userService;
    }


    public User getAuthenticatedUser() {
        final SecurityContext context = SecurityContextHolder.getContext();
        final Authentication authentication = context.getAuthentication();
        final String username = authentication.getName();
        return userService.get(username);
    }
}
