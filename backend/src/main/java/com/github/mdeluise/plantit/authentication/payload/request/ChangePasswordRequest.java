package com.github.mdeluise.plantit.authentication.payload.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Represents a request to change the user password.")
public record ChangePasswordRequest(
    @Schema(description = "Current password.", example = "password1") @NotBlank String currentPassword,
    @Schema(description = "New password.", example = "password2") @NotBlank String newPassword) {
}
