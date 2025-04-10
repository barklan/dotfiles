const noproxy = [
    "almatel.ru",
    "mosenergosbyt.ru",
    "mos.ru",
    "192.168.0.1",
    "yandex.ru",
    "yandex.com",
    "yandex.net",
];

function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, ".onion")) {
        return "SOCKS5 127.0.0.1:9050";
    }

    for (const domain of noproxy) {
        if (dnsDomainIs(host, domain)) {
            return "DIRECT";
        }
    }

    // if (weekdayRange("MON", "FRI") === true && timeRange(10, 20) === true) {
    //     return "SOCKS5 127.0.0.1:1080";
    // }

    return "SOCKS5 127.0.0.1:1080";
}
