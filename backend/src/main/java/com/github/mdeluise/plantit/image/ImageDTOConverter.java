package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ImageDTOConverter extends AbstractDTOConverter<AbstractImage, ImageDTO> {
    @Autowired
    public ImageDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public AbstractImage convertFromDTO(ImageDTO dto) {
        return modelMapper.map(dto, AbstractImage.class);
    }


    @Override
    public ImageDTO convertToDTO(AbstractImage data) {
        return modelMapper.map(data, ImageDTO.class);
    }
}
