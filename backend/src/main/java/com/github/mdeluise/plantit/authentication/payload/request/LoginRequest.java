package com.github.mdeluise.plantit.authentication.payload.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Represents a request to login into the system.")
public record LoginRequest(
    @Schema(description = "Username to use to login.", example = "user") @NotBlank String username,
    @Schema(description = "Password to use to login.", example = "user") @NotBlank String password) {
}
