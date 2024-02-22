package com.github.mdeluise.plantit.reminder;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.reminder.frequency.FrequencyDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ReminderDTOConverter extends AbstractDTOConverter<Reminder, ReminderDTO> {
    private final FrequencyDTOConverter frequencyDtoConverter;

    @Autowired
    public ReminderDTOConverter(ModelMapper modelMapper, FrequencyDTOConverter frequencyDtoConverter) {
        super(modelMapper);
        this.frequencyDtoConverter = frequencyDtoConverter;
    }


    @Override
    public Reminder convertFromDTO(ReminderDTO dto) {
        final Reminder result = modelMapper.map(dto, Reminder.class);
        result.setFrequency(frequencyDtoConverter.convertFromDTO(dto.getFrequency()));
        return result;
    }


    @Override
    public ReminderDTO convertToDTO(Reminder data) {
        final ReminderDTO result = modelMapper.map(data, ReminderDTO.class);
        result.setFrequency(frequencyDtoConverter.convertToDTO(data.getFrequency()));
        return result;
    }
}
