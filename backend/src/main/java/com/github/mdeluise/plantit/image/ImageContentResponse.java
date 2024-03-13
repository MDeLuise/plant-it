package com.github.mdeluise.plantit.image;


import org.springframework.http.MediaType;

public record ImageContentResponse(byte[] content, MediaType type) {
}
