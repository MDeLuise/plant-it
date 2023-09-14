package com.github.mdeluise.plantit.authentication;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserDTOConverter extends AbstractDTOConverter<User, UserDTO> {

    @Autowired
    public UserDTOConverter(ModelMapper modelMapper) {
        super(modelMapper);
    }


    @Override
    public User convertFromDTO(UserDTO dto) {
        return modelMapper.map(dto, User.class);
    }


    @Override
    public UserDTO convertToDTO(User data) {
        return modelMapper.map(data, UserDTO.class);
    }
}
