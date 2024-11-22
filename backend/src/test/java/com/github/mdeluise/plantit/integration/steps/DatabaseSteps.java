package com.github.mdeluise.plantit.integration.steps;

import org.springframework.test.web.servlet.MockMvc;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.integration.StepData;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.reminder.ReminderService;
import io.cucumber.java.en.And;
import jakarta.transaction.Transactional;

public class DatabaseSteps {
    final MockMvc mockMvc;
    final StepData stepData;
    final ObjectMapper objectMapper;
    private final UserService userService;
    private final BotanicalInfoService botanicalInfoService;
    private final PlantService plantService;
    private final ReminderService reminderService;


    public DatabaseSteps(MockMvc mockMvc, StepData stepData, ObjectMapper objectMapper, UserService userService,
                         BotanicalInfoService botanicalInfoService, PlantService plantService,
                         ReminderService reminderService) {
        this.mockMvc = mockMvc;
        this.stepData = stepData;
        this.objectMapper = objectMapper;
        this.userService = userService;
        this.botanicalInfoService = botanicalInfoService;
        this.plantService = plantService;
        this.reminderService = reminderService;
    }


    @And("cleanup the database")
    @Transactional
    public void cleanupDB() {
        reminderService.deleteAll();
        plantService.deleteAll();
        botanicalInfoService.deleteAll();
        userService.removeAll();
    }
}
