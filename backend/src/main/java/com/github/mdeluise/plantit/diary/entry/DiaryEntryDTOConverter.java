package com.github.mdeluise.plantit.diary.entry;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class DiaryEntryDTOConverter extends AbstractDTOConverter<DiaryEntry, DiaryEntryDTO> {
    public DiaryEntryDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public DiaryEntry convertFromDTO(DiaryEntryDTO dto) {
        final DiaryEntry result = modelMapper.map(dto, DiaryEntry.class);
        if (result.getDate() == null) {
            result.setDate(new Date());
        }
        return result;
    }


    @Override
    public DiaryEntryDTO convertToDTO(DiaryEntry data) {
        return modelMapper.map(data, DiaryEntryDTO.class);
    }
}
