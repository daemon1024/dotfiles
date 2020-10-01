# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  networking.hostName = "legion"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   	acpi
	wget 
	vim
	firefox
	alacritty
	pfetch
	tmux
	git
	feh
	htop
	spotify
	discord
 	tdesktop
	vscode
	dwm
    	dmenu
	xclip
	nerdfonts
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
      { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/amixer set 'Master' 5%-"; }
      { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/amixer set 'Master' 5%+"; } 
    ];
  };
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
	
  services.flatpak.enable = true;
  xdg.portal.enable = true; 
  programs.fish.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.xkbOptions = "ctrl:swapcaps";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.sessionCommands = ''
    feh --bg-fill /home/daemon1024/Downloads/wallpaper.png;
    /home/daemon1024/.xsetroot &
  '';

  services.xserver.windowManager.dwm.enable = true;
  fonts.fonts = with pkgs; [ nerdfonts ];
  nixpkgs.overlays = [
    (self: super: {
      # dwm from personal github fork
      dwm = super.dwm.overrideAttrs (oa: {
	  src = super.fetchFromGitHub {
                owner = "daemon1024";
                repo = "dwm";
		rev = "e64afb2721595774b84f6e810d20964ef8aed7bf";
		sha256 = "1vmlwr1y5g68hcci018l5lqp38xplnipacyd5cz3gp8hhr4m5k8m";
              };

	  patches = oa.patches ++ [
	  (builtins.fetchurl https://dwm.suckless.org/patches/centeredmaster/dwm-centeredmaster-6.1.diff)
	];
      });

      #st patches
      #st = super.st.overrideAttrs (oa: {	
      #  patches = oa.patches ++ [
      #    (builtins.fetchurl https://st.suckless.org/patches/dracula/st-dracula-0.8.2.diff)
      #  ];
      #});
      dmenu = super.dmenu.overrideAttrs (oa: {
	patches = oa.patches ++ [
	  (builtins.fetchurl https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-20200523-db6093f.diff)
	  ];
	});
	
    })
  ];
  # Setup lightdm
  # Enable GNOME DE
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daemon1024 = {
     isNormalUser = true;
     shell = pkgs.fish;
     extraGroups = [ "wheel"]; # Enable ‘sudo’ for the user.
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}


