package com.github.mdeluise.plantit.common;

import org.modelmapper.ModelMapper;

public abstract class AbstractDTOConverter<T, D> {
    protected final ModelMapper modelMapper;


    public AbstractDTOConverter(ModelMapper modelMapper) {
        this.modelMapper = modelMapper;
    }


    public abstract T convertFromDTO(D dto);

    public abstract D convertToDTO(T data);
}
