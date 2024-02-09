package com.github.mdeluise.plantit.security.jwt;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.security.services.PasswordUserDetailsService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class JwtWebUtil {
    private final JwtTokenUtil jwtTokenUtil;
    private final PasswordUserDetailsService passwordUserDetailsService;


    @Autowired
    public JwtWebUtil(JwtTokenUtil jwtTokenUtil, PasswordUserDetailsService passwordUserDetailsService) {
        this.jwtTokenUtil = jwtTokenUtil;
        this.passwordUserDetailsService = passwordUserDetailsService;
    }


    public String getJwtTokenFromRequest(HttpServletRequest request) {
        final String allHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (allHeader != null && allHeader.contains("Bearer ")) {
            return allHeader.split(" ")[1];
        }
        return null;
    }


    public JwtTokenInfo refreshToken(String token) {
        if (!jwtTokenUtil.isValid(token)) {
            throw new JWTVerificationException("Provided value is not valid");
        }
        final UserDetails user = passwordUserDetailsService.loadUserByUsername(jwtTokenUtil.getSubject(token));
        if (user == null) {
            throw new ResourceNotFoundException("username", jwtTokenUtil.getSubject(token));
        }
        return jwtTokenUtil.generateAccessToken(user);
    }


    public JwtTokenInfo generateJwt(UserDetails user) {
        return jwtTokenUtil.generateAccessToken(user);
    }
}
