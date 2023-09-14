package com.github.mdeluise.plantit.authentication;

// not a record only because modelMapper needs to instantiate the object
public class UserDTO {
    private Long id;
    private String username;


    public UserDTO() {
    }


    public void setId(Long id) {
        this.id = id;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public Long getId() {
        return id;
    }


    public String getUsername() {
        return username;
    }
}
