package com.github.mdeluise.plantit.tracked.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import com.github.mdeluise.plantit.tracked.arrangement.Arrangement;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;

@Entity
@DiscriminatorValue("1")
public class Plant extends AbstractTrackedEntity {
    @NotNull
    @ManyToOne
    @JoinColumn(name = "botanical_name_id", nullable = false)
    private BotanicalInfo botanicalInfo;
    @ManyToOne
    @JoinColumn(name = "arrangement_id")
    private Arrangement arrangement;


    public BotanicalInfo getBotanicalName() {
        return botanicalInfo;
    }


    public void setBotanicalName(BotanicalInfo botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }


    public Arrangement getArrangement() {
        return arrangement;
    }


    public void setArrangement(Arrangement arrangement) {
        this.arrangement = arrangement;
    }
}
