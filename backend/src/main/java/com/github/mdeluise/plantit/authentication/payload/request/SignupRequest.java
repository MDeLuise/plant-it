package com.github.mdeluise.plantit.authentication.payload.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Represents a request to register into the system.")
public record SignupRequest(
    @Schema(description = "Username to use to register.", example = "admin") @NotBlank @Size(min = 3, max = 20)
    String username,
    @Schema(description = "Username to use to register.", example = "admin") @NotBlank @Size(min = 6, max = 40)
    String password) {
}
