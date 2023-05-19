package com.github.mdeluise.plantit.exception;

public class MaximumNumberOfUsersReachedExceptions extends RuntimeException {
    public MaximumNumberOfUsersReachedExceptions() {
        super("Maximum number of user reached.");
    }
}
