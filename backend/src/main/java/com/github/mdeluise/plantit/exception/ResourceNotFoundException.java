package com.github.mdeluise.plantit.exception;

public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException(Class clazz, String field, String fieldValue) {
        super(String.format("Resource of type %s with %s %s not found", clazz.getSimpleName(), field, fieldValue));
    }


    public ResourceNotFoundException(Object id) {
        this("id", String.valueOf(id));
    }


    public ResourceNotFoundException(Class clazz, Object id) {
        this(clazz, "id", String.valueOf(id));
    }


    public ResourceNotFoundException(String field, String fieldValue) {
        this(Object.class, field, fieldValue);
    }


    @Override
    public String getMessage() {
        return super.getMessage();
    }
}
