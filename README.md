# Clear the fprint storage in NixOS

I ran into this problem on my framework laptop (running NixOS): after an upgrade of the system, `fprintd` suddenly does not work. Checking the logs of the `fprintd` service suggest that the storage is corrupted. At that moment no `fprintd-*` command could run successfully, even `fprintd-delete` was not working.

The solution seems to be force clearing the storage. Thankfully, I found [this solution](https://community.frame.work/t/responded-fingerprint-scanner-compatibility-with-linux-ubuntu-fedora-etc/1501/341) of `Shy_Guy` from the framework laptop's community, which is in turn based on Kani's script on framework discord.

I put up this small `flake` to make the procedure slightly simpler just in case it will help the other ones who run into the same problem. 

So basically you need to run the script inside a development environment. With this `flake`, this is as simple as two commands:

```bash
$ sudo nix develop "github:nixvital/fprint-clear"

# After entering the environment

$ fprint-clear
```

Please note that the `sudo` for the `nix develop` is very important since the script requires the super user privilege to run.
