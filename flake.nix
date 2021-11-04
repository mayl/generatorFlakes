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
  in {
    vbox = (nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [ 
        nixos-generators.nixosModules.virtualbox
        ./configuration.nix
      ];
    }).config.system.build.virtualBoxOVA;

    vagrant = (nixpkgs.lib.nixosSystem { 
      inherit system pkgs;
      modules = [
        nixos-generators.nixosModules.vagrant-virtualbox
        ./configuration.nix
      ];
    }).config.system.build.vagrantVirtualbox;
  };
}
