package com.github.mdeluise.plantit.stats;

public class UserStats {
    private long diaryEntryCount;
    private long plantCount;
    private long botanicalInfoCount;
    private long imageCount;


    public long getDiaryEntryCount() {
        return diaryEntryCount;
    }


    public void setDiaryEntryCount(long diaryEntryCount) {
        this.diaryEntryCount = diaryEntryCount;
    }


    public long getPlantCount() {
        return plantCount;
    }


    public void setPlantCount(long plantCount) {
        this.plantCount = plantCount;
    }


    public long getBotanicalInfoCount() {
        return botanicalInfoCount;
    }


    public void setBotanicalInfoCount(long botanicalInfoCount) {
        this.botanicalInfoCount = botanicalInfoCount;
    }


    public long getImageCount() {
        return imageCount;
    }


    public void setImageCount(long imageCount) {
        this.imageCount = imageCount;
    }
}
