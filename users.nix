{
  config,
  pkgs,
  ...
}:

let
  inherit (import ./variables.nix) username gitUsername;
in

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = "${gitUsername}";
        extraGroups = [
          "networkmanager"
          "wheel" # Enable ‘sudo’ for the user.
          "video"
          "audio"
          "scanner"
          "lp"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = false;
        packages = with pkgs; [
        ];
      };
    };
    mutableUsers = true;
  };

  system.activationScripts.script.text = ''cp /home/${username}/.nixfiles/config/face.png /var/lib/AccountsService/icons/${username}'';
#  system.activationScripts.script.text = ''cp /home/${username}/.nixfiles/config/.zshrc /home/${username}'';
#  system.activationScripts.script.text = ''cp /home/${username}/.nixfiles/config/.p10k.zsh /home/${username}'';

  security.sudo.extraRules = [{
    users = ["${username}"];
    commands = [{ command = "ALL";
      options = ["NOPASSWD"];
    }];
  }];

}
