package com.github.mdeluise.plantit.reminder;

import java.util.Date;

import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.reminder.frequency.FrequencyDTO;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Reminder", description = "Represents a reminder.")
public class ReminderDTO {
    @Schema(description = "ID of the reminder.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "ID of the reminder's target.")
    private Long targetId;
    @Schema(description = "Start date of the reminder.")
    private Date start;
    @Schema(description = "End date of the reminder.")
    private Date end;
    @Schema(description = "Frequency of the reminder.")
    private FrequencyDTO frequency;
    @Schema(description = "Repetition of the reminder.")
    private FrequencyDTO repeatAfter;
    @Schema(description = "Date of last reminder's notification")
    private Date lastNotified;
    @Schema(description = "Action of the reminder.")
    private DiaryEntryType action;
    @Schema(description = "Is reminder enabled.")
    private boolean enabled;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Long getTargetId() {
        return targetId;
    }


    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }


    public Date getStart() {
        return start;
    }


    public void setStart(Date start) {
        this.start = start;
    }


    public Date getEnd() {
        return end;
    }


    public void setEnd(Date end) {
        this.end = end;
    }


    public FrequencyDTO getFrequency() {
        return frequency;
    }


    public void setFrequency(FrequencyDTO frequency) {
        this.frequency = frequency;
    }


    public FrequencyDTO getRepeatAfter() {
        return repeatAfter;
    }


    public void setRepeatAfter(FrequencyDTO repeatAfter) {
        this.repeatAfter = repeatAfter;
    }


    public Date getLastNotified() {
        return lastNotified;
    }


    public void setLastNotified(Date lastNotified) {
        this.lastNotified = lastNotified;
    }


    public DiaryEntryType getAction() {
        return action;
    }


    public void setAction(DiaryEntryType action) {
        this.action = action;
    }


    public boolean isEnabled() {
        return enabled;
    }


    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}
