package com.github.mdeluise.plantit.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
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
        final BotanicalInfo convertedBotanicalInfo = botanicalInfoDtoConverter.convertFromDTO(dto.getBotanicalInfo());
        final Plant result = modelMapper.map(dto, Plant.class);
        result.setBotanicalInfo(convertedBotanicalInfo);
        return result;
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        return modelMapper.map(data, PlantDTO.class);
    }
}
