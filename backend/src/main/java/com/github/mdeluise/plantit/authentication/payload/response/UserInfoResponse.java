package com.github.mdeluise.plantit.authentication.payload.response;

import java.util.Date;

import com.github.mdeluise.plantit.security.jwt.JwtTokenInfo;

public record UserInfoResponse(long id, String username, String email, Date lastLogin, JwtTokenInfo jwt) {
}
