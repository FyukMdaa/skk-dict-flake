{ fetchFromGitHub, ... }:

{
  # skk-dev/dict
  skk-dev = fetchFromGitHub {
    owner = "skk-dev";
    repo = "dict";
    rev = "master";
    sha256 = "1nawfnpys6z2ndajqvsx5wbqhblssc2ylg51rmm6gprqnvfq660m";
  };

  # tokuhirom/skk-jisyo-jawiki
  jawiki = fetchFromGitHub {
    owner = "tokuhirom";
    repo = "skk-jisyo-jawiki";
    rev = "master";
    sha256 = "1kyglwcj8jxl0xppcv955029vz3fcczsd9xkd6jraj2hlqqc8bb8";
  };

  # stg73/dictionaries.skk
  stg73 = fetchFromGitHub {
    owner = "stg73";
    repo = "dictionaries.skk";
    rev = "master";
    sha256 = "10c72ap0ai9mhs4ngv9xd9s77n61ksfapc9y459mpmi5y3nn0qg0";
  };
}
