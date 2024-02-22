package com.github.mdeluise.plantit.reminder.frequency;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Frequency", description = "Represents a reminder frequency.")
public class FrequencyDTO {
    @Schema(description = "Quantity of the frequency.")
    private int quantity;
    @Schema(description = "Unit of the frequency.")
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
