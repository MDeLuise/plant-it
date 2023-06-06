package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToOne;
import org.hibernate.validator.constraints.Length;

@Entity
@DiscriminatorValue("1")
public class BotanicalNameImage extends AbstractImage {
    @OneToOne(mappedBy = "image")
    private BotanicalInfo botanicalInfo;
    @Length(max = 255)
    private String url;


    public BotanicalInfo getBotanicalName() {
        return botanicalInfo;
    }


    public void setBotanicalName(BotanicalInfo botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }
}
