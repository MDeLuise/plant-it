package com.github.mdeluise.plantit.exception;

public class DuplicatedSpeciesException extends RuntimeException {
    public DuplicatedSpeciesException(String species) {
        super(String.format("Species \"%s\" already exists in another botanical info", species));
    }
}
