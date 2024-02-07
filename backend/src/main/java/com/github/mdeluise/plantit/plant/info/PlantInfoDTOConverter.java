package com.github.mdeluise.plantit.plant.info;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class PlantInfoDTOConverter extends AbstractDTOConverter<PlantInfo, PlantInfoDTO> {
    public PlantInfoDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public PlantInfo convertFromDTO(PlantInfoDTO dto) {
        return modelMapper.map(dto, PlantInfo.class);
    }


    @Override
    public PlantInfoDTO convertToDTO(PlantInfo data) {
        return modelMapper.map(data, PlantInfoDTO.class);
    }
}
