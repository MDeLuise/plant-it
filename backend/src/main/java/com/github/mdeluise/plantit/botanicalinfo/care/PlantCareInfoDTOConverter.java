package com.github.mdeluise.plantit.botanicalinfo.care;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class PlantCareInfoDTOConverter extends AbstractDTOConverter<PlantCareInfo, PlantCareInfoDTO> {
    public PlantCareInfoDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public PlantCareInfo convertFromDTO(PlantCareInfoDTO dto) {
        return modelMapper.map(dto, PlantCareInfo.class);
    }


    @Override
    public PlantCareInfoDTO convertToDTO(PlantCareInfo data) {
        return modelMapper.map(data, PlantCareInfoDTO.class);
    }
}
