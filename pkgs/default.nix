{ fetchFromGitHub, lib }:

{
  # skk-dev/dict
  skk-dev = fetchFromGitHub {
    owner = "skk-dev";
    repo = "dict";
    rev = "4eb91a3bbfef70bde940668ec60f3beae291e971";
    sha256 = "06ka7xs3aakk0jzcm6bn0d8qzjwmaag4l9675al6bfw11vjzqv5i";
  };

  # tokuhirom/skk-jisyo-jawiki
  jawiki = fetchFromGitHub {
    owner = "tokuhirom";
    repo = "skk-jisyo-jawiki";
    rev = "78ec2eb2ffd13eb0e01e731cd451ef5b1fd2f94f";
    sha256 = "1ydkdc104x4gwlh6cllgmhy06698mbl06c46w2kkhln4s1j6ffdi";
  };

  # stg73/dictionaries.skk
  stg73 = fetchFromGitHub {
    owner = "stg73";
    repo = "dictionaries.skk";
    rev = "9dd9b021ed5c16c44ce5a8c928bfcdd259095158";
    sha256 = "04n6i359cj07cq8b07g68aklkmb9kis38qfh2a25yfk92y4xfrlg";
  };
}
