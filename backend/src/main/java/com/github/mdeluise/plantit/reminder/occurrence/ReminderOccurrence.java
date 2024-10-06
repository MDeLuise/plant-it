package com.github.mdeluise.plantit.reminder.occurrence;

import java.util.Date;

import com.github.mdeluise.plantit.reminder.Reminder;

public class ReminderOccurrence {
    private Date date;
    private Reminder reminder;


    public Date getDate() {
        return date;
    }


    public void setDate(Date date) {
        this.date = date;
    }


    public Reminder getReminder() {
        return reminder;
    }


    public void setReminder(Reminder reminder) {
        this.reminder = reminder;
    }
}
