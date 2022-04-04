{ pkgs }:
/*
   mkDoc returns a derivation with the given name whose source code is
   located at src. The derivation compiles ${src}/${inFile}.tex
   to create a PDF file which is placed at $out/${outFile}.pdf.
   mkDoc assumes that the LaTeX source file can be compiled using
   a standardized set of dependencies.
*/
name: src: inFile: outFile:
  with pkgs;
  let deps = [ (texlive.combine { inherit (texlive) scheme-basic amsmath graphics hyperref pgf; }) ];
  in
    stdenv.mkDerivation {
      name = name;
      src = src;
      buildInputs = deps;
      buildPhase = ''
        mkdir -p $out
        HOME=./. pdflatex ${inFile}.tex
        HOME=./. pdflatex ${inFile}.tex
        HOME=./. pdflatex ${inFile}.tex
        cp ${inFile}.pdf "$out/${outFile}.pdf"
      '';
      installPhase = ''
        echo done
      '';
    }
