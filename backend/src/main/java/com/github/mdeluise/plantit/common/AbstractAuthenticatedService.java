package com.github.mdeluise.plantit.common;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

public abstract class AbstractAuthenticatedService {
    private final UserService userService;


    protected AbstractAuthenticatedService(UserService userService) {
        this.userService = userService;
    }


    protected User getAuthenticatedUser() {
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();
        String username = authentication.getName();
        return userService.get(username);
    }
}
