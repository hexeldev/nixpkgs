{ ... }:

let
  budhilaw = {
    name = "Ericsson Budhilaw";
    email = "ericsson.budhilaw@gmail.com";
    signingKey = "26DEBED91762BC50";
  };

  paper = {
    name = "Ericsson Budhilaw";
    email = "ericsson.budhilaw@paper.id";
    signingKey = "E290C3025FCF9462";
  };
in
{
  programs.git.enable = true;

  programs.git.ignores = [
    ".DS_Store"
  ];

  programs.git.extraConfig = {
    # gpg.program = "gpg";
    rerere.enable = true;
    commit.gpgSign = true;
    pull.ff = "only";
    diff.tool = "code";
    difftool.prompt = false;
    merge.tool = "code";
    url = {
      "git@work:paper-indonesia/" = {
        insteadOf = "https://github.com/paper-indonesia/";
      };
      "git@gitlab.com:" = {
        insteadOf = "https://gitlab.com/";
      };
      "git@github.com:" = {
        insteadOf = "https://github.com/";
      };
    };
  };

  # programs.git.userEmail = budhilaw.email;
  # programs.git.userName = budhilaw.name;
  # programs.git.signing.key = "8A2839421B711B45";

  programs.git.includes = [
    {
      condition = "gitdir:~/Dev/Personal/";
      contents.user = budhilaw;
      contents.commit = {
        gpgSign = true;
      };
    }
    {
      condition = "gitdir:~/Dev/Paper/";
      contents.user = paper;
      contents.commit = {
        gpgSign = true;
      };
    }
    {
      condition = "gitdir:~/.config/nixpkgs";
      contents.user = budhilaw;
      contents.commit = {
        gpgSign = true;
      };
    }
  ];

  ### git tools
  ## github cli
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
  programs.gh.settings.aliases = {
    co = "pr checkout";
    pv = "pr view";
  };
}
