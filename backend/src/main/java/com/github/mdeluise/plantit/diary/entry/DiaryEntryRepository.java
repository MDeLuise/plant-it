package com.github.mdeluise.plantit.diary.entry;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.diary.Diary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DiaryEntryRepository extends JpaRepository<DiaryEntry, Long> {
    Page<DiaryEntry> findAllByDiaryOwner(User user, Pageable pageable);

    Page<DiaryEntry> findAllByDiaryOwnerAndDiary(User user, Diary diary, Pageable pageable);

    Long countByDiaryOwner(User user);
}
