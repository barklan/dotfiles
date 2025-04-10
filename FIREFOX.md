# Firefox

Also enable webrender.all and force-enable compositor.
Also open profile folder and put `chrome` in there.
Firefox with `widget.wayland.fractional-scale.enabled` seems to work now.

## Extensions

- Firefox Multi-Account Containers
- Temporary containers
- Plasma Integration
- uBlock Origin (be careful with filters - some of them will block bfcache)
- Violentmonkey
- Cache Longer
- SponsorBlock

You might need to delete other firefox profiles for plasma-browser-integration "bookmarks" feature.

## Pac

Add proxy auto configuration:

```txt
file:///home/barklan/sys/torify.pac
```

### Options

```ini
media.peerconnection.enabled = false # webrtc (leaks ip with proxy)

gfx.webrender.all = true
gfx.webrender.compositor = true
gfx.webrender.compositor.force-enabled = true

# Disable DRM
media.eme.enabled = false
browser.eme.ui.enabled = false

# smoother scrolling
layers.acceleration.force-enabled = true
layers.force-active = true

browser.tabs.allowTabDetach = false
layout.css.devPixelsPerPx = 1.35  # (adjust for screen size)
browser.uidensity = 1 (makes ui denser)
toolkit.legacyUserProfileCustomizations.stylesheets = true (?)
ui.key.menuAccessKeyFocuses = false
middlemouse.paste = false (?)
full-screen-api.warning.timeout = 0
apz.gtk.touchpad_pinch.enabled = false  # pinch zoom with touchpad like on phone
accessibility.force_disabled = 1
browser.sessionstore.restore_on_demand = false  # load all tabs when restoring session
browser.tabs.tabMinWidth = 50 (50 is minimum possible value)
toolkit.tabbox.switchByScrolling = true
browser.tabs.insertAfterCurrent = true
mousewheel.with_control.action = 0
extensions.pocket.enabled = false
browser.tabs.closeWindowWithLastTab = false

media.ffmpeg.vaapi.enabled = true
media.hardware-video-decoding.force-enabled = true

<!-- browser.cache.disk.enable = true -->
<!-- browser.cache.disk.parent_directory = /run/user/1000/firefox -->
<!-- browser.cache.disk.capacity = 512000 -->
<!-- browser.cache.disk.smart_size.enabled = false -->
<!-- browser.cache.memory.capacity = 1048576 -->
browser.cache.memory.max_entry_size = 81920

browser.sessionstore.interval = 60000 (60 seconds)
dom.ipc.processCount = ?

// sharing indicator
privacy.webrtc.legacyGlobalIndicator = false
privacy.webrtc.hideGlobalIndicator = true

widget.gtk.overlay-scrollbars.enabled = true

content.notify.interval = 120000 (default, 120 milliseconds to redraw) (?)

network.predictor.enable-hover-on-ssl = true
network.dns.disablePrefetchFromHTTPS = false
network.predictor.enable-prefetch = true

// Scrolling
mousewheel.min_line_scroll_amount = 10 (8 for now)
general.smoothScroll.mouseWheel.durationMinMS = 80
general.smoothScroll.currentVelocityWeighting = 0.15
general.smoothScroll.stopDecelerationWeighting = 0.6 (0.7 for now)

narrate.enabled = false
widget.use-xdg-desktop-portal.file-picker = 1
media.hardwaremediakeys.enabled = false  # only if plasma-browser-integration is enabled
browser.tabs.firefox-view = false

// urlbar
browser.urlbar.groupLabels.enabled = false
browser.urlbar.resultMenu = false


// Experimental
browser.sessionhistory.max_total_viewers = 16 (default -1)
network.dnsCacheExpiration = 600

privacy.reduceTimerPrecision = false # lichess issue?
widget.wayland.fractional-scale.enabled = true

browser.urlbar.showSearchTerms.featureGate = true
ui.prefersReducedMotion = 1
dom.serviceWorkers.enabled = false
cookiebanners.service.mode = 2
cookiebanners.service.mode.privateBrowsing = 2
app.normandy.enabled = false
browser.preferences.moreFromMozilla = false
browser.aboutwelcome.enabled = false
widget.gtk.hide-pointer-while-typing.enabled = false
browser.tabs.loadBookmarksInTabs = true
ui.tooltip.delay_ms = 100
network.captive-portal-service.enabled = false
network.notify.checkForProxies = false
```

Experimental:

```txt
network.predictor.preconnect-min-confidence = 20
network.predictor.prefetch-min-confidence = 30
network.predictor.prefetch-force-valid-for = 3600
network.predictor.preresolve-min-confidence = 10

browser.cache.check_doc_frequency = 2

network.http.pacing.requests.min-parallelism = 10
network.http.pacing.requests.burst = 14
```

More experimental:

```txt
network.predictor.preconnect-min-confidence = 20
network.predictor.prefetch-force-valid-for = 3600
network.predictor.prefetch-min-confidence = 30
network.predictor.prefetch-rolling-load-count = 120
network.predictor.preresolve-min-confidence = 10
```

Make firefox fast again:

[https://gist.github.com/RubenKelevra/fd66c2f856d703260ecdf0379c4f59db]

## Ublock

Additional blocklists:

```txt
https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt
https://www.i-dont-care-about-cookies.eu/abp/
https://big.oisd.nl/
https://easylist-downloads.adblockplus.org/cntblock.txt
https://raw.githubusercontent.com/barklan/ubo-extra-list/main/main.txt
https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt
```

## Chrome

`<profile_dir>/chrome/userChrome.css`

```css
/* Hide status bar links */
#statuspanel {
  display: none !important;
}

/* Hide back and forward buttons */
#back-button {
  display: none !important;
}
#forward-button {
  display: none !important;
}

/* Smaller items in bookmark popups. */
menupopup:not(.in-menulist) > menuitem,
menupopup:not(.in-menulist) > menu {
  padding-block: 2px !important;
}
:root {
  --arrowpanel-menuitem-padding: 4px 8px !important;
}

/* Hide close button */
.tab-close-button {
  display: none !important;
}

/* Set minimum tab width - displays only icons.  */
.tabbrowser-tab[fadein]:not([pinned]) {
  min-width: 35px !important;
}

#alltabs-button {
    display: none !important;
}

#tabs-newtab-button { display:none!important; }

/* #sidebar-main:not(:hover){width: 100px !important;} */

sidebar-main[expanded] {
  width: 170px !important;
}

sidebar-main[expanded] #vertical-tabs {
  width: 176px !important;
}
```
