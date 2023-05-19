package com.github.mdeluise.plantit.authorization.permission;

import com.github.mdeluise.plantit.authentication.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "permissions")
public class Permission {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private com.github.mdeluise.plantit.authorization.permission.PType type;

    private String resourceClassName;

    private String resourceId;

    @ManyToMany(mappedBy = "permissions")
    private Set<User> users = new HashSet<>();



    public Permission() {
    }


    public Permission(com.github.mdeluise.plantit.authorization.permission.PType type, String resourceClassName, String resourceId) {
        this.type = type;
        this.resourceClassName = resourceClassName;
        this.resourceId = resourceId;
    }


    public long getId() {
        return id;
    }


    public void setId(long id) {
        this.id = id;
    }


    public com.github.mdeluise.plantit.authorization.permission.PType getType() {
        return type;
    }


    public void setType(com.github.mdeluise.plantit.authorization.permission.PType type) {
        this.type = type;
    }


    public String getResourceClass() {
        return resourceClassName;
    }


    public void setResourceClass(String resourceClassName) {
        this.resourceClassName = resourceClassName;
    }


    public String getResourceId() {
        return resourceId;
    }


    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }


    public String getResourceClassName() {
        return resourceClassName;
    }


    public void setResourceClassName(String resourceClassName) {
        this.resourceClassName = resourceClassName;
    }


    public Set<User> getUsers() {
        return users;
    }


    public void setUsers(Set<User> users) {
        this.users = users;
    }


    @Override
    public String toString() {
        return String.format(
            "%s:%s:%s", type.toString().toLowerCase(), resourceClassName, resourceId);
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o instanceof Permission p) {
            return this.resourceId.equals(p.resourceId) &&
                       this.resourceClassName.equals(p.resourceClassName) &&
                       this.type.equals(p.type);
        } else if (o instanceof String s) {
            return toString().equals(s);
        }
        return false;
    }


    @Override
    public int hashCode() {
        return Objects.hash(type, resourceClassName, resourceId);
    }
}
