{ stdenv, fetchFromGitHub, qmake, qtbase, protobuf }:

stdenv.mkDerivation rec {
  pname = "qtpbfimageplugin";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "QtPBFImagePlugin";
    rev = version;
    sha256 = "1w2d33g13vkjasabmcgvhsmfqv3jmwbxhqxm1jnyc7d4nlk4jwmb";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase protobuf ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace pbfplugin.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"

    # Fix darwin build
    substituteInPlace pbfplugin.pro \
      --replace '$$PROTOBUF/lib/libprotobuf-lite.a' '${protobuf}/lib/libprotobuf-lite.dylib'
  '';

  meta = with stdenv.lib; {
    description = "Qt image plugin for displaying Mapbox vector tiles";
    longDescription = ''
      QtPBFImagePlugin is a Qt image plugin that enables applications capable of
      displaying raster MBTiles maps or raster XYZ online maps to also display PBF
      vector tiles without (almost) any application modifications.
    '';
    homepage = "https://github.com/tumic0/QtPBFImagePlugin";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
