package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.image.TrackedEntityImage;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import com.github.mdeluise.plantit.tracked.state.State;
import jakarta.persistence.CascadeType;
import jakarta.persistence.DiscriminatorColumn;
import jakarta.persistence.DiscriminatorType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity(name = "tracked_entities")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(
    name = "entity_type", discriminatorType = DiscriminatorType.INTEGER, columnDefinition = "TINYINT(1)"
)
public abstract class AbstractTrackedEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private Date startDate;
    @NotNull
    @Length(max = 30)
    private String personalName;
    private Date endDate;
    @Enumerated(EnumType.STRING)
    private State state;
    @Enumerated(EnumType.STRING)
    private TrackedEntityType type;
    @OneToOne(mappedBy = "target", cascade = CascadeType.ALL)
    private Diary diary;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;
    @OneToMany(mappedBy = "abstractTrackedEntity")
    private Set<TrackedEntityImage> images = new HashSet<>();
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "thumbnail_image_id", referencedColumnName = "id")
    private TrackedEntityImage thumbnailImage;


    public AbstractTrackedEntity() {
        this.state = State.PURCHASED;
        if (this instanceof Plant) {
            this.type = TrackedEntityType.PLANT;
        } else {
            this.type = TrackedEntityType.ARRANGEMENT;
        }
    }


    public AbstractTrackedEntity(User owner) {
        this();
        this.owner = owner;
    }


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Date getStartDate() {
        return startDate;
    }


    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }


    public String getPersonalName() {
        return personalName;
    }


    public void setPersonalName(String personalName) {
        this.personalName = personalName;
    }


    public Date getEndDate() {
        return endDate;
    }


    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    public State getState() {
        return state;
    }


    public void setState(State state) {
        this.state = state;
    }


    public TrackedEntityType getType() {
        return type;
    }


    public void setType(TrackedEntityType type) {
        this.type = type;
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


    public Set<TrackedEntityImage> getImages() {
        return images;
    }


    public void setImages(Set<TrackedEntityImage> images) {
        this.images = images;
    }


    public TrackedEntityImage getThumbnailImage() {
        return thumbnailImage;
    }


    public void setThumbnailImage(TrackedEntityImage thumbnailImage) {
        this.thumbnailImage = thumbnailImage;
    }
}
