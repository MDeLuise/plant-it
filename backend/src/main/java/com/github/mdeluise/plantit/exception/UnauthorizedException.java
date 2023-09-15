package com.github.mdeluise.plantit.exception;

public class UnauthorizedException extends RuntimeException {
    public UnauthorizedException() {
        super("User not authorized to perform the action");
    }
}
