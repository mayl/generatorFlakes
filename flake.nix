{
  description = "Build VMs with flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      # url = "github:nix-community/nixos-generators";
      url = "github:mayl/nixos-generators";
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

  in {
    vbox = nixosGenerate{ 
      inherit system pkgs;
      modules = [./configuration.nix];
      format = "virtualbox"; 
    };

    vagrant = nixosGenerate{
      inherit system pkgs;
      modules = [./configuration.nix];
      format = "vagrant-virtualbox"; 
    };

    vmware = nixosGenerate { 
      inherit system pkgs;
      modules = [./configuration.nix];
      format = "vmware";
    };

    lxc = nixosGenerate {
      inherit system pkgs;
      modules = [./configuration.nix];
      format = "lxc";
    };

    sd = nixosGenerate { 
      pkgs=pkgs.pkgsCross.aarch64-multiplatform;
      system="aarch64-linux";
      modules = [./configuration.nix "${pkgs.path}/nixos/modules/profiles/minimal.nix" ];
      format = "sd-aarch64"; };
  };
}
