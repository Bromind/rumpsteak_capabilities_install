This is a script that helps with setting up rumpsteak for the rust morello compiler.

The problem with rumpsteak is that it uses the `future` crates, which (as of today) does not work with the morello compiler. (c.f. https://github.com/rust-lang/futures-rs/issues/2777 ).
Fortunatelly, there is an alternative version of `future` that *does* work.

In a nutshell, it downloads rumpsteak, and patches it so that it uses the alternative version of `future`. Beside, there is also a patch to set up the `Cargo.toml` of your project to use this alternative version of rumpsteak.

```
$ ./install_rumpsteak_morello_toolchain.sh
# this will ask you for the install path
# ... stuff happens ...
$ ls
Cargo.toml.patch  Cargo.toml.patch.template  install_rumpsteak_morello_toolchain.sh  README.md	rumpsteak_morello  rumpsteak.patch  rumpsteak.patch.template
$ # ^important    ^ ignore                   ^ ignore                                ^ it's me  ^ maybe here       ^ ignore         ^ ignore
$ cd /somewhere/
$ cargo init morello_project
$ cd morello_project
$ # Now, patch the local Cargo.toml so that it uses the correct version of rumpsteak:
$ patch Cargo.toml < /path/to/install/dir/Cargo.toml.patch
$ cat Cargo.toml
# Should force rumpsteak's and future's paths
```
