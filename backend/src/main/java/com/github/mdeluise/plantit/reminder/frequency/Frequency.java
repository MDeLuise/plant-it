package com.github.mdeluise.plantit.reminder.frequency;

import jakarta.persistence.Embeddable;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.NotNull;

@Embeddable
public class Frequency {
    @NotNull
    private int quantity;
    @NotNull
    @Enumerated(EnumType.STRING)
    private Unit unit;


    public int getQuantity() {
        return quantity;
    }


    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public Unit getUnit() {
        return unit;
    }


    public void setUnit(Unit unit) {
        this.unit = unit;
    }
}
