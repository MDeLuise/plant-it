package com.github.mdeluise.plantit.diary;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.plant.Plant;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
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
@Table(name = "diaries")
public class Diary implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @OneToOne
    @JoinColumn(name = "target_id", nullable = false)
    private Plant target;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User owner;
    @OneToMany(mappedBy = "diary", cascade = CascadeType.ALL)
    private Set<DiaryEntry> entries = new HashSet<>();


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Plant getTarget() {
        return target;
    }


    public void setTarget(Plant target) {
        this.target = target;
    }


    public User getOwner() {
        return owner;
    }


    public void setOwner(User owner) {
        this.owner = owner;
    }


    public Set<DiaryEntry> getEntries() {
        return entries;
    }


    public void setEntries(Set<DiaryEntry> entries) {
        this.entries = entries;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final Diary diary = (Diary) o;
        return Objects.equals(id, diary.id) || Objects.equals(target, diary.target);
    }


    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
