package com.github.mdeluise.plantit.image;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import org.hibernate.validator.constraints.Length;

@Entity
@DiscriminatorValue("1")
public class WebBotanicalInfoImage extends AbstractBotanicalInfoImage {
    @Length(max = 255)
    private String url;


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }
}
