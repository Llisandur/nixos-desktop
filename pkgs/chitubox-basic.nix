{ stdenv, lib, requireFile, buildFHSEnv, icoutils, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "chitubox-basic";
  version = "2.3.1";

  src = requireFile {
    name = "CHITUBOX_Basic_linux_Installer_2.3.1.run";
    sha256 = "397e058de53b692e1db61657929e1ce9f88f090cb973c8c20fde5b0d4dfa6268";
    message = ''
      Please download CHITUBOX Basic 2.3.1 from:
      https://www.chitubox.com/en/download/chitubox-free
      and place it in the Nix store using `nix-store --add-fixed sha256`.
    '';
  };

  dontUnpack = true;

  nativeBuildInputs = [ icoutils makeWrapper ];

  installPhase = ''
    runHook preInstall

    echo "Copying installer..."
    cp $src ./installer.run
    chmod +x ./installer.run

    echo "Creating output path..."
    mkdir -p $out/opt

    echo "Running installer in FHS environment..."
    ${buildFHSEnv {
      name = "fhs-chitubox-extract";
      targetPkgs = pkgs: with pkgs; [
        glibc
        libGLU
        libGL
        zlib
        libxkbcommon # libxkbcommon-x11.so
        xorg.libxcb # libxcb-util.so
        xorg.xcbutilwm # libxcb-icccm.so
        xorg.xcbutilimage # libxcb-image.so
        xorg.xcbutilkeysyms # libxcb-keysyms.so
        xorg.xcbutilrenderutil # libxcb-render-util.so
        xorg.libX11 # libX11-xcb.so
        freetype # libfreetype.so
        fontconfig # libfontconfig.so
        dbus # libdbus-1.so
        zstd # libzstd.so
      ];
      runScript = ''
        ./installer.run \
          --root $out/opt/CHITUBOX_Basic \
          --accept-licenses \
          --no-size-checking \
          --accept-messages \
          --confirm-command install
      '';
    }}/bin/fhs-chitubox-extract

    echo "Linking executable..."
    mkdir -p $out/bin
    makeWrapper $out/opt/CHITUBOX_Basic/CHITUBOX_Basic.sh $out/bin/chitubox-basic \
      --set QT_QPA_PLATFORM xcb

    echo "Extracting icon..."
    icotool --extract $out/opt/CHITUBOX_Basic/bin/Resources/Image/SoftwareIcon/freeIcon.ico --output .
    install -Dm644 freeIcon_1_256x256x32.png $out/share/icons/hicolor/256x256/apps/chitubox-basic.png

    echo "Installing .desktop file..."
    mkdir -p $out/share/applications
    cat > $out/share/applications/chitubox-basic.desktop <<EOF
[Desktop Entry]
Name=CHITUBOX Basic
Exec=chitubox-basic
Icon=chitubox-basic
Type=Application
Categories=Graphics;
MimeType=application/stl;application/ctb;
EOF

    echo "Installing license..."
    install -Dm644 $out/opt/CHITUBOX_Basic/Licenses/LICENSE.txt $out/share/licenses/${pname}/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "CHITUBOX Basic - 3D printing slicer";
    homepage = "https://www.chitubox.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
