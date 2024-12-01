{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatchling,
  hatch-nodejs-version,
  fastjsonschema,
  jsonschema,
  jupyter-core,
  traitlets,
  pep440,
  pytestCheckHook,
  testpath,
}:
buildPythonPackage rec {
  pname = "ploty";
  version = "5.24.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "";
  };

  build-system = [
    hatchling
    hatch-nodejs-version
  ];

  dependencies = [
    fastjsonschema
    jsonschema
    jupyter-core
    traitlets
  ];

  pythonImportsCheck = ["ploty"];

  nativeCheckInputs = [
    pep440
    pytestCheckHook
    testpath
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Plotly's Python graphing library";
    mainProgram = "jupyter-trust";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [globin];
  };
}
