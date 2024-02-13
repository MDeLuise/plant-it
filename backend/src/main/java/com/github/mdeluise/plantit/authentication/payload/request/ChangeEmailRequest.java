package com.github.mdeluise.plantit.authentication.payload.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Represents a request to change the user password.")
public record ChangeEmailRequest(
    @Schema(description = "Password.", example = "password1") @NotBlank String password,
    @Schema(description = "New email.", example = "foo@bar.com") @NotBlank String newEmail) {
}
