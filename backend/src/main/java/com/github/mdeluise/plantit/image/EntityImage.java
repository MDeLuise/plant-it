package com.github.mdeluise.plantit.image;

import java.util.Date;

public interface EntityImage {
    String getId();

    void setId(String id);

    void setPath(String path);

    String getPath();

    void setUrl(String url);

    String getUrl();

    void setContentType(String type);

    String getContentType();

    void setCreateOn(Date createOn);

    Date getCreateOn();
}
