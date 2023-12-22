package com.github.mdeluise.plantit.botanicalinfo.care;

import java.io.Serializable;
import java.util.Objects;
import java.util.stream.Stream;

import jakarta.persistence.Embeddable;

@Embeddable
public class PlantCareInfo implements Serializable {
    private Integer light;
    private Integer humidity;
    private Double minTemp;
    private Double maxTemp;
    private Double phMax;
    private Double phMin;


    public PlantCareInfo() {
    }


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


    public void setPhMin(Double phMi) {
        this.phMin = phMi;
    }


    public boolean isAllNull() {
        return Stream.of(light, humidity, minTemp, maxTemp, phMin, phMax).allMatch(Objects::isNull);
    }
}
