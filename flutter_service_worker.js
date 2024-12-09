'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"main.dart.js": "27ac3505dc28612e8a2d0f3e4dc2fb23",
"bootpay_api.js": "4c4983604f0046a236988fb920bef062",
"assets/FontManifest.json": "18a9bfd341ebd11e0095d11001ed3ee1",
"assets/AssetManifest.bin": "c505af0913ddd45068161edaba692211",
"assets/fonts/NotoSansKR-Medium.ttf": "4dee649c78a37741c4f5d9fdb69ea434",
"assets/fonts/NotoSansKR-Black.ttf": "15e2e9d1b8e380eafc51a606a7e671d6",
"assets/fonts/NotoSansKR-Light.ttf": "e61301e66b058697c6031c39edb7c0d2",
"assets/fonts/NotoSansKR-Bold.ttf": "671db5f821991c90d7f8499bcf9fed7e",
"assets/fonts/Roboto.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/fonts/NotoSansKR-Thin.ttf": "b59719d81a60f284b7c372c7891689fd",
"assets/fonts/MaterialIcons-Regular.otf": "a1347ef3ee0d55affb0f65812ad95bd6",
"assets/fonts/NotoSansKR-Regular.ttf": "e910afbd441c5247227fb4a731d65799",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/youtube_player_iframe/assets/player.html": "ea69af402f26127fa4991b611d4f2596",
"assets/packages/timezone/data/latest_all.tzf": "871b8008607c14f36bae2388a95fdc8c",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/assets/images/logo.jpg": "27199bce97233e9a9c2a8eddcbaf0e29",
"assets/assets/images/small_logo.png": "a5e681c8fb2e036ad4d83673cff5b6e1",
"assets/assets/images/bg3.gif": "5df9da041119437ef8759c9450529263",
"assets/assets/images/small_logo2.jpg": "0ff709b1e330db2bff374d0ea9a80148",
"assets/assets/images/skypeid_help_3.png": "3c594845bed63b36f9aac43fc4f3e7fa",
"assets/assets/images/home-1.jpg": "fd5e741d4fc493943ef784da025bbee3",
"assets/assets/images/price2.png": "37074c994f35cf0d6618af2cd18b5ed6",
"assets/assets/images/price.jpg": "9bf748831fdf1a953d6fe2833ea23f4a",
"assets/assets/images/bg.mp4": "01aee05df3770712d94b4c2dc2c86cdd",
"assets/assets/images/bg.jpg": "a47be4a14d12da2d8db7b932a8fbfd83",
"assets/assets/images/price1.png": "7086b3dbc91795a8cfc5933613341057",
"assets/assets/images/bg.gif": "881def9b087ac9aafd8a0ee1f5f568fe",
"assets/assets/images/KakaoTalk_20240703_230007660_02.jpg": "5bef14515cc758d82ddf227d37231346",
"assets/assets/images/(%25EC%259B%25B9%25EC%2582%25AC%25EC%259D%25B4%25ED%258A%25B8%2520%25EC%259A%25A9)%2520%25EB%25B0%25B0%25EA%25B2%25BD%2520%25EC%25A0%259C%25EA%25B1%25B0%2520%25EA%25B0%2580%25EA%25B2%25A9%25ED%2591%259C.png": "021f8c6eae26f97e9d1523d1a1ccb6b0",
"assets/assets/images/KakaoTalk_20240703_230007660.jpg": "8a6d4ddc5dd09ad2a272df023007d3d3",
"assets/assets/images/kakao_talk.png": "1ebcbc6e4d87d19a8b3e1cbb18e55cb6",
"assets/assets/images/skypeid_help_2.png": "e70cb3ca83bee3b84ff60599b05bd828",
"assets/assets/images/bg2.gif": "79c4e2528882afe55ecf056f6e3cd3ac",
"assets/assets/images/price2_bkup.png": "c55b22b9999c2fbd497da5ec3cc140d5",
"assets/assets/images/kakao_talk2.png": "f79318fa183c94bdde913190c6e389a5",
"assets/assets/images/small_logo.jpg": "c6be9d523f494cb6c493c98461de48da",
"assets/assets/images/download.gif": "5a34135d390945822a0f9e198a9fa496",
"assets/assets/images/tutors/Red.png": "d76e8fd536c45d769d1acad58344b822",
"assets/assets/images/tutors/Red2.png": "f6ce39ec9209d9364d00f43709dc2599",
"assets/assets/images/skypeid_help_1.png": "88ababbf8d9651f10897e0ddecd04488",
"assets/assets/images/price3.png": "a8d1bbe0407378b93dfb7460874ea1aa",
"assets/assets/images/founder_book.png": "3f25c16755afa959b0f2785e90a0742a",
"assets/assets/images/price.png": "21738d987dcbb08f911c4e25dcb74432",
"assets/assets/images/KakaoTalk_20240703_230007660_01.jpg": "4daaf67b51d34ac0abfb181623ab7fb2",
"assets/NOTICES": "4417fc01787922d16fdd7c6d462a64de",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "3295c02ff0884c4a8a81c74c4609abd1",
"assets/AssetManifest.bin.json": "c2a1a98c37eb3a1d9d3de02eae0ccb27",
"index.html": "f71b3290937a07217dab806ba7a1237a",
"/": "f71b3290937a07217dab806ba7a1237a",
"manifest.json": "d09507c21eb4e1b72cdb4e875254cb2b",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "249e1884f03cb41f236bed8a93126ce7",
"flutter_bootstrap.js": "337c27c39d9d5a328d9e050cab8b190d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
