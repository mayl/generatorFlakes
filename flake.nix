{
  description = "Build VMs with flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      # url = "github:mayl/nixos-generators";
      # url = "path:/home/larry/projects/nix/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ...}: 
  let
    system  = "x86_64-linux";
    pkgs = import nixpkgs{
      inherit system;
    };
    nixosGenerate = nixos-generators.nixosGenerate;
    # nixosGenerate = { system, pkgs, modules, format }:
    # let 
    #   formatModule = builtins.getAttr format (nixos-generators.nixosModules);
    #   image = nixpkgs.lib.nixosSystem {
    #     inherit system pkgs;
    #     modules = [
    #       formatModule
    #     ] ++ modules;
    #   };
    # in
    #   image.config.system.build.${image.config.formatAttr};


  in {
    vbox = nixosGenerate{ 
      inherit pkgs;
      modules = [./configuration.nix];
      format = "virtualbox"; 
    };

    vagrant = nixosGenerate{
      inherit pkgs;
      modules = [./configuration.nix];
      format = "vagrant-virtualbox"; 
    };

    vmware = nixosGenerate { 
      inherit pkgs;
      modules = [./configuration.nix];
      format = "vmware";
    };

    lxc = nixosGenerate {
      inherit pkgs;
      modules = [./configuration.nix];
      format = "lxc";
    };

    sd = nixosGenerate { 
      pkgs=pkgs.pkgsCross.aarch64-multiplatform;
      modules = [./configuration.nix "${pkgs.path}/nixos/modules/profiles/minimal.nix" ];
      format = "sd-aarch64"; };
  };
}
