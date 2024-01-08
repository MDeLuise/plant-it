package com.github.mdeluise.plantit.botanicalinfo.care;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Plant care info", description = "Represents a plant's care info.")
public class PlantCareInfoDTO {
    @Schema(description = "Light requirement")
    private Integer light;
    @Schema(description = "Humidity requirement")
    private Integer humidity;
    @Schema(description = "Minimum temperature requirement")
    private Double minTemp;
    @Schema(description = "Maximum temperature requirement")
    private Double maxTemp;
    @Schema(description = "Maximum PH requirement")
    private Double phMax;
    @Schema(description = "Minimum PH requirement")
    private Double phMin;
    @Schema(description = "Are all fields null?", accessMode = Schema.AccessMode.READ_ONLY)
    private boolean allNull;


    public Integer getLight() {
        return light;
    }


    public void setLight(Integer light) {
        this.light = light;
    }


    public Integer getHumidity() {
        return humidity;
    }


    public void setHumidity(Integer humidity) {
        this.humidity = humidity;
    }


    public Double getMinTemp() {
        return minTemp;
    }


    public void setMinTemp(Double minTemp) {
        this.minTemp = minTemp;
    }


    public Double getMaxTemp() {
        return maxTemp;
    }


    public void setMaxTemp(Double maxTemp) {
        this.maxTemp = maxTemp;
    }


    public Double getPhMax() {
        return phMax;
    }


    public void setPhMax(Double phMax) {
        this.phMax = phMax;
    }


    public Double getPhMin() {
        return phMin;
    }


    public void setPhMin(Double phMin) {
        this.phMin = phMin;
    }


    public boolean isAllNull() {
        return allNull;
    }


    public void setAllNull(boolean allNull) {
        this.allNull = allNull;
    }
}
