package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.tracked.arrangement.Arrangement;
import com.github.mdeluise.plantit.tracked.arrangement.ArrangementDTO;
import com.github.mdeluise.plantit.tracked.arrangement.ArrangementDTOConverter;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import com.github.mdeluise.plantit.tracked.plant.PlantDTO;
import com.github.mdeluise.plantit.tracked.plant.PlantDTOConverter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TrackedEntityDTOConverter extends AbstractDTOConverter<AbstractTrackedEntity, AbstractTrackedEntityDTO> {
    private final PlantDTOConverter plantDtoConverter;
    private final ArrangementDTOConverter arrangementDtoConverter;


    @Autowired
    public TrackedEntityDTOConverter(ModelMapper modelMapper, PlantDTOConverter plantDtoConverter,
                                     ArrangementDTOConverter arrangementDtoConverter) {
        super(modelMapper);
        this.plantDtoConverter = plantDtoConverter;
        this.arrangementDtoConverter = arrangementDtoConverter;
    }


    @Override
    public AbstractTrackedEntity convertFromDTO(AbstractTrackedEntityDTO dto) {
        AbstractTrackedEntity result;
        if (dto instanceof PlantDTO p) {
            result = plantDtoConverter.convertFromDTO(p);
        } else if (dto instanceof ArrangementDTO a) {
            result = arrangementDtoConverter.convertFromDTO(a);
        } else {
            throw new IllegalArgumentException("Cannot convert object " + dto.toString());
        }
        return result;
    }


    @Override
    public AbstractTrackedEntityDTO convertToDTO(AbstractTrackedEntity data) {
        AbstractTrackedEntityDTO result;
        if (data instanceof Plant p) {
            result = plantDtoConverter.convertToDTO(p);
        } else if (data instanceof Arrangement a) {
            result = arrangementDtoConverter.convertToDTO(a);
        } else {
            throw new IllegalArgumentException("Cannot convert object " + data.toString());
        }
        return result;
    }
}
