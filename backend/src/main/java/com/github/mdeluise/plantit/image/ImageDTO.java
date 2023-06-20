package com.github.mdeluise.plantit.image;

import java.util.Date;

public class ImageDTO {
    private Long id;
    private Date savedAt;
    private String url;
    private byte[] content;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Date getSavedAt() {
        return savedAt;
    }


    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }


    public byte[] getContent() {
        return content;
    }


    public void setContent(byte[] content) {
        this.content = content;
    }
}
