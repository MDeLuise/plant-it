package com.github.mdeluise.plantit.image;


import java.io.Serializable;

import org.springframework.http.MediaType;

public class ImageContentResponse implements Serializable {
    private byte[] content;
    private MediaType type;


    public ImageContentResponse(byte[] content, MediaType type) {
        this.content = content;
        this.type = type;
    }


    public byte[] getContent() {
        return content;
    }


    public void setContent(byte[] content) {
        this.content = content;
    }


    public MediaType getType() {
        return type;
    }


    public void setType(MediaType type) {
        this.type = type;
    }
}