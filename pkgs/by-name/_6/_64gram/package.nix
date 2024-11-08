{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, telegram-desktop
, nix-update-script
}:

telegram-desktop.overrideAttrs (old: rec {
  pname = "64gram";
  version = "1.1.43";

  src = fetchFromGitHub {
    owner = "TDesktop-x64";
    repo = "tdesktop";
    rev = "v${version}";

    fetchSubmodules = true;
    hash = "sha256-vRiAIGY3CU5+hsdn8xiNbgvSM3eGRVwnvsSmSoaDN/k=";
  };

  patches = (old.patches or []) ++ [
    (fetchpatch {
      url = "https://github.com/TDesktop-x64/tdesktop/commit/c996ccc1561aed089c8b596f6ab3844335bbf1df.patch";
      revert = true;
      hash = "sha256-Hz7BXl5z4owe31l9Je3QOXT8FAyKcbsXsKjGfCmXhzE=";
    })
  ];

  cmakeFlags = (old.cmakeFlags or []) ++ [
    (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
    (lib.cmakeBool "disable_autoupdate" true)
  ];

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://github.com/TDesktop-x64/tdesktop";
    changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ clot27 ];
    mainProgram = if stdenv.hostPlatform.isLinux then "telegram-desktop" else "Telegram";
  };
})
