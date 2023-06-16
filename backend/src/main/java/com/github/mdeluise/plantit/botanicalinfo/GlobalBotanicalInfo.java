package com.github.mdeluise.plantit.botanicalinfo;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("1")
public class GlobalBotanicalInfo extends BotanicalInfo {
}
