package com.github.mdeluise.plantit.plant;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.image.EntityImage;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PlantDTOConverter extends AbstractDTOConverter<Plant, PlantDTO> {
    private final PlantAvatarGetter plantAvatarGetter;


    @Autowired
    public PlantDTOConverter(ModelMapper modelMapper, PlantAvatarGetter plantAvatarGetter) {
        super(modelMapper);
        this.plantAvatarGetter = plantAvatarGetter;
    }


    @Override
    public Plant convertFromDTO(PlantDTO dto) {
        return modelMapper.map(dto, Plant.class);
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        final EntityImage plantAvatar = plantAvatarGetter.getPlantAvatar(data);
        if (plantAvatar != null) {
            result.setAvatarImageId(plantAvatarGetter.getPlantAvatar(data).getId());
            result.setAvatarImageUrl(plantAvatarGetter.getPlantAvatar(data).getUrl());
        }
        return result;
    }
}
