package com.github.mdeluise.plantit.image;

import java.util.Date;

public class ImageDTO {
    private Long id;
    private String name;
    private Date savedAt;


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


    public Date getSavedAt() {
        return savedAt;
    }


    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }
}
