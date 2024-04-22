package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import jakarta.persistence.CascadeType;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Transient;

@Entity
@DiscriminatorValue("1")
public class BotanicalInfoImage extends EntityImageImpl {
    @OneToOne(cascade = {CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinColumn(name = "botanical_info_entity_id")
    private BotanicalInfo target;
    @Transient
    private byte[] content;


    public BotanicalInfoImage() {
        super();
    }


    public BotanicalInfo getTarget() {
        return target;
    }


    public void setTarget(BotanicalInfo target) {
        this.target = target;
    }


    public byte[] getContent() {
        return content;
    }


    public void setContent(byte[] content) {
        this.content = content;
    }
}
