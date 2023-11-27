package com.github.mdeluise.plantit.image;

import jakarta.validation.constraints.NotBlank;

public record SaveImageUrlRequest(@NotBlank String url) {
}
