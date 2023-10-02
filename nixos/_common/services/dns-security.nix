{
  services.resolved = {
    enable = true;

    dnssec = "true";
    extraConfig = ''
      DNSOverTLS=yes
    '';
    llmnr = "resolve";
    fallbackDns = [
      "1.1.1.1" # cloudflare.com IPv4 1
      "1.0.0.1" # cloudflare.com IPv4 2
      "2606:4700:4700::1111" # cloudflare.com IPv6 1
      "2606:4700:4700::1001" # cloudflare.com IPv6 2
    ];
  };

  networking.nameservers = [
    "9.9.9.9" # dns.quad9.net
    "149.112.112.112" # dns.quad9.net
    "2620:fe::fe" # dns.quad9.net
    "2620:fe::9" # dns.quad9.net
  ];
}

