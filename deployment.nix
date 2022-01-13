{
  my-machine = { ... }: {
    deployment.targetHost = "localhost";
    imports = [./configuration.nix];
  };
}
