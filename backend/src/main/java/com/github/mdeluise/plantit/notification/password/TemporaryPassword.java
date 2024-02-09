package com.github.mdeluise.plantit.notification.password;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

@Entity
@Table(name = "temporary_passwords")
public class TemporaryPassword {
    @Id
    @Length(min = 3, max = 20)
    private String username;
    @NotEmpty
    @Length(min = 8, max = 120)
    private String password;
    @Transient
    private String plainPassword;
    @NotNull
    private Date expiration;


    public String getPassword() {
        return password;
    }


    public void setPassword(String id) {
        this.password = id;
    }


    public String getPlainPassword() {
        return plainPassword;
    }


    public void setPlainPassword(String plainPassword) {
        this.plainPassword = plainPassword;
    }


    public String getUsername() {
        return username;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public Date getExpiration() {
        return expiration;
    }


    public void setExpiration(Date expiration) {
        this.expiration = expiration;
    }
}
