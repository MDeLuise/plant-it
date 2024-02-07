package com.github.mdeluise.plantit.plant.info;

import java.util.Date;
import java.util.Objects;

import com.github.mdeluise.plantit.plant.PlantState;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Plant info", description = "Represents additional info about a plant.")
public class PlantInfoDTO {
    @Schema(description = "Purchased date of the plant.")
    private Date startDate;
    @Schema(description = "Personal name of the plant.")
    private String personalName;
    @Schema(description = "End date of the plant.")
    private Date endDate;
    @Schema(description = "State of the plant.")
    private PlantState plantState;
    @Schema(description = "Note of the plant.")
    private String note;
    @Schema(description = "Price of the plant when purchased.")
    private Double purchasedPrice;
    @Schema(description = "Currency of the purchased price.")
    private String currencySymbol;
    @Schema(description = "Seller of the plant.")
    private String seller;
    @Schema(description = "Physical location of the plant.")
    private String location;


    public Date getStartDate() {
        return startDate;
    }


    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }


    public String getPersonalName() {
        return personalName;
    }


    public void setPersonalName(String personalName) {
        this.personalName = personalName;
    }


    public Date getEndDate() {
        return endDate;
    }


    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    public PlantState getPlantState() {
        return plantState;
    }


    public void setPlantState(PlantState plantState) {
        this.plantState = plantState;
    }


    public String getNote() {
        return note;
    }


    public void setNote(String note) {
        this.note = note;
    }


    public Double getPurchasedPrice() {
        return purchasedPrice;
    }


    public void setPurchasedPrice(Double purchasedPrice) {
        this.purchasedPrice = purchasedPrice;
    }


    public String getCurrencySymbol() {
        return currencySymbol;
    }


    public void setCurrencySymbol(String currencySymbol) {
        this.currencySymbol = currencySymbol;
    }


    public String getSeller() {
        return seller;
    }


    public void setSeller(String seller) {
        this.seller = seller;
    }


    public String getLocation() {
        return location;
    }


    public void setLocation(String location) {
        this.location = location;
    }


    @SuppressWarnings("BooleanExpressionComplexity") //FIXME
    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final PlantInfoDTO that = (PlantInfoDTO) o;
        return Objects.equals(startDate, that.startDate) && Objects.equals(personalName, that.personalName) &&
                   Objects.equals(endDate, that.endDate) && plantState == that.plantState &&
                   Objects.equals(note, that.note) && Objects.equals(purchasedPrice, that.purchasedPrice) &&
                   Objects.equals(currencySymbol, that.currencySymbol) && Objects.equals(seller, that.seller) &&
                   Objects.equals(location, that.location);
    }


    @Override
    public int hashCode() {
        return Objects.hash(startDate, personalName, endDate, plantState, note, purchasedPrice, currencySymbol, seller,
                            location
        );
    }
}
