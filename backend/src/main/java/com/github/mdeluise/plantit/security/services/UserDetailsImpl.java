package com.github.mdeluise.plantit.security.services;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.mdeluise.plantit.authentication.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.util.Collection;
import java.util.Collections;
import java.util.Objects;

public class UserDetailsImpl implements UserDetails {
    @Serial
    private static final long serialVersionUID = 1L;

    private final long id;

    private final String username;

    @JsonProperty
    private final String password;

    private final Collection<? extends GrantedAuthority> authorities;


    public UserDetailsImpl(long id, String username, String password,
                           Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.authorities = authorities;
    }


    public static UserDetailsImpl build(User user) {
        return new UserDetailsImpl(user.getId(), user.getUsername(), user.getPassword(), Collections.emptyList());
    }


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }


    public long getId() {
        return id;
    }


    @Override
    @JsonIgnore
    public String getPassword() {
        return password;
    }


    @Override
    public String getUsername() {
        return username;
    }


    @Override
    public boolean isAccountNonExpired() {
        return true;
    }


    @Override
    public boolean isAccountNonLocked() {
        return true;
    }


    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }


    @Override
    public boolean isEnabled() {
        return true;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        UserDetailsImpl that = (UserDetailsImpl) o;
        return username.equals(that.username) && password.equals(that.password) && authorities.equals(that.authorities);
    }


    @Override
    public int hashCode() {
        return Objects.hash(username, password, authorities);
    }
}
