package com.github.mdeluise.plantit.reminder;

import java.util.Date;

import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.reminder.frequency.Frequency;
import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "reminders")
public class Reminder {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "target_id", nullable = false)
    private Plant target;
    @NotNull
    @Column(name = "reminder_start")
    private Date start;
    @Column(name = "reminder_end")
    private Date end;
    @Embedded
    private Frequency frequency;
    @NotNull
    @Enumerated(EnumType.STRING)
    private DiaryEntryType action;
    private boolean enabled;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Plant getTarget() {
        return target;
    }


    public void setTarget(Plant target) {
        this.target = target;
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


    public Frequency getFrequency() {
        return frequency;
    }


    public void setFrequency(Frequency frequency) {
        this.frequency = frequency;
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


    public boolean isActive() {
        final Date now = new Date();
        return enabled && now.after(start) && now.before(end);
    }
}
