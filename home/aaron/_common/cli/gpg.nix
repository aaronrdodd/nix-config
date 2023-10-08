{ pkgs, ... }:
let
  launchAgent = ''
    gpgconf --launch gpg-agent  
  '';
in
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = "curses";
  };

  # Start gpg-agent if it's not running or tunneled in
  # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
  # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
  programs.bash.profileExtra = launchAgent;
  programs.fish.loginShellInit = launchAgent;
  programs.zsh.loginExtra = launchAgent;

  programs.gpg = {
    enable = true;
    settings = {
      trust-model = "tofu+pgp";
    };
  };

  # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
  # So that SSH config does not have to know the UID
  systemd.user.services = {
    link-gnupg-sockets = {
      Unit = {
        Description = "link gnupg sockets from /run to /home";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
        ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}

