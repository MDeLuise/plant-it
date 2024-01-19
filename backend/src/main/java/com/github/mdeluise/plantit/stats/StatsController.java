package com.github.mdeluise.plantit.stats;

import com.github.mdeluise.plantit.systeminfo.StatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/stats")
@Tag(name = "Stats", description = "Endpoints for user stats")
public class StatsController {
    private final StatsService statsService;


    @Autowired
    public StatsController(StatsService statsService) {
        this.statsService = statsService;
    }


    @GetMapping
    @Operation(summary = "Get the stats", description = "Get the authenticated user stats.")
    public ResponseEntity<UserStats> getStats() {
        final UserStats result = statsService.getStats();
        return ResponseEntity.ok(result);
    }
}
