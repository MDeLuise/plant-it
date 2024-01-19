package com.github.mdeluise.plantit.systeminfo;

import java.io.Serializable;

public class GitHubReleaseInfo implements Serializable {
    private String tagName;
    private String body;


    public String getTagName() {
        return tagName;
    }


    public void setTagName(String tagName) {
        this.tagName = tagName;
    }


    public String getBody() {
        return body;
    }


    public void setBody(String body) {
        this.body = body;
    }
}
