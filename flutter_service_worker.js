/**
 * Kendini imha eden service worker.
 *
 * Site eskiden Flutter Web ile yayınlanıyordu ve `flutter_service_worker.js`
 * kaydediyordu. O ziyaretçilerin tarayıcısında bu worker hâlâ aktif ve eski
 * uygulamayı önbellekten sunmaya devam ediyor — yeni statik site deploy edilse
 * bile onlar eski sayfayı görür.
 *
 * Bu dosya aynı yolda durarak tarayıcının güncelleme kontrolünde devreye girer,
 * tüm önbellekleri siler, kendini kaydından düşürür ve açık sekmeleri yeniler.
 *
 * Eski ziyaretçi kalmadığından emin olunduğunda (birkaç ay sonra) silinebilir.
 */

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(keys.map((key) => caches.delete(key)));

      await self.registration.unregister();

      const clients = await self.clients.matchAll({ type: 'window' });
      for (const client of clients) {
        client.navigate(client.url);
      }
    })(),
  );
});

// Hiçbir isteği yakalama — her şey doğrudan ağdan gelsin.
self.addEventListener('fetch', () => {});
