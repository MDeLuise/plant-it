package com.github.mdeluise.plantit.security.jwt;

import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.exception.error.ErrorCode;
import com.github.mdeluise.plantit.exception.error.ErrorMessage;
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
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtTokenFilter extends OncePerRequestFilter {
    private final JwtTokenUtil jwtTokenUtil;
    private final JwtWebUtil jwtWebUtil;
    private final ObjectMapper objectMapper;
    private final UserDetailsService userDetailsService;


    @Autowired
    public JwtTokenFilter(JwtTokenUtil jwtTokenUtil, JwtWebUtil jwtWebUtil, ObjectMapper objectMapper,
                          PasswordUserDetailsService userDetailsService) {
        this.jwtTokenUtil = jwtTokenUtil;
        this.jwtWebUtil = jwtWebUtil;
        this.objectMapper = objectMapper;
        this.userDetailsService = userDetailsService;
    }


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        if (hasAccessToken(request)) {
            final String token = jwtWebUtil.getJwtTokenFromRequest(request);
            if (!jwtTokenUtil.isValid(token)) {
                sendError("Invalid value", response);
                return;
            }
            setAuthenticationContext(token, request);
        }
        filterChain.doFilter(request, response);
    }


    private void sendError(String message, HttpServletResponse response) throws IOException {
        final ErrorMessage error = new ErrorMessage(
            HttpStatus.FORBIDDEN.value(),
            ErrorCode.AUTHENTICATION_ERROR,
            message
        );
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }


    private boolean hasAccessToken(HttpServletRequest request) {
        return jwtWebUtil.getJwtTokenFromRequest(request) != null;
    }


    private void setAuthenticationContext(String token, HttpServletRequest request) {
        final UserDetails userDetails = getUserDetails(token);

        final UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }


    private UserDetails getUserDetails(String token) {
        return userDetailsService.loadUserByUsername(jwtTokenUtil.getSubject(token));
    }
}
