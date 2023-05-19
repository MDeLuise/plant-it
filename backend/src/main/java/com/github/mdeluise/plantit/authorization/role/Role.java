package com.github.mdeluise.plantit.authorization.role;

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
import java.util.Set;

@Entity(name = "role")
@Table(name = "application_roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private com.github.mdeluise.plantit.authorization.role.ERole name;

    @ManyToMany(mappedBy = "roles")
    private Set<User> users = new HashSet<>();


    public Role() {
    }


    public Role(com.github.mdeluise.plantit.authorization.role.ERole name) {
        this.name = name;
    }


    public long getId() {
        return id;
    }


    public void setId(long id) {
        this.id = id;
    }


    public com.github.mdeluise.plantit.authorization.role.ERole getName() {
        return name;
    }


    public void setName(com.github.mdeluise.plantit.authorization.role.ERole name) {
        this.name = name;
    }


    public Set<User> getUsers() {
        return users;
    }


    public void setUsers(Set<User> users) {
        this.users = users;
    }


    @Override
    public String toString() {
        return name.toString();
    }
}
