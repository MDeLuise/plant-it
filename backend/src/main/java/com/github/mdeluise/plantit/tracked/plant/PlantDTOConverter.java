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
        result.setBotanicalInfo(botanicalInfoDtoConverter.convertFromDTO(dto.getBotanicalInfo()));
        return result;
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        result.setBotanicalInfo(botanicalInfoDtoConverter.convertToDTO(data.getBotanicalInfo()));
        return result;
    }
}
