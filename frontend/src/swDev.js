export default function swDev() {
    const swUrl = `${process.env.PUBLIC_URL}/sw.js`;
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register(swUrl)
            .then(registration => {
                registration.active.postMessage({
                    apiURL: window._env_.API_URL,
                    maxCacheAgeDays: window._env_.CACHE_TTL_DAYS,
                });
            })
            .catch(error => {
                console.error('Service Worker registration failed:', error);
            });
    }
}
