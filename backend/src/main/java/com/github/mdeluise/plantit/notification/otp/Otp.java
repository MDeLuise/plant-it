package com.github.mdeluise.plantit.notification.otp;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

@Entity
@Table(name = "otp_codes")
public class Otp {
    @Id
    @Length(min = 5, max = 70)
    private String email;
    @NotEmpty
    @Length(min = 5, max = 10)
    private String code;
    @NotNull
    private Date expiration;


    public String getCode() {
        return code;
    }


    public void setCode(String id) {
        this.code = id;
    }


    public String getEmail() {
        return email;
    }


    public void setEmail(String email) {
        this.email = email;
    }


    public Date getExpiration() {
        return expiration;
    }


    public void setExpiration(Date expiration) {
        this.expiration = expiration;
    }
}
