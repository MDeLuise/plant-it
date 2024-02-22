package com.github.mdeluise.plantit.reminder.frequency;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FrequencyDTOConverter extends AbstractDTOConverter<Frequency, FrequencyDTO> {
    @Autowired
    public FrequencyDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public Frequency convertFromDTO(FrequencyDTO dto) {
        return modelMapper.map(dto, Frequency.class);
    }


    @Override
    public FrequencyDTO convertToDTO(Frequency data) {
        return modelMapper.map(data, FrequencyDTO.class);
    }
}
