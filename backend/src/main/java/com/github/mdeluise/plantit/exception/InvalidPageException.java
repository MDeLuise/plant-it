package com.github.mdeluise.plantit.exception;

public class InvalidPageException extends RuntimeException {
    public InvalidPageException(String errorMessage) {
        super(String.format("Invalid page provided: %s", errorMessage));
    }
}
