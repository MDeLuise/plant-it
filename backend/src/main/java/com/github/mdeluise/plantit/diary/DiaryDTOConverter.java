package com.github.mdeluise.plantit.diary;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DiaryDTOConverter extends AbstractDTOConverter<Diary, DiaryDTO> {
    @Autowired
    public DiaryDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public Diary convertFromDTO(DiaryDTO dto) {
        return modelMapper.map(dto, Diary.class);
    }


    @Override
    public DiaryDTO convertToDTO(Diary data) {
        final DiaryDTO result = modelMapper.map(data, DiaryDTO.class);
        result.setEntriesCount((long) data.getEntries().size());
        return result;
    }
}
