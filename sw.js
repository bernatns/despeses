// Service worker: lets the app open without connection.
// - The app itself (index.html): network first, cached copy as fallback (updates arrive immediately)
// - Versioned CDN files (supabase-js, fonts): cache first
// - Supabase API calls are NEVER cached (data goes through the app's own read-only offline cache)
const CACHE = 'despeses-v5.0';
const SHELL = ['./', './index.html', './manifest.webmanifest', './icon-180.png', './icon-192.png', './icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.hostname.endsWith('supabase.co')) return; // live data: never cache

  const sameOrigin = url.origin === self.location.origin;
  const isCdn = /(^|\.)cdn\.jsdelivr\.net$|(^|\.)fonts\.(googleapis|gstatic)\.com$/.test(url.hostname);

  if (sameOrigin && (req.mode === 'navigate' || url.pathname.endsWith('.html') || url.pathname.endsWith('/'))) {
    e.respondWith(
      fetch(req)
        .then(res => { const copy = res.clone(); caches.open(CACHE).then(c => c.put(req, copy)); return res; })
        .catch(() => caches.match(req).then(r => r || caches.match('./index.html')))
    );
    return;
  }
  if (sameOrigin || isCdn) {
    e.respondWith(
      caches.match(req).then(cached => {
        const net = fetch(req).then(res => {
          if (res.ok || res.type === 'opaque') { const copy = res.clone(); caches.open(CACHE).then(c => c.put(req, copy)); }
          return res;
        }).catch(() => cached);
        return cached || net;
      })
    );
  }
});
