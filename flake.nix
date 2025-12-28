{
  description = "Custom SKK dictionaries overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      # Overlay
      overlays.default = final: prev: {
        # default.nixから外部ソースを取得
        sources = final.callPackage ./pkgs/default.nix { };

        # skk-dictsの定義
        skk-dicts = prev.skk-dicts.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            echo "Adding custom dictionaries..."

            install -m644 ${final.sources.skk-dev}/SKK-JISYO.L \
              $out/share/skk/SKK-JISYO.L
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.assoc \
              $out/share/skk/SKK-JISYO.assoc
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.edict2 \
              $out/share/skk/SKK-JISYO.edict2
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.fullname \
              $out/share/skk/SKK-JISYO.fullname
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.geo \
              $out/share/skk/SKK-JISYO.geo
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.hukugougo \
              $out/share/skk/SKK-JISYO.hukugougo
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.jinmei \
              $out/share/skk/SKK-JISYO.jinmei
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.propernoun \
              $out/share/skk/SKK-JISYO.propernoun
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.requested \
              $out/share/skk/SKK-JISYO.requested
            install -m644 ${final.sources.skk-dev}/SKK-JISYO.station \
              $out/share/skk/SKK-JISYO.station
            install -m644 ${final.sources.jawiki}/SKK-JISYO.jawiki \
              $out/share/skk/SKK-JISYO.jawiki
            install -m644 ${final.sources.stg73}/website.skk \
              $out/share/skk/SKK-JISYO.website
            install -m644 ${final.sources.stg73}/idiom.skk \
              $out/share/skk/SKK-JISYO.idiom
            install -m644 ${final.sources.stg73}/wrong.skk \
              $out/share/skk/SKK-JISYO.wrong
          '';
        });
      };

      # パッケージの出力
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.skk-dicts;
        });
    };
}
