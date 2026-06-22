{ self, inputs, ... }:
let
  networkModule =
    { config, pkgs, ... }:
    let
      openvpnDbusService = pkgs.writeTextDir "share/dbus-1/system-services/org.freedesktop.NetworkManager.openvpn.service" ''
        [D-BUS Service]
        Name=org.freedesktop.NetworkManager.openvpn
        Exec=${pkgs.networkmanager-openvpn}/libexec/nm-openvpn-service
        User=root
      '';
    in
    {
      networking.hostName = config.my.host.name;
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
      };
      services.dbus.packages = [ openvpnDbusService ];
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [
        8080
        9090
      ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
    };
in
{
  flake.nixosModules.networkManager = networkModule;
  flake.nixosModules.desktopCasaNetwork = networkModule;
}
