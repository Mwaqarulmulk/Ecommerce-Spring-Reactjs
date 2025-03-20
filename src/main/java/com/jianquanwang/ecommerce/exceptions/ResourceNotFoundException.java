package com.jianquanwang.ecommerce.exceptions;

public class ResourceNotFoundException extends RuntimeException{
    String resourceName;
    String field;
    String fieldName;
    Long fieldId;

    public ResourceNotFoundException(String resourceName, String field, String fieldName, Long fieldId) {
        super(String.format("%s not found with %s: %s", resourceName, field, fieldName));
        this.resourceName = resourceName;
        this.field = field;
        this.fieldName = fieldName;
        this.fieldId = fieldId;
    }

    public ResourceNotFoundException(String resourceName, String field, Long fieldId) {
        super(String.format("%s not found with %s: %d", resourceName, field, fieldId));
        this.resourceName = resourceName;
        this.field = field;
        this.fieldId = fieldId;
    }

    public ResourceNotFoundException(String message, Throwable cause, String resourceName, String field, String fieldName, Long fieldId) {
        super(message, cause);
        this.resourceName = resourceName;
        this.field = field;
        this.fieldName = fieldName;
        this.fieldId = fieldId;
    }

    public ResourceNotFoundException(Throwable cause, String resourceName, String field, String fieldName, Long fieldId) {
        super(cause);
        this.resourceName = resourceName;
        this.field = field;
        this.fieldName = fieldName;
        this.fieldId = fieldId;
    }

    public ResourceNotFoundException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace, String resourceName, String field, String fieldName, Long fieldId) {
        super(message, cause, enableSuppression, writableStackTrace);
        this.resourceName = resourceName;
        this.field = field;
        this.fieldName = fieldName;
        this.fieldId = fieldId;
    }
}
