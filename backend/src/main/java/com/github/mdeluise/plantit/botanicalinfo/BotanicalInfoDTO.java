package com.github.mdeluise.plantit.botanicalinfo;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Objects;

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
    @Schema(description = "Species of the botanical info.")
    private String species;
    @Schema(description = "URL of the botanical info image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String imageUrl;
    @Schema(
        description = "True if botanical info is system wide, false if it's user created",
        accessMode = Schema.AccessMode.READ_ONLY
    )
    private boolean isSystemWide;


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


    public String getSpecies() {
        return species;
    }


    public void setSpecies(String species) {
        this.species = species;
    }


    public String getImageUrl() {
        return imageUrl;
    }


    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }


    public boolean isSystemWide() {
        return isSystemWide;
    }


    public void setSystemWide(boolean systemWide) {
        isSystemWide = systemWide;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final BotanicalInfoDTO that = (BotanicalInfoDTO) o;
        return Objects.equals(id, that.id) || Objects.equals(species, that.species);
    }


    @Override
    public int hashCode() {
        return Objects.hash(id, species);
    }
}
