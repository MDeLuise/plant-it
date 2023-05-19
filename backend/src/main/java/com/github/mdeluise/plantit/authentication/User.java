package com.github.mdeluise.plantit.authentication;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.mdeluise.plantit.authorization.permission.Permission;
import com.github.mdeluise.plantit.authorization.role.Role;
import com.github.mdeluise.plantit.common.IdentifiedEntity;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.security.apikey.ApiKey;
import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Entity(name = "user")
@Table(name = "application_users")
public class User implements IdentifiedEntity<Long> {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(unique = true)
    @NotEmpty
    @Size(min = 3, max = 20)
    private String username;
    @NotEmpty
    @Size(min = 8, max = 120)
    @JsonProperty
    private String password;
    @ManyToMany(
        cascade = {
            CascadeType.PERSIST, CascadeType.MERGE
        }
    )
    @JoinTable(
        name = "user_roles", joinColumns = @JoinColumn(name = "user_id", referencedColumnName = "id"),
        inverseJoinColumns = @JoinColumn(name = "role_id", referencedColumnName = "id")
    )
    private Set<Role> roles = new HashSet<>();
    @ManyToMany(
        cascade = {
            CascadeType.PERSIST, CascadeType.MERGE
        }
    )
    @JoinTable(
        name = "user_permissions", joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "permission_id")
    )
    private Set<Permission> permissions = new HashSet<>();
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<ApiKey> apiKeys = new HashSet<>();
    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL)
    private Set<Diary> diaries = new HashSet<>();
    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL)
    private Set<AbstractTrackedEntity> entities = new HashSet<>();


    public User(Long id, String username, String password, Set<Role> roles, Set<Permission> permissions) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.roles = roles;
        this.permissions = permissions;
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


    @Override
    public Long getId() {
        return id;
    }


    @Override
    public void setId(Long id) {
        this.id = id;
    }


    public Set<Role> getRoles() {
        return roles;
    }


    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }


    public Set<Permission> getPermissions() {
        return permissions;
    }


    public void setPermissions(Set<Permission> permissions) {
        this.permissions = permissions;
    }


    public void addPermission(Permission permission) {
        permissions.add(permission);
    }


    public void removePermission(Permission permission) {
        permissions.remove(permission);
    }


    public void addRole(Role role) {
        roles.add(role);
    }


    public void removeRole(Role role) {
        roles.remove(role);
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


    public Set<AbstractTrackedEntity> getEntities() {
        return entities;
    }


    public void setEntities(Set<AbstractTrackedEntity> entities) {
        this.entities = entities;
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
