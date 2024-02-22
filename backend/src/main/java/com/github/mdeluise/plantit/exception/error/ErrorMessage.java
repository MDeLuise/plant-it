package com.github.mdeluise.plantit.exception.error;

public record ErrorMessage(int statusCode, ErrorCode errorCode, String message) {
}
