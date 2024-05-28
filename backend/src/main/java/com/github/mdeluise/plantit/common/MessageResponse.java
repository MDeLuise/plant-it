package com.github.mdeluise.plantit.common;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "API Response", description = "Represents a response from an API")
public class MessageResponse {
    @Schema(description = "Message of the response", accessMode = Schema.AccessMode.READ_ONLY)
    private String message;


    public MessageResponse(String message) {
        this.message = message;
    }


    public String getMessage() {
        return message;
    }


    public void setMessage(String message) {
        this.message = message;
    }
}
