package com.github.mdeluise.plantit.authentication;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.security.apikey.ApiKey;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import org.hibernate.validator.constraints.Length;

@Entity(name = "user")
@Table(name = "application_users")
public class User implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(unique = true)
    @NotEmpty
    @Length(min = 3, max = 20)
    private String username;
    @NotEmpty
    @Length(min = 8, max = 120)
    @JsonProperty
    private String password;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<ApiKey> apiKeys = new HashSet<>();
    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL)
    private Set<Diary> diaries = new HashSet<>();
    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL)
    private Set<Plant> plants = new HashSet<>();
    @OneToMany(mappedBy = "creator", cascade = CascadeType.ALL)
    private Set<BotanicalInfo> botanicalInfos = new HashSet<>();


    public User(Long id, String username, String password) {
        this.id = id;
        this.username = username;
        this.password = password;
    }


    public User() {
    }


    @JsonIgnore
    public String getPassword() {
        return password;
    }


    public void setPassword(String password) {
        this.password = password;
    }


    public String getUsername() {
        return username;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Set<ApiKey> getApiKeys() {
        return apiKeys;
    }


    public void setApiKeys(Set<ApiKey> apiKeys) {
        this.apiKeys = apiKeys;
    }


    public void addApiKey(ApiKey apiKey) {
        apiKeys.add(apiKey);
    }


    public void removeApiKey(ApiKey apiKey) {
        apiKeys.remove(apiKey);
    }


    public Set<Diary> getLogs() {
        return diaries;
    }


    public void setLogs(Set<Diary> logs) {
        this.diaries = logs;
    }


    public Set<Plant> getPlants() {
        return plants;
    }


    public void setPlants(Set<Plant> plants) {
        this.plants = plants;
    }


    public Set<BotanicalInfo> getBotanicalInfos() {
        return botanicalInfos;
    }


    public void setBotanicalInfos(Set<BotanicalInfo> botanicalInfos) {
        this.botanicalInfos = botanicalInfos;
    }


    public Set<Diary> getDiaries() {
        return diaries;
    }


    public void setDiaries(Set<Diary> diaries) {
        this.diaries = diaries;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        User user = (User) o;
        return Objects.equals(id, user.id);
    }


    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
