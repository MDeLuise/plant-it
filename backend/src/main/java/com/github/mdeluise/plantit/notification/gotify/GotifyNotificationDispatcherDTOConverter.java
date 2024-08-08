package com.github.mdeluise.plantit.notification.gotify;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class GotifyNotificationDispatcherDTOConverter extends
    AbstractDTOConverter<GotifyNotificationDispatcherConfig, GotifyNotificationDispatcherConfigDTO> {
    public GotifyNotificationDispatcherDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public GotifyNotificationDispatcherConfig convertFromDTO(
        GotifyNotificationDispatcherConfigDTO dto) {
        return modelMapper.map(dto, GotifyNotificationDispatcherConfig.class);
    }


    @Override
    public GotifyNotificationDispatcherConfigDTO convertToDTO(
        GotifyNotificationDispatcherConfig data) {
        return modelMapper.map(data, GotifyNotificationDispatcherConfigDTO.class);
    }
}
