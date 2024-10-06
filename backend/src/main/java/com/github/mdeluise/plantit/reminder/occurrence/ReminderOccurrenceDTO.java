package com.github.mdeluise.plantit.reminder.occurrence;

import java.util.Date;

import com.github.mdeluise.plantit.reminder.frequency.FrequencyDTO;

public class ReminderOccurrenceDTO {
    private Date date;
    private Long reminderId;
    private FrequencyDTO reminderFrequency;
    private String reminderAction;
    private Long reminderTargetId;
    private String reminderTargetInfoPersonalName;


    public Date getDate() {
        return date;
    }


    public void setDate(Date date) {
        this.date = date;
    }


    public Long getReminderId() {
        return reminderId;
    }


    public void setReminderId(Long reminderId) {
        this.reminderId = reminderId;
    }


    public FrequencyDTO getReminderFrequency() {
        return reminderFrequency;
    }


    public void setReminderFrequency(FrequencyDTO reminderFrequency) {
        this.reminderFrequency = reminderFrequency;
    }


    public String getReminderAction() {
        return reminderAction;
    }


    public void setReminderAction(String reminderAction) {
        this.reminderAction = reminderAction;
    }


    public Long getReminderTargetId() {
        return reminderTargetId;
    }


    public void setReminderTargetId(Long reminderTargetId) {
        this.reminderTargetId = reminderTargetId;
    }


    public String getReminderTargetInfoPersonalName() {
        return reminderTargetInfoPersonalName;
    }


    public void setReminderTargetInfoPersonalName(String reminderTargetInfoPersonalName) {
        this.reminderTargetInfoPersonalName = reminderTargetInfoPersonalName;
    }
}
