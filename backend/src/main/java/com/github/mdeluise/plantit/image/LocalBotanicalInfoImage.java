package com.github.mdeluise.plantit.image;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Lob;
import jakarta.validation.constraints.Size;

@Entity
@DiscriminatorValue("2")
public class LocalBotanicalInfoImage extends AbstractBotanicalInfoImage {
    @Size(max = 100000)
    @Lob
    private byte[] content;


    public byte[] getContent() {
        return content;
    }


    public void setContent(byte[] content) {
        this.content = content;
    }
}
