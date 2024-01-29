const cacheData = "plant-it-app-v1";
let apiURL;
let maxCacheAgeDays = 7;


this.addEventListener('message', event => {
    if (event.data && event.data.apiURL) {
        apiURL = event.data.apiURL.replace(/\/api$/, '');
    }
    if (event.data && event.data.maxCacheAgeDays) {
        maxCacheAgeDays = Number(event.data.maxCacheAgeDays);
    }
});


this.addEventListener("install", event => {
    event.waitUntil(
        caches.open(cacheData)
            .then(cache => {
                cache.addAll([
                    '/static/js/main.chunck.js',
                    '/static/js/0.chunck.js',
                    '/static/js/bundle.js',
                    '/index.html',
                    '/',
                    '/auth',
                    '/static/js/page-script.js',
                    '/manifest.json',
                    '/env-config.js',
                    '/android-chrome-192x192.png',
                    '/favicon-16x16.png',
                    '/favicon-32x32.png',
                    '/add-custom.jpg',
                    '/login-background.jpg',
                ])
            })
            .catch(console.error)
    )
});


this.addEventListener("fetch", event => {
    const requestUrl = new URL(event.request.url);

    if (event.request.method === 'GET') {
        // If the network is available, fetch from the network and cache the response
        if (navigator.onLine) {
            event.respondWith(
                fetch(event.request)
                    .then(response => {
                        const responseClone = response.clone();
                        caches.open(cacheData)
                            .then(cache => {
                                cache.put(event.request, responseClone);
                            });
                        return response;
                    })
                    .catch(error => {
                        console.error("Error fetching and caching:", error);
                        // If fetching fails, try serving from the cache
                        return caches.match(event.request);
                    })
            );
        } else {
            // If the network is unavailable, serve from the cache
            self.clients.matchAll().then(clients => {
                clients.forEach(client => {
                    client.postMessage({ action: 'showSnackbar' });
                });
            });

            event.respondWith(
                caches.match(event.request)
                    .then(res => {
                        if (res) {
                            return res;
                        }
                    })
            );
        }
    } else {
        // For non-GET requests, proceed with the default behavior
        event.respondWith(fetch(event.request));
    }
});



const cleanupCache = async () => {
    const maxAgeMillis = maxCacheAgeDays * 24 * 60 * 60 * 1000;
    const now = Date.now();

    return caches.open(cacheData).then(cache => {
        return cache.keys().then(keys => {
            return Promise.all(keys.map(key => {
                return cache.match(key).then(response => {
                    if (response) {
                        const lastModified = new Date(response.headers.get('last-modified')).getTime();
                        const age = now - lastModified;

                        if (age > maxAgeMillis) {
                            return cache.delete(key);
                        }
                    }
                });
            }));
        });
    });
}

setInterval(cleanupCache, 24 * 60 * 60 * 1000); // Run every 24 hours
