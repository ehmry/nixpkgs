{ src
, version
, meta
, lib
, buildMirageUnikernel
, target ? "xen"
# common
, logs
, dns-resolver
, dns-server
, tcpip
, mirage-types-lwt
, mirage-logs
, mirage-crypto-rng-mirage
# unix
, mirage-clock-unix
, mirage-bootvar-unix
# xen
, mirage-net-xen
, num
, mirage-clock-freestanding
, mirage-bootvar-xen
, arp
}:

let
  pname = "stub_resolver";
in

buildMirageUnikernel {
  inherit pname version src target;

  sourceRoot = "${src.name}/${builtins.replaceStrings [ "_" ] [ "-" ] pname}";

  buildInputs = [
    dns-server
    dns-resolver
    logs
    tcpip
    mirage-types-lwt
    mirage-logs
    mirage-crypto-rng-mirage
  ] ++ lib.optionals (target == "unix") [
    mirage-clock-unix
    mirage-bootvar-unix
  ] ++ lib.optionals (target == "xen") [
    num
    mirage-net-xen
    mirage-clock-freestanding
    mirage-bootvar-xen
    arp
  ];

  meta = meta // {
    description = "Recursive resolver to query another resolver";
  };
}
