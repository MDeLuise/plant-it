package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.authentication.User;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
@DiscriminatorValue("2")
public class UserCreatedBotanicalInfo extends BotanicalInfo {
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User creator;


    public User getCreator() {
        return creator;
    }


    public void setCreator(User creator) {
        this.creator = creator;
    }
}
