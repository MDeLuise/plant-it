package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.plant.Plant;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
@DiscriminatorValue("2")
public class PlantImage extends EntityImageImpl {
    @ManyToOne
    @JoinColumn(name = "plant_entity_id")
    private Plant target;


    public PlantImage() {
        super();
    }


    public Plant getTarget() {
        return target;
    }


    public void setTarget(Plant target) {
        this.target = target;
    }
}
