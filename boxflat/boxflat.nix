{ python3, fetchFromGitHub, gtk4, libadwaita, python3Packages
, gobject-introspection, wrapGAppsHook }:

python3Packages.buildPythonPackage rec {
  pname = "boxflat";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Lawstorant";
    repo = "boxflat";
    rev = "tags/v${version}";
    hash = "sha256-MD5cf8/tu5feyjGpFTpGTThhbKwMHKG3ISTWS6sOlDQ=";
  };

  patches = [ ./entrypoint-fix.patch ];

  format = "setuptools";

  propagatedBuildInputs = [
    gtk4
    libadwaita
    python3Packages.pyyaml
    python3Packages.pyserial
    python3Packages.pycairo
    python3Packages.pygobject3
  ];
  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
      name='boxflat',
      packages=['boxflat', 'boxflat.panels', 'boxflat.widgets'],
      version='${version}',
      install_requires=install_requires,
      entry_points={
        # example: file some_module.py -> function main
        'console_scripts': ['boxflat=boxflat.entrypoint:main']
      },
    )
    EOF
  '';

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest
    runHook postCheck
  '';

  preInstall = ''
    mkdir -p "$out/usr/share/boxflat"
    cp -r ./data "$out/usr/share/boxflat/"
  '';

  postInstall = ''
    wrapProgram "$out/bin/boxflat" --add-flags "--data-path $out/usr/share/boxflat/data"
  '';
}
