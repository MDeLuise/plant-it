package com.github.mdeluise.plantit.botanicalinfo;

import java.util.Objects;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Botanical info", description = "Represents a plant's botanical info.")
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
    @Schema(description = "ID of the botanical info image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String imageId;
    @Schema(description = "URL of the botanical info image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String imageUrl;
    @Schema(description = "Creator of the botanical info", accessMode = Schema.AccessMode.READ_ONLY)
    private String creator;
    @Schema(description = "ID of the botanical info in the creator service")
    private String externalId;


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


    public String getImageId() {
        return imageId;
    }


    public void setImageId(String imageId) {
        this.imageId = imageId;
    }


    public void setCreator(String creator) {
        this.creator = creator;
    }


    public String getCreator() {
        return creator;
    }


    public String getExternalId() {
        return externalId;
    }


    public void setExternalId(String externalId) {
        this.externalId = externalId;
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
