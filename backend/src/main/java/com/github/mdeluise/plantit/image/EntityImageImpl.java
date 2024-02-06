package com.github.mdeluise.plantit.image;

import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

import jakarta.persistence.DiscriminatorColumn;
import jakarta.persistence.DiscriminatorType;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

@Entity(name = "entity_images")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(
    name = "image_type", discriminatorType = DiscriminatorType.INTEGER, columnDefinition = "TINYINT(1)"
)
public class EntityImageImpl implements EntityImage, Serializable {
    @Id
    @NotNull
    private String id;
    @Length(max = 100)
    private String description;
    @NotNull
    private Date createOn;
    @NotBlank
    @Length(max = 255)
    private String url;
    private String path;


    public EntityImageImpl() {
        final String uuid = UUID.randomUUID().toString();
        this.id = uuid;
        this.url = "/" + uuid;
    }


    @Override
    public String getId() {
        return id;
    }


    @Override
    public void setId(String id) {
        this.id = id;
    }


    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }


    @Override
    public String getPath() {
        return path;
    }


    @Override
    public void setPath(String path) {
        this.path = path;
    }


    @Override
    public String getUrl() {
        return url;
    }


    @Override
    public void setUrl(String url) {
        this.url = url;
    }


    @Override
    public void setCreateOn(Date createOn) {
        this.createOn = createOn;
    }


    @Override
    public Date getCreateOn() {
        return createOn;
    }
}
