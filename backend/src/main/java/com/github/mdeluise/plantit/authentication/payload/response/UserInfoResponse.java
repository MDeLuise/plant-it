package com.github.mdeluise.plantit.authentication.payload.response;

import com.github.mdeluise.plantit.security.jwt.JwtTokenInfo;

public record UserInfoResponse(long id, String username, JwtTokenInfo jwt) {
}
