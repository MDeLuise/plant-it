package com.github.mdeluise.plantit.tracked.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTOConverter;
import com.github.mdeluise.plantit.botanicalinfo.GlobalBotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo;
import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.image.AbstractBotanicalInfoImage;
import com.github.mdeluise.plantit.image.ImageService;
import com.github.mdeluise.plantit.image.WebBotanicalInfoImage;
import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.modelmapper.spi.MappingContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/*
 * This class is a mess. It's this way because in BotanicalInfo there is the field image of type
 * AbstractBotanicalInfoImage. AbstractBotanicalInfoImage is an abstract class, and modelMapper throw error
 * converting Plant <-> PlantDTO because it trys to instantiate AbstractBotanicalInfoImage.
 * Thus, this very bad workaround.
 */
@Component
public class PlantDTOConverter extends AbstractDTOConverter<Plant, PlantDTO> {
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    private final ImageService imageService;


    @Autowired
    public PlantDTOConverter(ModelMapper modelMapper, BotanicalInfoDTOConverter botanicalInfoDtoConverter,
                             ImageService imageService) {
        super(modelMapper);
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
        this.imageService = imageService;

        modelMapper.getConfiguration().setSkipNullEnabled(true);
    }


    @Override
    public Plant convertFromDTO(PlantDTO dto) {
        modelMapper.typeMap(BotanicalInfoDTO.class, BotanicalInfo.class)
                   .setConverter(new BotanicalInfoConverter());

        if (dto.getBotanicalInfo().getId() == null) {
            modelMapper.typeMap(BotanicalInfoDTO.class, BotanicalInfo.class)
                       .addMappings(mapper -> mapper.skip(BotanicalInfo::setId));
        } else {
            modelMapper.typeMap(BotanicalInfoDTO.class, BotanicalInfo.class);
        }

        return modelMapper.map(dto, Plant.class);
    }


    @Override
    public PlantDTO convertToDTO(Plant data) {
        final PlantDTO result = modelMapper.map(data, PlantDTO.class);
        result.setBotanicalInfo(botanicalInfoDtoConverter.convertToDTO(data.getBotanicalInfo()));
        return result;
    }


    private class BotanicalInfoConverter implements Converter<BotanicalInfoDTO, BotanicalInfo> {
        @Override
        public BotanicalInfo convert(MappingContext<BotanicalInfoDTO, BotanicalInfo> context) {
            final BotanicalInfoDTO botanicalInfoDTO = context.getSource();
            Class<? extends BotanicalInfo> clazz = botanicalInfoDTO.getImageId() == null ?
                                                       GlobalBotanicalInfo.class : UserCreatedBotanicalInfo.class;

            final BotanicalInfo botanicalInfo;
            try {
                botanicalInfo = clazz.getConstructor().newInstance();
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            botanicalInfo.setFamily(botanicalInfoDTO.getFamily());
            botanicalInfo.setGenus(botanicalInfoDTO.getGenus());
            botanicalInfo.setScientificName(botanicalInfoDTO.getScientificName());
            botanicalInfo.setId(botanicalInfoDTO.getId());
            if (botanicalInfoDTO.getImageId() != null) {
                botanicalInfo.setImage((AbstractBotanicalInfoImage) imageService.get(botanicalInfoDTO.getImageId()));
            } else if (botanicalInfoDTO.getImageUrl() != null) {
                WebBotanicalInfoImage webBotanicalInfoImage = new WebBotanicalInfoImage();
                webBotanicalInfoImage.setUrl(botanicalInfoDTO.getImageUrl());
                botanicalInfo.setImage(webBotanicalInfoImage);
            }
            return botanicalInfo;
        }
    }
}
