package com.github.mdeluise.plantit.tracked.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTOConverter;
import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PlantDTOConverter extends AbstractDTOConverter<Plant, PlantDTO> {
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;


    @Autowired
    public PlantDTOConverter(ModelMapper modelMapper, BotanicalInfoDTOConverter botanicalInfoDtoConverter) {
        super(modelMapper);
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
    }


    @Override
    public Plant convertFromDTO(PlantDTO dto) {
        final Plant result = modelMapper.map(dto, Plant.class);
        result.setBotanicalName(botanicalInfoDtoConverter.convertFromDTO(dto.getBotanicalName()));
        return result;
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        result.setBotanicalName(botanicalInfoDtoConverter.convertToDTO(data.getBotanicalName()));
        return result;
    }
}
