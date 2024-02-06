package com.github.mdeluise.plantit.plant;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.plant.info.PlantInfo;
import com.github.mdeluise.plantit.plant.info.PlantInfoDTO;
import com.github.mdeluise.plantit.plant.info.PlantInfoDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PlantDTOConverter extends AbstractDTOConverter<Plant, PlantDTO> {
    private final PlantAvatarGetter plantAvatarGetter;
    private final PlantInfoDTOConverter plantInfoDtoConverter;


    @Autowired
    public PlantDTOConverter(ModelMapper modelMapper, PlantAvatarGetter plantAvatarGetter,
                             PlantInfoDTOConverter plantInfoDtoConverter) {
        super(modelMapper);
        this.plantAvatarGetter = plantAvatarGetter;
        this.plantInfoDtoConverter = plantInfoDtoConverter;
    }


    @Override
    public Plant convertFromDTO(PlantDTO dto) {
        final Plant result = modelMapper.map(dto, Plant.class);
        final PlantInfo plantInfo = plantInfoDtoConverter.convertFromDTO(dto.getInfo());
        result.setInfo(plantInfo);
        return result;
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        final PlantInfoDTO plantInfoDTO = plantInfoDtoConverter.convertToDTO(data.getInfo());
        result.setInfo(plantInfoDTO);
        final EntityImage plantAvatar = plantAvatarGetter.getPlantAvatar(data);
        if (plantAvatar != null) {
            result.setAvatarImageId(plantAvatarGetter.getPlantAvatar(data).getId());
            result.setAvatarImageUrl(plantAvatarGetter.getPlantAvatar(data).getUrl());
        }
        return result;
    }
}
