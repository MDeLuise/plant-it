package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

@Entity
@DiscriminatorValue("2")
public class TrackedEntityImage extends AbstractImage {
    @NotNull
    @ManyToOne
    @JoinColumn(name = "entity_id", nullable = false)
    private AbstractTrackedEntity abstractTrackedEntity;
    @OneToOne(mappedBy = "thumbnailImage")
    private AbstractTrackedEntity thumbnailOf;
    @Length(max = 100)
    private String description;


    public AbstractTrackedEntity getAbstractTrackedEntity() {
        return abstractTrackedEntity;
    }


    public void setAbstractTrackedEntity(AbstractTrackedEntity abstractTrackedEntity) {
        this.abstractTrackedEntity = abstractTrackedEntity;
    }


    public AbstractTrackedEntity getThumbnailOf() {
        return thumbnailOf;
    }


    public void setThumbnailOf(AbstractTrackedEntity thumbnailOf) {
        this.thumbnailOf = thumbnailOf;
    }


    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }
}
