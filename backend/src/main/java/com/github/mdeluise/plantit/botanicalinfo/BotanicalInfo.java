package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.image.BotanicalNameImage;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

// http://theseedsite.co.uk/class.html
// https://www.edendeifiori.it/8615/che-differenza-ce-tra-genere-specie-sottospecie-varieta-e-cultivar.php
@Entity
@Table(name = "botanical_infos")
public class BotanicalInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    @Column(unique = true)
    private String scientificName;
    @NotNull
    private String family; // http://www.theplantlist.org/browse/-/
    @NotNull
    private String genus;
    @NotNull
    @OneToMany(mappedBy = "botanicalInfo")
    private Set<Plant> plants = new HashSet<>();
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "image_id", referencedColumnName = "id")
    private BotanicalNameImage image;


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


    public Set<Plant> getPlants() {
        return plants;
    }


    public void setPlants(Set<Plant> plants) {
        this.plants = plants;
    }


    public BotanicalNameImage getImage() {
        return image;
    }


    public void setImage(BotanicalNameImage image) {
        this.image = image;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final BotanicalInfo that = (BotanicalInfo) o;
        return Objects.equals(family, that.family) && Objects.equals(genus, that.genus);
    }


    @Override
    public int hashCode() {
        return Objects.hash(family, genus);
    }
}
