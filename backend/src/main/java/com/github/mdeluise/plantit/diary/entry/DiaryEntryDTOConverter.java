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
        return modelMapper.map(dto, DiaryEntry.class);
    }


    @Override
    public DiaryEntryDTO convertToDTO(DiaryEntry data) {
        final DiaryEntryDTO result = modelMapper.map(data, DiaryEntryDTO.class);
        if (result.getDate() == null) {
            result.setDate(new Date());
        }
        return result;
    }
}
