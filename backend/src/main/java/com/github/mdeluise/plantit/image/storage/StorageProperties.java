package com.github.mdeluise.plantit.image.storage;

import org.springframework.stereotype.Component;

@Component
public class StorageProperties {
    private String location = "upload-dir";


    public String getLocation() {
        return location;
    }


    public void setLocation(String location) {
        this.location = location;
    }
}
