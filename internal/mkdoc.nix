{ pkgs }:
name: src: inFile: outFile:
  with pkgs;
  let deps = [ (texlive.combine { inherit (texlive) scheme-basic amsmath graphics hyperref; }) ];
  in
    stdenv.mkDerivation {
      name = name;
      src = src;
      buildInputs = deps;
      buildPhase = ''
        mkdir -p $out
        HOME=./. pdflatex ${inFile}.tex
        HOME=./. pdflatex ${inFile}.tex
        cp ${inFile}.pdf "$out/${outFile}.pdf"
      '';
      installPhase = ''
        echo done
      '';
    };
