const cacheData = "plant-it-app-v1";
let apiURL;

this.addEventListener('message', event => {
    if (event.data && event.data.apiURL) {
        apiURL = event.data.apiURL.replace(/\/api$/, '');
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
    if (!navigator.onLine) {

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
    } else {
        const requestUrl = new URL(event.request.url);

        // Cache images from any URL
        if (requestUrl.pathname.match(/\.(jpe?g|png|gif|bmp|svg)$/i)) {
            return fetch(event.request)
                .then(response => {
                    const responseClone = response.clone();
                    caches.open(cacheData)
                        .then(cache => {
                            cache.put(event.request, responseClone);
                        });
                    return response;
                })
                .catch(error => {
                    console.error("Error fetching and caching image:", error);
                });
        }

        // Cache Google Fonts
        if (requestUrl.origin.startsWith('https://fonts.googleapis.com')) {
            return fetch(event.request)
                .then(response => {
                    const responseClone = response.clone();
                    caches.open(cacheData)
                        .then(cache => {
                            cache.put(event.request, responseClone);
                        });
                    return response;
                })
                .catch(error => {
                    console.error("Error fetching and caching Google Font:", error);
                });
        }

        // Cache responses from URLs starting with https://bs.plantnet.org
        if (requestUrl.origin.startsWith('https://bs.plantnet.org')) {
            return fetch(event.request)
                .then(response => {
                    const responseClone = response.clone();
                    caches.open(cacheData)
                        .then(cache => {
                            cache.put(event.request, responseClone);
                        });
                    return response;
                })
                .catch(error => {
                    console.error("Error fetching and caching image from https://bs.plantnet.org:", error);
                });
        }

        // Cache responses from backend URLs
        if (requestUrl.origin.startsWith(apiURL)) {
            return fetch(event.request)
                .then(response => {
                    const responseClone = response.clone();
                    caches.open(cacheData)
                        .then(cache => {
                            cache.put(event.request, responseClone);
                        });
                    return response;
                })
                .catch(error => {
                    console.error("Error fetching backend response:", error);
                });
        }

        // Default behavior if not matched
        return fetch(event.request);
    }
});
