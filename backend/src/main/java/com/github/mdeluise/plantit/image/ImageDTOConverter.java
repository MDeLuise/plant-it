package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ImageDTOConverter extends AbstractDTOConverter<EntityImage, ImageDTO> {
    @Autowired
    public ImageDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public EntityImage convertFromDTO(ImageDTO dto) {
        return modelMapper.map(dto, EntityImageImpl.class);
    }


    @Override
    public ImageDTO convertToDTO(EntityImage data) {
        return modelMapper.map(data, ImageDTO.class);
    }
}
