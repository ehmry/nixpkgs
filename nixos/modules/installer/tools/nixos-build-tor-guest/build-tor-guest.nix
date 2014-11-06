{ system ? builtins.currentSystem
, configFile
}:

# TODO determine a name for the guest system

let

  pkgs = import <nixpkgs> { inherit system; };

  netCfg =
    { tap = "tortap0";
      br  = "torbr0";
      hostAddr  = "10.90.50.1";
      guestAddr = "10.90.50.2";
      prefixLength = 30; # 1 to 2 takes two bits
    };
  
  guestConfig = (import ../../../../lib/eval-config.nix {
    inherit system;
    modules =
      let extraConfig =
        { virtualisation.qemu.options =
            [ "-net tap,ifname=${netCfg.tap},script=no" ];
          networking.interfaces.eth0 =
            { ipAddress = netCfg.guestAddr;
              inherit (netCfg) prefixLength;
            };
          networking.nameservers = [ netCfg.hostAddr ];
        };
      in [ ../../../virtualisation/qemu-vm.nix extraConfig (import configFile) ];
  }).config;

  guestVM = guestConfig.system.build.vm;

  guestName =
    if guestConfig.networking.hostName == ""
    then "noname"
    else guestConfig.networking.hostName;
  
in

pkgs.stdenv.mkDerivation (netCfg // {
  name = "${guestName}-tor-guest";

  inherit (pkgs) bridge_utils iproute iptables tor;
  inherit guestVM;
    
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup

    hostSh="run-${guestName}-host"
    substituteAll ${./start-tor-host.sh} $hostSh
    chmod +x $hostSh
    installBin $hostSh $guestVM/bin/*
  '';
})
