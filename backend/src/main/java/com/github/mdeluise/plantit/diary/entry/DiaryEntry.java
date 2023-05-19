package com.github.mdeluise.plantit.diary.entry;

import com.github.mdeluise.plantit.diary.Diary;
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

import java.util.Date;

@Entity
@Table(name = "diary_entries")
public class DiaryEntry {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    @Enumerated(EnumType.STRING)
    private DiaryEntryType type;
    private String note;
    @NotNull
    private Date date;
    @ManyToOne
    @JoinColumn(name = "diary_id", nullable = false)
    private Diary diary;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public DiaryEntryType getType() {
        return type;
    }


    public void setType(DiaryEntryType type) {
        this.type = type;
    }


    public String getNote() {
        return note;
    }


    public void setNote(String note) {
        this.note = note;
    }


    public Date getDate() {
        return date;
    }


    public void setDate(Date date) {
        this.date = date;
    }


    public Diary getDiary() {
        return diary;
    }


    public void setDiary(Diary diary) {
        this.diary = diary;
    }
}
