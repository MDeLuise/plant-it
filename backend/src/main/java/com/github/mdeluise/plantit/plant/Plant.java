package com.github.mdeluise.plantit.plant;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.image.ImageTarget;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.plant.info.PlantInfo;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Embedded;
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
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "plants")
public class Plant implements Serializable, ImageTarget {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Embedded
    private PlantInfo info;
    @OneToOne(mappedBy = "target", cascade = CascadeType.ALL)
    private Diary diary;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;
    @NotNull
    @ManyToOne(cascade = {CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinColumn(name = "botanical_name_id", nullable = false)
    private BotanicalInfo botanicalInfo;
    @NotNull
    @OneToMany(mappedBy = "target", cascade = CascadeType.ALL)
    private Set<PlantImage> images = new HashSet<>();
    @Enumerated(EnumType.STRING)
    private PlantAvatarMode avatarMode;
    @OneToOne(mappedBy = "avatarOf", cascade = CascadeType.ALL)
    private PlantImage avatarImage;


    public Plant() {
        this.info = new PlantInfo();
    }


    public Plant(User owner) {
        this();
        this.owner = owner;
    }


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Diary getDiary() {
        return diary;
    }


    public void setDiary(Diary diary) {
        this.diary = diary;
    }


    public User getOwner() {
        return owner;
    }


    public void setOwner(User owner) {
        this.owner = owner;
    }


    public BotanicalInfo getBotanicalInfo() {
        return botanicalInfo;
    }


    public void setBotanicalInfo(BotanicalInfo botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }


    public Set<PlantImage> getImages() {
        return images;
    }


    public void setImages(Set<PlantImage> images) {
        this.images = images;
    }


    public PlantAvatarMode getAvatarMode() {
        return avatarMode;
    }


    public void setAvatarMode(PlantAvatarMode avatarMode) {
        this.avatarMode = avatarMode;
    }


    public PlantImage getAvatarImage() {
        return avatarImage;
    }


    public void setAvatarImage(PlantImage avatarImage) {
        if (avatarImage != null) {
            this.avatarMode = PlantAvatarMode.SPECIFIED;
        }
        this.avatarImage = avatarImage;
    }


    public PlantInfo getInfo() {
        return info;
    }


    public void setInfo(PlantInfo plantInfo) {
        this.info = plantInfo;
    }


    @SuppressWarnings("BooleanExpressionComplexity") //FIXME
    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final Plant plant = (Plant) o;
        return Objects.equals(id, plant.id) && Objects.equals(info, plant.info) &&
                   Objects.equals(diary, plant.diary) && Objects.equals(owner, plant.owner) &&
                   Objects.equals(botanicalInfo, plant.botanicalInfo) && avatarMode == plant.avatarMode &&
                   Objects.equals(avatarImage, plant.avatarImage);
    }


    @Override
    public int hashCode() {
        return Objects.hash(id, info, diary, owner, botanicalInfo, avatarMode, avatarImage);
    }
}
