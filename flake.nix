{
  description = "Custom SKK dictionaries overlay with extended dictionary sources";

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
        # 外部ソースの定義
        skkDictSources = final.callPackage ./pkgs/default.nix { };

        # skk-dictsの拡張版
        skk-dicts-extended =
          if prev ? skk-dicts then
            # skk-dictsが存在する場合は拡張
            prev.skk-dicts.overrideAttrs (oldAttrs: {
              pname = "skk-dicts-extended";
              version = "${oldAttrs.version or "unstable"}-custom";

              meta = (oldAttrs.meta or {}) // {
                description = "SKK dictionaries with additional dictionaries from skk-dev, jawiki, and other sources";
                longDescription = ''
                  Extended SKK dictionaries including:
                  - Standard SKK-JISYO dictionaries from skk-dev
                  - Wikipedia-based jawiki dictionary
                  - Website, idiom, and error correction dictionaries
                '';
                maintainers = (oldAttrs.meta.maintainers or []);
              };

              nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ final.nkf ];

              postInstall = (oldAttrs.postInstall or "") + ''
                echo "Installing extended SKK dictionaries..."

                # skk-devからの標準辞書（EUC-JP）
                for dict in L assoc edict2 fullname geo hukugougo jinmei propernoun requested station; do
                  src_file="${final.skkDictSources.skk-dev}/SKK-JISYO.$dict"
                  if [ -f "$src_file" ]; then
                    echo "  Installing SKK-JISYO.$dict (EUC-JP)"
                    install -Dm644 "$src_file" "$out/share/skk/SKK-JISYO.$dict"
                  else
                    echo "  Warning: SKK-JISYO.$dict not found, skipping"
                  fi
                done

                # jawiki辞書（UTF-8 -> EUC-JP変換）
                if [ -f "${final.skkDictSources.jawiki}/SKK-JISYO.jawiki" ]; then
                  echo "  Installing SKK-JISYO.jawiki (converting UTF-8 to EUC-JP)"
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.jawiki}/SKK-JISYO.jawiki" > "$out/share/skk/SKK-JISYO.jawiki"
                  chmod 644 "$out/share/skk/SKK-JISYO.jawiki"
                fi

                # stg73辞書（UTF-8 -> EUC-JP変換）
                if [ -f "${final.skkDictSources.stg73}/website.skk" ]; then
                  echo "  Installing SKK-JISYO.website (converting UTF-8 to EUC-JP)"
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/website.skk" > "$out/share/skk/SKK-JISYO.website"
                  chmod 644 "$out/share/skk/SKK-JISYO.website"
                fi
                if [ -f "${final.skkDictSources.stg73}/idiom.skk" ]; then
                  echo "  Installing SKK-JISYO.idiom (converting UTF-8 to EUC-JP)"
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/idiom.skk" > "$out/share/skk/SKK-JISYO.idiom"
                  chmod 644 "$out/share/skk/SKK-JISYO.idiom"
                fi
                if [ -f "${final.skkDictSources.stg73}/wrong.skk" ]; then
                  echo "  Installing SKK-JISYO.wrong (converting UTF-8 to EUC-JP)"
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/wrong.skk" > "$out/share/skk/SKK-JISYO.wrong"
                  chmod 644 "$out/share/skk/SKK-JISYO.wrong"
                fi

                echo "Extended SKK dictionaries installation complete"
              '';
            })
          else
            # skk-dictsが存在しない場合は独自にパッケージを作成
            final.stdenv.mkDerivation {
              pname = "skk-dicts-extended";
              version = "unstable";

              dontUnpack = true;

              nativeBuildInputs = [ final.nkf ];

              installPhase = ''
                mkdir -p $out/share/skk

                echo "Installing SKK dictionaries..."

                # skk-devからの標準辞書（EUC-JP）
                for dict in L assoc edict2 fullname geo hukugougo jinmei propernoun requested station; do
                  src_file="${final.skkDictSources.skk-dev}/SKK-JISYO.$dict"
                  if [ -f "$src_file" ]; then
                    echo "  Installing SKK-JISYO.$dict (EUC-JP)"
                    install -Dm644 "$src_file" "$out/share/skk/SKK-JISYO.$dict"
                  fi
                done

                # jawiki辞書（UTF-8 -> EUC-JP変換）
                if [ -f "${final.skkDictSources.jawiki}/SKK-JISYO.jawiki" ]; then
                  echo "  Installing SKK-JISYO.jawiki (converting UTF-8 to EUC-JP)"
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.jawiki}/SKK-JISYO.jawiki" > "$out/share/skk/SKK-JISYO.jawiki"
                  chmod 644 "$out/share/skk/SKK-JISYO.jawiki"
                fi

                # stg73辞書（UTF-8 -> EUC-JP変換）
                if [ -f "${final.skkDictSources.stg73}/website.skk" ]; then
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/website.skk" > "$out/share/skk/SKK-JISYO.website"
                  chmod 644 "$out/share/skk/SKK-JISYO.website"
                fi
                if [ -f "${final.skkDictSources.stg73}/idiom.skk" ]; then
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/idiom.skk" > "$out/share/skk/SKK-JISYO.idiom"
                  chmod 644 "$out/share/skk/SKK-JISYO.idiom"
                fi
                if [ -f "${final.skkDictSources.stg73}/wrong.skk" ]; then
                  ${final.nkf}/bin/nkf -e "${final.skkDictSources.stg73}/wrong.skk" > "$out/share/skk/SKK-JISYO.wrong"
                  chmod 644 "$out/share/skk/SKK-JISYO.wrong"
                fi
              '';

              meta = with final.lib; {
                description = "Extended SKK dictionaries collection";
                license = licenses.gpl2Plus;
                platforms = platforms.all;
              };
            };

        # 互換性のためのエイリアス
        skk-dicts = final.skk-dicts-extended;
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
          default = pkgs.skk-dicts-extended;
          skk-dicts-extended = pkgs.skk-dicts-extended;
        });

      # NixOSモジュール
      nixosModules.default = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [ self.overlays.default ];
      };

      # 開発シェル
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "skk-dicts-dev";
            buildInputs = with pkgs; [
              nix-prefetch-git
              git
            ];
            shellHook = ''
              echo "SKK Dictionaries Development Shell"
              echo "Use 'nix-prefetch-git' to update source hashes"
              echo ""
              echo "Example:"
              echo "  nix-prefetch-git https://github.com/skk-dev/dict"
            '';
          };
        });
    };
}
