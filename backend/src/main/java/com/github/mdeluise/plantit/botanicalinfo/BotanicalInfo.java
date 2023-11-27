package com.github.mdeluise.plantit.botanicalinfo;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.ImageTarget;
import com.github.mdeluise.plantit.plant.Plant;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "botanical_infos")
public class BotanicalInfo implements Serializable, ImageTarget {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    // https://landscapeplants.oregonstate.edu/scientific-plant-names-binomial-nomenclature
    @NotBlank
    private String scientificName;
    private String family;
    private String genus;
    private String species;
    @NotNull
    @OneToMany(mappedBy = "botanicalInfo")
    private Set<Plant> plants = new HashSet<>();
    @OneToOne(mappedBy = "target", cascade = CascadeType.ALL)
    private BotanicalInfoImage image;
    @NotNull
    @Enumerated(EnumType.STRING)
    private BotanicalInfoCreator creator;
    @ManyToOne
    @JoinColumn(name = "user_creator_id")
    private User userCreator;
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
        this.scientificName = species;
    }


    public Set<Plant> getPlants() {
        return plants;
    }


    public void setPlants(Set<Plant> plants) {
        this.plants = plants;
    }


    public BotanicalInfoImage getImage() {
        return image;
    }


    public void setImage(BotanicalInfoImage image) {
        this.image = image;
    }


    public BotanicalInfoCreator getCreator() {
        return creator;
    }


    public void setCreator(BotanicalInfoCreator creator) {
        this.creator = creator;
    }


    public User getUserCreator() {
        return userCreator;
    }


    public void setUserCreator(User userCreator) {
        this.userCreator = userCreator;
        if (userCreator != null) {
            this.creator = BotanicalInfoCreator.USER;
            this.externalId = null;
        }
    }


    public String getExternalId() {
        return externalId;
    }


    public void setExternalId(String externalId) {
        this.externalId = externalId;
    }


    public boolean isAccessibleToUser(User user) {
        return creator != BotanicalInfoCreator.USER || userCreator.equals(user);
    }


    public boolean isUserCreated() {
        return creator == BotanicalInfoCreator.USER;
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
        return fieldEquals(that);
    }


    @Override
    public int hashCode() {
        return Objects.hash(scientificName, family, genus, species);
    }


    @SuppressWarnings("BooleanExpressionComplexity") //FIXME
    private boolean fieldEquals(BotanicalInfo that) {
        return Objects.equals(scientificName, that.scientificName) && Objects.equals(family, that.family) &&
                   Objects.equals(genus, that.genus) && Objects.equals(species, that.species) &&
                   Objects.equals(externalId, that.externalId);
    }
}
