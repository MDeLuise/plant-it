package com.github.mdeluise.plantit.security.apikey;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Date;

public class ApiKeyDTO {
    @Schema(description = "ID of the API Key.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;

    @Schema(description = "Name of the API Key.")
    private String name;

    @Schema(description = "Value of the API Key.")
    private String value;

    @Schema(description = "Date of creation of the API Key.")
    private Date createdOn;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public String getName() {
        return name;
    }


    public void setName(String name) {
        this.name = name;
    }


    public String getValue() {
        return value;
    }


    public void setValue(String value) {
        this.value = value;
    }


    public Date getCreatedOn() {
        return createdOn;
    }


    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }
}
