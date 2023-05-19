package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BotanicalInfoDTOConverter extends AbstractDTOConverter<BotanicalInfo, BotanicalInfoDTO> {
    @Autowired
    public BotanicalInfoDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public BotanicalInfo convertFromDTO(BotanicalInfoDTO dto) {
        return modelMapper.map(dto, BotanicalInfo.class);
    }


    @Override
    public BotanicalInfoDTO convertToDTO(BotanicalInfo data) {
        return modelMapper.map(data, BotanicalInfoDTO.class);
    }
}
