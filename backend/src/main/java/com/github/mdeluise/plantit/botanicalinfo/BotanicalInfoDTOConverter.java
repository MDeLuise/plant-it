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
        Class<? extends BotanicalInfo> concreteClass =
            dto.isSystemWide() ? GlobalBotanicalInfo.class : UserCreatedBotanicalInfo.class;
        return modelMapper.map(dto, concreteClass);
    }


    @Override
    public BotanicalInfoDTO convertToDTO(BotanicalInfo data) {
        final BotanicalInfoDTO result = modelMapper.map(data, BotanicalInfoDTO.class);
        result.setSystemWide(!(data instanceof UserCreatedBotanicalInfo));
        return result;
    }
}
