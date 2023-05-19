package com.github.mdeluise.plantit.exception;

public class FetchingModeException extends RuntimeException {
    public FetchingModeException() {
        super("The used fetching mode does not provide this function");
    }
}
