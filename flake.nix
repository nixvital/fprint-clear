{
  description = "Clear the fprintd storage the easy way";

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

            ctx = FPrint.Context()

            for dev in ctx.get_devices():
                print(f"{dev} {dev.props.device_id}: Drive = ({dev.get_driver()})")
                dev.open_sync()
                dev.clear_storage_sync()
                print(f"[ok] All prints deleted for {dev.props.device_id}")
                dev.close_sync()
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
