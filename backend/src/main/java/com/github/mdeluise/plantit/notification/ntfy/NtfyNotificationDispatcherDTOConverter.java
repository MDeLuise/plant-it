package com.github.mdeluise.plantit.notification.ntfy;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class NtfyNotificationDispatcherDTOConverter extends
    AbstractDTOConverter<NtfyNotificationDispatcherConfig, NtfyNotificationDispatcherConfigDTO> {
    public NtfyNotificationDispatcherDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public NtfyNotificationDispatcherConfig convertFromDTO(NtfyNotificationDispatcherConfigDTO dto) {
        return modelMapper.map(dto, NtfyNotificationDispatcherConfig.class);
    }


    @Override
    public NtfyNotificationDispatcherConfigDTO convertToDTO(NtfyNotificationDispatcherConfig data) {
        return modelMapper.map(data, NtfyNotificationDispatcherConfigDTO.class);
    }
}
