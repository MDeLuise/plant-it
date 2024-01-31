package com.github.mdeluise.plantit.unit.service;

import java.io.IOException;

import com.github.mdeluise.plantit.systeminfo.GitHubReleaseInfo;
import com.github.mdeluise.plantit.systeminfo.GitHubSystemVersionService;
import com.github.mdeluise.plantit.systeminfo.SystemVersionInfo;
import com.github.mdeluise.plantit.systeminfo.SystemVersionService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for SystemVersionService")
class SystemVersionServiceUnitTests {
    @Mock
    private GitHubSystemVersionService gitHubSystemVersionService;
    private final String version = "v0.0.0";
    private final String activeProfiles = "unit";
    private SystemVersionService systemVersionService;


    @BeforeEach
    void setUp() {
        this.systemVersionService = new SystemVersionService(version, activeProfiles, gitHubSystemVersionService);
    }


    @Test
    @DisplayName("Should get latest version from GitHub when not in dev profile")
    void shouldGetLatestVersionFromGitHubWhenNotInDevProfile() throws IOException, InterruptedException {
        final GitHubReleaseInfo releaseInfo = new GitHubReleaseInfo();
        releaseInfo.setTagName("v0.0.0");
        releaseInfo.setBody("Release notes for v0.0.0");
        Mockito.when(gitHubSystemVersionService.getLatestVersion()).thenReturn(releaseInfo);

        final SystemVersionInfo result = systemVersionService.getLatestVersion();

        Assertions.assertThat(result.getCurrentVersion()).isEqualTo(version);
        Assertions.assertThat(result.isLatest()).isTrue();
        Assertions.assertThat(result.getLatestVersion()).isEqualTo(releaseInfo.getTagName());
        Assertions.assertThat(result.getLatestReleaseNote()).isEqualTo(releaseInfo.getBody());
    }


    @Test
    @DisplayName("Should get dummy version when in dev profile")
    void shouldGetDummyVersionWhenInDevProfile() throws IOException, InterruptedException {
        this.systemVersionService = new SystemVersionService(version, "dev", gitHubSystemVersionService);
        final SystemVersionInfo result = systemVersionService.getLatestVersion();

        Assertions.assertThat(result.getCurrentVersion()).isEqualTo(version);
        Assertions.assertThat(result.isLatest()).isTrue();
        Assertions.assertThat(result.getLatestReleaseNote()).isEqualTo("This is a dummy release note");
        Mockito.verify(gitHubSystemVersionService, Mockito.never()).getLatestVersion();
    }
}
