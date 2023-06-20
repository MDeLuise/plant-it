package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToOne;

@Entity
public abstract class AbstractBotanicalInfoImage extends AbstractImage {
    @OneToOne(mappedBy = "image")
    private BotanicalInfo botanicalInfo;


    public BotanicalInfo getBotanicalName() {
        return botanicalInfo;
    }


    public void setBotanicalName(BotanicalInfo botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }
}
