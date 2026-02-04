{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "tirith";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sheeki03";
    repo = "tirith";
    rev = "v${version}";
    hash = "sha256-WpaHsGDHBQaU8umNN8tWsDmraqo38wnOTCrcA18ss9A=";
  };

  cargoHash = "sha256-im/KpQyPlzqvKgItwMVbLscppArU0Z57r2pdOW3bn88=";

  # Skip failing shell init tests in sandbox environment
  checkFlags = [
    "--skip=init_bash_output"
    "--skip=init_zsh_output"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tirith \
      --bash <("$out/bin/tirith" completions bash) \
      --zsh <("$out/bin/tirith" completions zsh) \
      --fish <("$out/bin/tirith" completions fish)
  '';

  meta = {
    description = "Terminal security tool that guards against homograph attacks, pipe-to-shell exploits, and other command-line threats";
    homepage = "https://github.com/sheeki03/tirith";
    changelog = "https://github.com/sheeki03/tirith/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tirith";
  };
}
