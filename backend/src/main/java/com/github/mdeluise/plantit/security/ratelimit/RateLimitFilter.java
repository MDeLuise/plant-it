package com.github.mdeluise.plantit.security.ratelimit;

import java.io.IOException;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.exception.error.ErrorCode;
import com.github.mdeluise.plantit.exception.error.ErrorMessage;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class RateLimitFilter extends OncePerRequestFilter {
    private final int perMinute;
    private final ObjectMapper objectMapper;
    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();


    public RateLimitFilter(@Value("${server.rateLimit.requestPerMinute}") int perMinute, ObjectMapper objectMapper) {
        this.perMinute = perMinute;
        this.objectMapper = objectMapper;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
        throws ServletException, IOException {
        final String clientIP = getClientIP(request);
        final Bucket bucket = buckets.computeIfAbsent(clientIP, k -> {
            final Bandwidth limit = Bandwidth.builder()
                                             .capacity(perMinute)
                                             .refillIntervally(perMinute, Duration.ofMinutes(1))
                                             .build();
            return Bucket.builder().addLimit(limit).build();
        });

        final ConsumptionProbe consumptionProbe = bucket.tryConsumeAndReturnRemaining(1);
        if (!consumptionProbe.isConsumed()) {
            sendError(response);
            return;
        }
        response.addHeader("X-Rate-Limit-Remaining", Long.toString(consumptionProbe.getRemainingTokens()));
        filterChain.doFilter(request, response);
    }

    private String getClientIP(HttpServletRequest request) {
        final String xForwardedForHeader = request.getHeader("X-Forwarded-For");
        if (xForwardedForHeader != null) {
            return xForwardedForHeader.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    private void sendError(HttpServletResponse response) throws IOException {
        final ErrorMessage error = new ErrorMessage(
            HttpStatus.TOO_MANY_REQUESTS.value(),
            ErrorCode.TOO_MANY_REQUESTS,
            "Request rate limit exceeded"
        );
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }
}
