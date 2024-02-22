package com.github.mdeluise.plantit.systeminfo;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class SystemVersionService {
    private final GitHubSystemVersionService gitHubSystemVersionService;
    private final String activeProfiles;
    private final String version;
    private final Logger logger = LoggerFactory.getLogger(SystemVersionService.class);


    @Autowired
    public SystemVersionService(@Value("${app.version}") String version,
                                @Value("${spring.profiles.active:unknown}") String activeProfiles,
                                GitHubSystemVersionService gitHubSystemVersionService) {
        this.gitHubSystemVersionService = gitHubSystemVersionService;
        this.activeProfiles = activeProfiles;
        this.version = version;
    }


    @Cacheable(value = "latest-version")
    public SystemVersionInfo getLatestVersion() throws IOException, InterruptedException {
        final SystemVersionInfo result = new SystemVersionInfo();
        result.setCurrentVersion(version);
        if (isDevProfileActive()) {
            logger.debug("retrieve a dummy system version info.");
            result.setLatest(true);
            result.setLatestReleaseNote("This is a dummy release note");
        } else {
            logger.debug("retrieve the system version info from GitHub.");
            final GitHubReleaseInfo latestGithubVersion = gitHubSystemVersionService.getLatestVersion();
            result.setLatestVersion(latestGithubVersion.getTagName());
            result.setLatestReleaseNote(latestGithubVersion.getBody());
            result.setLatest(version.equals(latestGithubVersion.getTagName()));
        }
        return result;
    }


    private boolean isDevProfileActive() {
        final String[] profileArray = activeProfiles.split(",");
        for (String profile : profileArray) {
            if ("dev".equals(profile.trim())) {
                return true;
            }
        }
        return false;
    }
}
