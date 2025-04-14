{ stdenv, lib, fetchFromGitHub, rustPlatform, nixosTests

, cmake, installShellFiles, makeWrapper, ncurses, pkg-config, python3, scdoc

, expat, fontconfig, freetype

# Darwin Frameworks
, AppKit, CoreGraphics, CoreServices, CoreText, Foundation, libiconv, OpenGL }:
let
  rpathLibs = [ expat fontconfig freetype ];
  icnsrc = ./Alacritty.icns;
in rustPlatform.buildRustPackage rec {
  pname = "alacritty";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MrlzAZWLgfwIoTdxY+fjWbrv7tygAjnxXebiEgwOM9A=";
  };

  cargoHash = "sha256-7HPTELRlmyjj7CXNbgqrzxW548BgbxybWi+tT3rOCX0=";

  nativeBuildInputs =
    [ cmake installShellFiles makeWrapper ncurses pkg-config python3 scdoc ];

  buildInputs = rpathLibs
    ++ [ AppKit CoreGraphics CoreServices CoreText Foundation libiconv OpenGL ];

  outputs = [ "out" "terminfo" ];

  checkFlags = [ "--skip=term::test::mock_term" ]; # broken on aarch64

  postInstall = (''
    		mkdir $out/Applications
    		cp -r extra/osx/Alacritty.app $out/Applications
    		mv $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns.bak
    		cp ${icnsrc} $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
    		ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS

        installShellCompletion --zsh extra/completions/_alacritty
        installShellCompletion --bash extra/completions/alacritty.bash
        installShellCompletion --fish extra/completions/alacritty.fish

        install -dm 755 "$out/share/man/man1"
        install -dm 755 "$out/share/man/man5"

        scdoc < extra/man/alacritty.1.scd | gzip -c > $out/share/man/man1/alacritty.1.gz
        scdoc < extra/man/alacritty-msg.1.scd | gzip -c > $out/share/man/man1/alacritty-msg.1.gz
        scdoc < extra/man/alacritty.5.scd | gzip -c > $out/share/man/man5/alacritty.5.gz
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > $out/share/man/man5/alacritty-bindings.5.gz

        install -dm 755 "$terminfo/share/terminfo/a/"
        tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
        mkdir -p $out/nix-support
        echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '');

  dontPatchELF = true;

  passthru.tests.test = nixosTests.terminal-emulators.alacritty;

  meta = with lib; {
    description = "Cross-platform, GPU-accelerated terminal emulator";
    homepage = "https://github.com/alacritty/alacritty";
    license = licenses.asl20;
    mainProgram = "alacritty";
    maintainers = with maintainers; [ Br1ght0ne mic92 ];
    platforms = platforms.unix;
    changelog =
      "https://github.com/alacritty/alacritty/blob/v${version}/CHANGELOG.md";
  };
}
