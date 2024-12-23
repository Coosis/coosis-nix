{ stdenv
, lib
, fetchurl
, nodejs
}:
stdenv.mkDerivation {
  pname = "solidity-language-server";
  version = "0.8.7";

	nativeBuildInputs = [ nodejs ];

  src = fetchurl {
		url = "https://registry.npmjs.org/@nomicfoundation/coc-solidity/-/coc-solidity-0.8.7.tgz";
		sha256 = "sha256-7bKAgkbpElc7PXt9KYikV/mmeVRCGpMX6FtsTN4vvl4=";
  };

	unpackPhase = ''
		tar -xf $src
	'';

	buildPhase = ''
		npm install
	'';

  installPhase = ''
		mkdir -p $out/bin
		ln -s $src/node_modules/.bin/nomicfoundation-solidity-language-server $out/bin/solidity-language-server
	'';

  meta = {
    description = "Language server for Solidity";
    homepage = "https://github.com/NomicFoundation/hardhat-vscode";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

