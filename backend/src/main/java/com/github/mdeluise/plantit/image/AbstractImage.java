package com.github.mdeluise.plantit.image;

import jakarta.persistence.DiscriminatorColumn;
import jakarta.persistence.DiscriminatorType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;
import java.util.Date;

@Entity(name = "abstract_images")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(
    name = "image_type", discriminatorType = DiscriminatorType.INTEGER, columnDefinition = "TINYINT(1)"
)
public abstract class AbstractImage implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Length(max = 100)
    private String description;
    @NotNull
    private Date savedAt = new Date();


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }


    public Date getSavedAt() {
        return savedAt;
    }


    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }
}
