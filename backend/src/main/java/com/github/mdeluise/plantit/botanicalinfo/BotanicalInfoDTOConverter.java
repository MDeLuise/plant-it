package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfo;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfoDTO;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfoDTOConverter;
import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BotanicalInfoDTOConverter extends AbstractDTOConverter<BotanicalInfo, BotanicalInfoDTO> {
    private final PlantCareInfoDTOConverter plantCareInfoDtoConverter;


    @Autowired
    public BotanicalInfoDTOConverter(ModelMapper modelMapper, PlantCareInfoDTOConverter plantCareInfoDtoConverter) {
        super(modelMapper);
        this.plantCareInfoDtoConverter = plantCareInfoDtoConverter;
    }


    @Override
    public BotanicalInfo convertFromDTO(BotanicalInfoDTO dto) {
        final BotanicalInfo result = modelMapper.map(dto, BotanicalInfo.class);
        final PlantCareInfo plantCareInfo = plantCareInfoDtoConverter.convertFromDTO(dto.getPlantCareInfo());
        result.setPlantCareInfo(plantCareInfo);
        if (dto.getImageContentType() != null) {
            result.getImage().setContentType(dto.getImageContentType());
        }
        return result;
    }


    @Override
    public BotanicalInfoDTO convertToDTO(BotanicalInfo data) {
        final BotanicalInfoDTO result = modelMapper.map(data, BotanicalInfoDTO.class);
        final PlantCareInfoDTO plantCareInfoDTO = plantCareInfoDtoConverter.convertToDTO(data.getPlantCareInfo());
        result.setPlantCareInfo(plantCareInfoDTO);
        return result;
    }
}
