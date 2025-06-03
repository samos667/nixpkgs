{
  appimageTools,
  fetchurl,
  lib,
  prisma-engines,
}: let
  pname = "anythingllm-desktop";
  version = "1.8.1-r2";

  src = fetchurl {
    url = "https://cdn.anythingllm.com/legacy/${version}/AnythingLLMDesktop.AppImage";
    hash = "sha256-aFKHqs+wbFMvfvAeDFPqCj14fE+eF9nag9ItmW3OJCw=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  environment = {
    # Essential engine configurations
    PRISMA_CLIENT_ENGINE_TYPE = "library";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";

    # Required deprecated variables for NixOS compatibility
    PRISMA_MIGRATION_ENGINE_BINARY = lib.getExe' prisma-engines "migration-engine";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    env = environment;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
        $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';

    meta = with lib; {
      description = "All-in-one AI application with RAG and AI Agents capabilities";
      homepage = "https://docs.anythingllm.com";
      license = licenses.mit;
      maintainers = with maintainers; [samos667];
      platforms = ["x86_64-linux"];
    };
  }
