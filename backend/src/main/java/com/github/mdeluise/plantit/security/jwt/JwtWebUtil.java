package com.github.mdeluise.plantit.security.jwt;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

@Component
public class JwtWebUtil {
    private final JwtTokenUtil jwtTokenUtil;
    private final UserDetailsService userDetailsService;


    @Autowired
    public JwtWebUtil(com.github.mdeluise.plantit.security.jwt.JwtTokenUtil jwtTokenUtil, UserDetailsService userDetailsService) {
        this.jwtTokenUtil = jwtTokenUtil;
        this.userDetailsService = userDetailsService;
    }


    public String getJwtTokenFromRequest(HttpServletRequest request) {
        String allHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (allHeader != null && allHeader.contains("Bearer ")) {
            return allHeader.split(" ")[1];
        }
        return null;
    }


    public com.github.mdeluise.plantit.security.jwt.JwtTokenInfo refreshToken(String token) {
        if (!jwtTokenUtil.isValid(token)) {
            throw new JWTVerificationException("Provided value is not valid");
        }
        UserDetails user = userDetailsService.loadUserByUsername(jwtTokenUtil.getSubject(token));
        if (user == null) {
            throw new ResourceNotFoundException("username", jwtTokenUtil.getSubject(token));
        }
        return jwtTokenUtil.generateAccessToken(user);
    }


    public com.github.mdeluise.plantit.security.jwt.JwtTokenInfo generateJwt(UserDetails user) {
        return jwtTokenUtil.generateAccessToken(user);
    }
}
