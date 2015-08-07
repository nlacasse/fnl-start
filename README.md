# fnl-start
Contains manifests and scripts to tie all the other FNL repos together.  (New?
Start here.)

# Bootstrapping Fuchsia
Fuchsia uses the `v23` tool to manage repositories. The `$V23_ROOT` variable
determines where `v23` and the Fuchsia repositories will be placed.

```
$V23_ROOT/
    devtools/    # A v23 repo
    fnl-start/   # A Fuchsia repo
    kernel/      # Another Fuchsia repo
    release/     # The other v23 repo
    ...
```

The `v23` setup will check that the `$V23_ROOT` variable is set to a directory
that does not exist, which it will create and populate.

Once you have set `$V23_ROOT`, you can download and invoke
[bootstrap](https://raw.githubusercontent.com/effenel/fnl-start/bootstrap/bootstrap).
This will install `v23`, and use it to install all of the repositories listed in
`manifest`.

Once you have installed `v23`, you should add `$V23_ROOT/devtools/bin` to your
`$PATH`.

# Updating Fuchsia

`v23 update` will update all repositories to the branches specified in the
manifest.
