package com.github.mdeluise.plantit.botanicalinfo;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Botanical info", description = "Represents a plant's botanical name.")
public class BotanicalInfoDTO {
    @Schema(description = "ID of the botanical info.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Scientific name of the botanical info.")
    private String scientificName;
    @Schema(description = "Family of the botanical info.")
    private String family;
    @Schema(description = "Genus of the botanical info.")
    private String genus;
    @Schema(description = "URL of the botanical info image.")
    private String imageUrl;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public String getScientificName() {
        return scientificName;
    }


    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }


    public String getFamily() {
        return family;
    }


    public void setFamily(String family) {
        this.family = family;
    }


    public String getGenus() {
        return genus;
    }


    public void setGenus(String genus) {
        this.genus = genus;
    }


    public String getImageUrl() {
        return imageUrl;
    }


    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
