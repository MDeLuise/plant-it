package com.github.mdeluise.plantit.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTOConverter;
import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.image.EntityImageImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PlantDTOConverter extends AbstractDTOConverter<Plant, PlantDTO> {
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    private final PlantAvatarGetter plantAvatarGetter;


    @Autowired
    public PlantDTOConverter(ModelMapper modelMapper, BotanicalInfoDTOConverter botanicalInfoDtoConverter,
                             PlantAvatarGetter plantAvatarGetter) {
        super(modelMapper);
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
        this.plantAvatarGetter = plantAvatarGetter;
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
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        final EntityImageImpl plantAvatar = plantAvatarGetter.getPlantAvatar(data);
        if (plantAvatar != null) {
            result.setAvatarImageId(plantAvatarGetter.getPlantAvatar(data).getId());
            result.setAvatarImageUrl(plantAvatarGetter.getPlantAvatar(data).getUrl());
        }
        return result;
    }
}
