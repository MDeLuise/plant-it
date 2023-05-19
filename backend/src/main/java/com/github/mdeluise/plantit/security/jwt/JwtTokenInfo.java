package com.github.mdeluise.plantit.security.jwt;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

public record JwtTokenInfo(
        String value,
        @JsonFormat(
                shape = JsonFormat.Shape.STRING,
                pattern = "dd-MM-yyyy hh:mm:ss"
        )
        Date expiresOn
) {
}
