package com.github.mdeluise.plantit.security.apikey;

import java.io.IOException;
import java.util.Date;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.exception.ErrorMessage;
import com.github.mdeluise.plantit.security.services.PasswordUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class ApiKeyFilter extends OncePerRequestFilter {
    private final ApiKeyService apiKeyService;
    private final PasswordUserDetailsService passwordUserDetailsService;
    private final ObjectMapper objectMapper;


    @Autowired
    public ApiKeyFilter(ApiKeyService apiKeyService, PasswordUserDetailsService passwordUserDetailsService, ObjectMapper objectMapper) {
        this.apiKeyService = apiKeyService;
        this.passwordUserDetailsService = passwordUserDetailsService;
        this.objectMapper = objectMapper;
    }


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
        throws ServletException, IOException {
        if (hasApiKey(request)) {
            final String apiKeyValue = getApiKeyValue(request);
            if (!apiKeyService.exist(apiKeyValue)) {
                sendError("Invalid API Key", response);
                return;
            }
            setAuthenticationContext(apiKeyValue, request);
        }
        filterChain.doFilter(request, response);
    }


    private void sendError(String message, HttpServletResponse response) throws IOException {
        final ErrorMessage error = new ErrorMessage(HttpStatus.UNAUTHORIZED.value(), new Date(), message, "", "");
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }


    private String getApiKeyValue(HttpServletRequest request) {
        return request.getHeader("Key");
    }


    private boolean hasApiKey(HttpServletRequest request) {
        return request.getHeader("Key") != null && !request.getHeader("Key").isBlank();
    }


    private void setAuthenticationContext(String apiKeyValue, HttpServletRequest request) {
        final UserDetails userDetails = getUserDetails(apiKeyValue);

        final UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }


    private UserDetails getUserDetails(String apiKeyValue) {
        final User user = apiKeyService.getUserFromApiKey(apiKeyValue);
        return passwordUserDetailsService.loadUserByUsername(user.getUsername());
    }
}
