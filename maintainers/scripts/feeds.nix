# mostly borrowed from ./update.nix, build the feeds like so:
# nix build -f feeds.nix --argstr maintainer foobar --out-link releases.opml

{ maintainer }:

let
  inherit (pkgs) lib;

  maintainer' = if !builtins.hasAttr maintainer lib.maintainers then
    builtins.throw
    "Maintainer with name `${maintainer} does not exist in `maintainers/maintainer-list.nix`."
  else
    builtins.getAttr maintainer lib.maintainers;

  # Remove duplicate elements from the list based on some extracted value. O(n^2) complexity.
  nubOn = list:
    if list == [ ] then
      [ ]
    else
      let
        x = lib.head list;
        xs = lib.filter (y: x != y) (lib.drop 1 list);
      in [ x ] ++ nubOn xs;

  pkgs = import ./../../default.nix { };

  packagesWith = cond: return: set:
    nubOn (lib.flatten (lib.mapAttrsToList (name: pkg:
      let
        result = builtins.tryEval (if lib.isDerivation pkg && cond name pkg then
          [ (return name pkg) ]
        else if pkg.recurseForDerivations or false
        || pkg.recurseForRelease or false then
          packagesWith cond return pkg
        else
          [ ]);
      in if result.success then result.value else [ ]) set));

  hasGithubSrc = pkg:
    lib.hasPrefix "https://github.com/" (pkg.src.meta.homepage or "");

  hasMaintainer = pkg:
    if builtins.hasAttr "maintainers" pkg.meta then
      (if builtins.isList pkg.meta.maintainers then
        builtins.elem maintainer' pkg.meta.maintainers
      else
        maintainer' == pkg.meta.maintainers)
    else
      false;

  githubReleaseFeed = pkg: {
    name = lib.getName pkg;
    description = pkg.meta.description or "";
    feed = pkg.src.meta.homepage + "/releases.atom";
    homepage = pkg.meta.homepage or pkg.src.meta.homepage;
  };

  githubFeeds = packagesWith (name: pkg: hasGithubSrc pkg && hasMaintainer pkg)
    (name: githubReleaseFeed) pkgs;

  toXML = { name, description, feed, homepage }:
    ''<outline text="${name}" type="rss" xmlUrl="${feed}" htmlUrl="${homepage}" description="${description}"/>'';

in pkgs.writeText "${maintainer}.github-releases.opml" (toString ([
  ''<opml version="2.0">''
  "<head>"
  "<ownerName>${maintainer'.name}</ownerName>"
  "<ownerEmail>${maintainer'.email}</ownerEmail>"
  "</head>"
  "<body>"
  ''<outline text="Package releases">''
] ++ map toXML githubFeeds ++ [
  "</outline>"
  "</body>"
  "</opml>"
]))
