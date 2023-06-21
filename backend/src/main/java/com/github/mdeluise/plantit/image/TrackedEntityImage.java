package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@DiscriminatorValue("3")
public class TrackedEntityImage extends AbstractImage {
    @NotNull
    @ManyToOne
    @JoinColumn(name = "entity_id", nullable = false)
    private AbstractTrackedEntity abstractTrackedEntity;
    @OneToOne(mappedBy = "thumbnailImage")
    private AbstractTrackedEntity thumbnailOf;
    @Size(max = 100000)
    @Lob
    private byte[] content;


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


    public byte[] getContent() {
        return content;
    }


    public void setContent(byte[] content) {
        this.content = content;
    }
}
