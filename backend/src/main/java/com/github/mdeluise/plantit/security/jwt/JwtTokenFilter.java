package com.github.mdeluise.plantit.security.jwt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.exception.ErrorMessage;
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

import java.io.IOException;
import java.util.Date;

@Component
public class JwtTokenFilter extends OncePerRequestFilter {
    private final JwtTokenUtil jwtTokenUtil;
    private final JwtWebUtil jwtWebUtil;
    private final ObjectMapper objectMapper;
    private final UserDetailsService userDetailsService;


    @Autowired
    public JwtTokenFilter(JwtTokenUtil jwtTokenUtil, JwtWebUtil jwtWebUtil, ObjectMapper objectMapper,
                          UserDetailsService userDetailsService) {
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
            String token = jwtWebUtil.getJwtTokenFromRequest(request);
            if (!jwtTokenUtil.isValid(token)) {
                sendError("Invalid value", response);
                return;
            }
            setAuthenticationContext(token, request);
        }
        filterChain.doFilter(request, response);
    }


    private void sendError(String message, HttpServletResponse response) throws IOException {
        ErrorMessage error = new ErrorMessage(
                HttpStatus.FORBIDDEN.value(),
                new Date(),
                message,
                "",
                ""
        );
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }


    private boolean hasAccessToken(HttpServletRequest request) {
        return jwtWebUtil.getJwtTokenFromRequest(request) != null;
    }


    private void setAuthenticationContext(String token, HttpServletRequest request) {
        UserDetails userDetails = getUserDetails(token);

        UsernamePasswordAuthenticationToken
                authentication =
                new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());

        authentication.setDetails(
                new WebAuthenticationDetailsSource().buildDetails(request));

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }


    private UserDetails getUserDetails(String token) {
        return userDetailsService.loadUserByUsername(jwtTokenUtil.getSubject(token));
    }
}
