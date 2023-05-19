package com.github.mdeluise.plantit.tracked.arrangement;

import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;

import java.util.Set;

@Entity
@DiscriminatorValue("2")
public class Arrangement extends AbstractTrackedEntity {
    @OneToMany(mappedBy = "arrangement")
    private Set<Plant> components;


    public Set<Plant> getComponents() {
        return components;
    }


    public void setComponents(Set<Plant> components) {
        this.components = components;
    }
}
