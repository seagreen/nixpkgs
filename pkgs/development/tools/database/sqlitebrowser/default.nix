{ stdenv, fetchFromGitHub, qt5, sqlite, cmake }:

stdenv.mkDerivation rec {
  version = "3.9.1";
  name = "sqlitebrowser-${version}";

  src = fetchFromGitHub {
    repo   = "sqlitebrowser";
    owner  = "sqlitebrowser";
    rev    = "v${version}";
    sha256 = "1s7f2d7wx2i68x60z7wdws3il6m83k5n5w5wyjvr0mz0mih0s150";
  };

  buildInputs = [ qt5.qtbase qt5.qttools sqlite cmake ];
  
  enableParallelBuilding = true;
  
  cmakeFlags = [ "-DUSE_QT5=TRUE" ];
  
  # A regression was introduced in CMakeLists.txt on v3.9.x
  # See https://github.com/sqlitebrowser/sqlitebrowser/issues/832 and issues/755
  patchPhase = ''
    substituteInPlace CMakeLists.txt --replace 'project("DB Browser for SQLite")' 'project(sqlitebrowser)'
  '';


  meta = with stdenv.lib; {
    description = "DB Browser for SQLite";
    homepage = "http://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}
