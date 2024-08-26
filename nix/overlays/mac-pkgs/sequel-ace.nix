{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "sequel-ace";

  version-major =
    rec {
      aarch64-darwin = "4.1.1";
      x86_64-darwin = aarch64-darwin;
    }
    .${system} or throwSystem;
  
  version-second = "20070"

  sha256 =
    rec {
      aarch64-darwin = "sha256-8KPYzIZ1jiL5Z5DFnMRJ0a/W6C554GhNllYY5xz5Lkw=";
      x86_64-darwin = aarch64-darwin;
    }
    .${system} or throwSystem;

  srcs =
    let
      base = "https://github.com/Sequel-Ace/Sequel-Ace/releases/download/production/";
    in
    rec {
      aarch64-darwin = {
        url = "${base}/${version-major}-${version-second}/Sequel-Ace-${version-major}.zip";
        sha256 = sha256;
      };
      x86_64-darwin = aarch64-darwin;
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "MySQL/MariaDB database management";
    homepage = "https://github.com/Sequel-Ace/Sequel-Ace";
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  appname = "Sequel Ace";

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];
    buildInputs = [ unzip ];
    unpackCmd = ''
      echo "File to unpack: $curSrc"
      if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
      mnt=$(mktemp -d -t ci-XXXXXXXXXX)

      function finish {
        echo "Detaching $mnt"
        /usr/bin/hdiutil detach $mnt -force
        rm -rf $mnt
      }
      trap finish EXIT

      echo "Attaching $mnt"
      /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

      echo "What's in the mount dir"?
      ls -la $mnt/

      echo "Copying contents"
      shopt -s extglob
      DEST="$PWD"
      (cd "$mnt"; cp -a !(Applications) "$DEST/")
    '';
    
    phases = [
      "unpackPhase"
      "installPhase"
    ];

    sourceRoot = "${appname}.app";

    installPhase = ''
      mkdir -p "$out/Applications/${appname}.app"
      cp -a ./. "$out/Applications/${appname}.app/"
    '';
  };
in
darwin