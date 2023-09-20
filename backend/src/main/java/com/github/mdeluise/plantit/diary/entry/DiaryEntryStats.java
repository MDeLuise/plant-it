package com.github.mdeluise.plantit.diary.entry;

import java.util.Date;

public record DiaryEntryStats(
    DiaryEntryType type,
    Date date
) { }
