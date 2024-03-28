{ stdenv
, lib
, fetchFromGitLab
, bash
, makeWrapper
, lolcat
, bc
, scowl
}:
stdenv.mkDerivation {
  pname = "wordy";
  version = "0.1.2";
  src = fetchFromGitLab {
    owner = "christosangel";
    repo = "wordy";
    rev = "ff481fc723ec3912db53e3b60c8458831e15716a";
    hash = "sha256-WVZy7XFon8Nrb9zsOANk9UCFONpurdkvbNPrxsc20J0=";
  };
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  runtimeDependencies = [
    lolcat
    scowl
    bc
  ];

  patchPhase = ''
    sed -i 's|/usr/share/dict/words|${scowl}/share/dict/words.txt|g' wordy.sh
    sed -i 's|$HOME/.cache/wordy/wordy.png|$(dirname "$0")/../share/icon.png|g' wordy.sh
  '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp wordy.sh $out/bin/wordy
    cp wordy.png $out/share/icon.png
    wrapProgram $out/bin/wordy --prefix PATH : ${lib.makeBinPath [ bash lolcat bc ]}
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/christosangel/wordy";
    description = "Wordy is a TUI word spelling puzzle in bash. You have 6 guesses to find out the secret 5-letter word.";
    license = licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ ilikefrogs101 ];
    mainProgram = "wordy";
  };
}
