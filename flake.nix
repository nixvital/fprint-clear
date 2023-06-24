{
  description = "Collection of my NixOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    devShells."x86_64-linux".default = let pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          fprint-clear = final.writeScriptBin "fprint-clear" ''
            #! /usr/bin/env python3

            import gi
            gi.require_version("FPrint", "2.0")
            from gi.repository import FPrint
          '';
        })
      ];
    }; in pkgs.mkShell {
      packages = with pkgs; [
        (python3.withPackages (p: [ p.pygobject3 ]))
        gusb
        libfprint
        gobject-introspection
        fprint-clear
      ];
    };
  };
}
