{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "universal-pidff-${version}-${kernel.version}";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "universal-pidff";
    rev = "tags/${version}";
    sha256 = "sha256-km1kORERV1Gtg2Ppfd1fNT4rlTomJdJDBCQ4QnuvYgs=";
  };

  patches = [ ./no-depmod.patch ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installTargets = [ "install" ];

  meta = with lib; {
    description =
      "Linux PIDFF driver with useful patches for initialization of FFB devices. Primarily targeting Direct Drive wheelbases.";
    homepage = "https://github.com/JacKeTUs/universal-pidff";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
