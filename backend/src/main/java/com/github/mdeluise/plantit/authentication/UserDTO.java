package com.github.mdeluise.plantit.authentication;

import java.util.Objects;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "User", description = "Represents a user of the system.")
public class UserDTO {
    @Schema(description = "ID of the user.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Username of the user.")
    private String username;
    @Schema(description = "Email of the user.")
    private String email;


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


    public String getEmail() {
        return email;
    }


    public void setEmail(String email) {
        this.email = email;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final UserDTO userDTO = (UserDTO) o;
        return Objects.equals(id, userDTO.id) && Objects.equals(username, userDTO.username) &&
                   Objects.equals(email, userDTO.email);
    }


    @Override
    public int hashCode() {
        return Objects.hash(id, username, email);
    }
}
