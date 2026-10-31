// public/serviceworker.js - Service worker for Web Push Notifications & Offline Caching in Radios FBL

self.addEventListener('install', function(event) {
  self.skipWaiting();
});

self.addEventListener('activate', function(event) {
  event.waitUntil(self.clients.claim());
});

// Push notification event listener (for Web Push payloads)
self.addEventListener('push', function(event) {
  var data = {};
  if (event.data) {
    try {
      data = event.data.json();
    } catch (e) {
      data = { title: 'Radios FBL', body: event.data.text() };
    }
  }

  var title = data.title || 'Radios FBL - Nueva Notificación';
  var options = {
    body: data.body || 'Tienes una nueva actualización en tu actividad.',
    icon: data.icon || 'https://i.postimg.cc/76tbpCkS/Copy-of-Clean-Modern-App-Portfolio-Mockup-Presentation-2.png',
    badge: data.badge || 'https://i.postimg.cc/76tbpCkS/Copy-of-Clean-Modern-App-Portfolio-Mockup-Presentation-2.png',
    data: {
      url: data.url || '/activity'
    },
    vibrate: [200, 100, 200],
    tag: data.tag || 'rfbl-notification'
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

// Click on push notification
self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  var targetUrl = (event.notification.data && event.notification.data.url) || '/activity';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
      for (var i = 0; i < clientList.length; i++) {
        var client = clientList[i];
        if (client.url.indexOf(targetUrl) !== -1 && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});
