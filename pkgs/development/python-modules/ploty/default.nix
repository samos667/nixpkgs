{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "plotly";
  version = "5.24.1";
  pyproject = true;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "";
  };

  # FAIL: test_checkers_testsuite (testsuite.test_all.Pep8TestCase)
  # doCheck = false;

  meta = with lib; {
    description = "Plotly's Python graphing library";
    homepage = "https://plotly.com";
    mainProgram = "plotly";
    license = licenses.mit;
    maintainers = [];
  };
}
