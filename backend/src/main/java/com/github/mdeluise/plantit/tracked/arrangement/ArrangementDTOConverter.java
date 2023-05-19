package com.github.mdeluise.plantit.tracked.arrangement;

import com.github.mdeluise.plantit.common.AbstractDTOConverter;
import com.github.mdeluise.plantit.tracked.TrackedEntityService;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.stream.Collectors;

@Component
public class ArrangementDTOConverter extends AbstractDTOConverter<Arrangement, ArrangementDTO> {
    private final TrackedEntityService trackedEntityService;


    @Autowired
    public ArrangementDTOConverter(ModelMapper modelMapper, TrackedEntityService trackedEntityService) {
        super(modelMapper);
        this.trackedEntityService = trackedEntityService;
    }


    @Override
    public Arrangement convertFromDTO(ArrangementDTO dto) {
        final Arrangement result = modelMapper.map(dto, Arrangement.class);
        final Set<Plant> components = dto.getComponentIds().stream()
                                         .map(trackedEntityService::get)
                                         .map(e -> (Plant) e)
                                         .collect(Collectors.toSet());
        result.setComponents(components);
        return result;
    }


    @Override
    public ArrangementDTO convertToDTO(Arrangement data) {
        final ArrangementDTO result = modelMapper.map(data, ArrangementDTO.class);
        final Set<Long> componentIds = data.getComponents().stream().map(Plant::getId).collect(Collectors.toSet());
        result.setComponentIds(componentIds);
        return result;
    }
}
