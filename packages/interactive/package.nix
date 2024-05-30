{ name
, buildDartApplication
, lib
}: buildDartApplication {
  pname = name;
  version = ./version.nix;

  src = ./.;

  pubspecLock = lib.importJSON ./pubspec.lock.json;
}
