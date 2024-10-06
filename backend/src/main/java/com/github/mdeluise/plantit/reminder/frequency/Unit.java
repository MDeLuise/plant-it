package com.github.mdeluise.plantit.reminder.frequency;

import java.util.Calendar;

public enum Unit {
    DAYS(Calendar.DAY_OF_MONTH),
    WEEKS(Calendar.WEEK_OF_YEAR),
    MONTHS(Calendar.MONTH),
    YEARS(Calendar.YEAR);

    private final int calendarField;

    Unit(int calendarField) {
        this.calendarField = calendarField;
    }

    public int toCalendarField() {
        return this.calendarField;
    }
}
