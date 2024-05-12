let pkgs = import (builtins.fetchTarball {
    url =
        https://github.com/nixos/nixpkgs/archive/5c211b47aeadcc178c5320afd4e74c7eed5c389f.tar.gz;
    sha256 = "1r6wj98wb16217g6hsk13qwwpx5zwd1nq4fnx6an6ljmv5mq5mc3";
  }) { config = {}; overlays = [
    ]; };
in

let
  venvDir = "./.venv";
  pythonPackages = pkgs.python310Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  buildInputs = [
    pythonPackages.python
    # Needed when using python 2.7
    # pythonPackages.virtualenv
    # ...
  ];

  # This is very close to how venvShellHook is implemented, but
  # adapted to use 'virtualenv'
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    # if [ -d "${venvDir}" ]; then
      # echo "Skipping venv creation, '${venvDir}' already exists"
    #else
      echo "Creating new venv environment in path: '${venvDir}'"
      # Note that the module venv was only introduced in python 3, so for 2.7
      # this needs to be replaced with a call to virtualenv
      ${pythonPackages.python.interpreter} -m venv "${venvDir}"
    # fi

    # Under some circumstances it might be necessary to add your virtual
    # environment to PYTHONPATH, which you can do here too;
    # PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH

    source "${venvDir}/bin/activate"

    # As in the previous example, this is optional.
    pip install -r requirements.txt
  '';
}
