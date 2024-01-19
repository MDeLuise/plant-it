package com.github.mdeluise.plantit.systeminfo;

import java.io.Serializable;

public class SystemVersionInfo implements Serializable {
    private String currentVersion;
    private String latestVersion;
    private String latestReleaseNote;
    private boolean isLatest;


    public String getCurrentVersion() {
        return currentVersion;
    }


    public void setCurrentVersion(String currentVersion) {
        this.currentVersion = currentVersion;
    }


    public String getLatestVersion() {
        return latestVersion;
    }


    public void setLatestVersion(String latestVersion) {
        this.latestVersion = latestVersion;
    }


    public boolean isLatest() {
        return isLatest;
    }


    public void setLatest(boolean latest) {
        isLatest = latest;
    }


    public String getLatestReleaseNote() {
        return latestReleaseNote;
    }


    public void setLatestReleaseNote(String latestReleaseNote) {
        this.latestReleaseNote = latestReleaseNote;
    }
}
