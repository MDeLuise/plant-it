package com.github.mdeluise.plantit.botanicalinfo;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfoDTO;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Botanical info", description = "Represents a plant's botanical info.")
public class BotanicalInfoDTO {
    @Schema(description = "ID of the botanical info.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Scientific name of the botanical info.", accessMode = Schema.AccessMode.READ_ONLY)
    private String scientificName;
    @Schema(description = "Synonyms of the botanical info.")
    private Set<String> synonyms = new HashSet<>();
    @Schema(description = "Family of the botanical info.")
    private String family;
    @Schema(description = "Genus of the botanical info.")
    private String genus;
    @Schema(description = "Species of the botanical info.")
    private String species;
    @Schema(description = "Care information of the botanical info.")
    private PlantCareInfoDTO plantCareInfo;
    @Schema(description = "ID of the botanical info image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String imageId;
    @Schema(description = "URL of the botanical info image.")
    private String imageUrl;
    @Schema(description = "Content of the botanical info image.", accessMode = Schema.AccessMode.WRITE_ONLY)
    private byte[] imageContent;
    @Schema(description = "Content type of the botanical info image.", accessMode = Schema.AccessMode.WRITE_ONLY)
    private String imageContentType;
    @Schema(description = "Creator of the botanical info")
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


    public Set<String> getSynonyms() {
        return synonyms;
    }


    public void setSynonyms(Set<String> synonyms) {
        this.synonyms = synonyms;
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


    public PlantCareInfoDTO getPlantCareInfo() {
        return plantCareInfo;
    }


    public void setPlantCareInfo(PlantCareInfoDTO plantCareInfo) {
        this.plantCareInfo = plantCareInfo;
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


    public byte[] getImageContent() {
        return imageContent;
    }


    public void setImageContent(byte[] imageContent) {
        this.imageContent = imageContent;
    }


    public String getImageContentType() {
        return imageContentType;
    }


    public void setImageContentType(String imageContentType) {
        this.imageContentType = imageContentType;
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
