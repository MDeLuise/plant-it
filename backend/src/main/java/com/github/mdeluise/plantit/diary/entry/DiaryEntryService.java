package com.github.mdeluise.plantit.diary.entry;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;

@Service
public class DiaryEntryService extends AbstractAuthenticatedService {
    private final DiaryEntryRepository diaryEntryRepository;
    private final DiaryService diaryService;


    @Autowired
    public DiaryEntryService(UserService userService, DiaryEntryRepository diaryEntryRepository,
                             DiaryService diaryService) {
        super(userService);
        this.diaryEntryRepository = diaryEntryRepository;
        this.diaryService = diaryService;
    }


    public Page<DiaryEntry> getAll(Pageable pageable) {
        return diaryEntryRepository.findAllByDiaryOwner(getAuthenticatedUser(), pageable);
    }


    public Page<DiaryEntry> getAll(Long diaryId, Pageable pageable) {
        final Diary diary = diaryService.get(diaryId);
        return diaryEntryRepository.findAllByDiaryOwnerAndDiary(getAuthenticatedUser(), diary, pageable);
    }


    public Collection<DiaryEntryType> getAllTypes() {
        final DiaryEntryType[] result = DiaryEntryType.class.getEnumConstants();
        return List.of(result);
    }


    public DiaryEntry save(DiaryEntry diaryEntry) {
        return diaryEntryRepository.save(diaryEntry);
    }


    public DiaryEntry get(Long id) {
        return diaryEntryRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }
}
