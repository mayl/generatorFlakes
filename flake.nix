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
    vmware = nixosGenerate { inherit system pkgs; modules = [./configuration.nix]; format = "vmware"; formatAttr = "vmwareImage"; };
    lxc = nixosGenerate { inherit system pkgs; modules = [./configuration.nix]; format = "lxc"; formatAttr = "tarball"; };
    sd = nixosGenerate { pkgs=pkgs.pkgsCross.aarch64-multiplatform; system="aarch64-linux";  modules = [./configuration.nix "${pkgs.path}/nixos/modules/profiles/minimal.nix" ]; format = "sd-aarch64"; formatAttr = "sdImage"; };
  };
}
