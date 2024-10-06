package com.github.mdeluise.plantit.reminder.occurrence;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Controller;

@Controller
public class ReminderOccurrenceDTOConverter extends AbstractDTOConverter<ReminderOccurrence, ReminderOccurrenceDTO> {
    public ReminderOccurrenceDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public ReminderOccurrence convertFromDTO(ReminderOccurrenceDTO dto) {
        return modelMapper.map(dto, ReminderOccurrence.class);
    }


    @Override
    public ReminderOccurrenceDTO convertToDTO(ReminderOccurrence data) {
        return modelMapper.map(data, ReminderOccurrenceDTO.class);
    }
}
