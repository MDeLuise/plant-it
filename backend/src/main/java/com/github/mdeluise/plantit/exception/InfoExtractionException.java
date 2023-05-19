package com.github.mdeluise.plantit.exception;

public class InfoExtractionException extends RuntimeException {
    public InfoExtractionException(Exception e) {
        super("Error while extracting information: " + e.getMessage());
    }


    public InfoExtractionException(String message) {
        super("Error while extracting information: " + message);
    }
}
