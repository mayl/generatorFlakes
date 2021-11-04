{
  description = "Build VMs with flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ...}: 
  let
    system  = "x86_64-linux";
    pkgs = import nixpkgs{
      inherit system;
    };

    nixosGenerate = { system, pkgs, modules, format, formatAttr }:
    let 
      formatModule = builtins.getAttr format nixos-generators.nixosModules;
    in
    builtins.getAttr formatAttr (nixpkgs.lib.nixosSystem { 
      inherit system pkgs;
      modules = [
        formatModule
      ] ++ modules;
    }).config.system.build;
  in {

    vbox = nixosGenerate{ inherit system pkgs; modules = [./configuration.nix]; format = "virtualbox"; formatAttr = "virtualBoxOVA";};

    vagrant = nixosGenerate{ inherit system pkgs; modules = [./configuration.nix]; format = "vagrant-virtualbox"; formatAttr = "vagrantVirtualbox"; };
  };
}
