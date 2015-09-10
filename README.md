# fnl-start
Contains manifests and scripts to tie all the other FNL repos together.  (New?
Start here.)

## Syncing the source with v23
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

The list of these repos is contained in the XML manifest in `//v2/default`. The
`v23` tool imposes the location and name of this directory (`v2` means we are
using the second version of the manifest syntax).

To access the `v23` repositories, you must create a password by going to
[the repos' website](https://vanadium.googlesource.com) and clicking "Generate
Password" in the upper right corner of the page.

The `v23` setup will check that the `$V23_ROOT` variable is set to a directory
that does not exist, which it will create and populate.

Once you have set `$V23_ROOT`, you can download and invoke
[bootstrap](https://raw.githubusercontent.com/effenel/fnl-start/master/bootstrap).
This will install `v23`, and use it to install all of the repositories listed in
`manifest`.

Once you have installed `v23`, you should add `$V23_ROOT/devtools/bin` to your
`$PATH`.

`v23 update` will update all repositories to the branches specified in the
manifest.

## Building Fuchsia
Once the source is downloaded, build Fuchsia for the first time with these
commands:

```
$  cd $V23_ROOT
$  ./build/bootstrap.bash
$  ./fuchsia-build root.bp
$  ./ninja/ninja -f build.ninja.in fuchsia/bootimg
```

Only the `ninja` command is required to re-build Fuchsia thereafter.

The bootstrap script creates `fuchsia-build`, which parses Blueprints files and
creates `build.ninja.in`.  `ninja` builds the final image using the rules and
dependencies from `build.ninja.in`.  `fuchsia/bootimg` is the build target, and
`out/boot.img` is the result.  More extensive documentation is in
[`build/README.md`](https://github.com/effenel/build/blob/master/README.md).

## Appendix: from empty directory to booting a built image
Below is a sample record of the commands used to go from an empty directory to a
full build.  These are not instructions; they are provided as reference only.

```
09:33:38 lanechr@lanechr ~ ★  cd /fuchsia
09:33:41 lanechr@lanechr /fuchsia ★  ls -l clean
ls: cannot access clean: No such file or directory
09:33:44 lanechr@lanechr /fuchsia ★  export V23_ROOT=/fuchsia/clean
09:33:54 lanechr@lanechr /fuchsia ★  wget https://raw.githubusercontent.com/effenel/fnl-start/master/bootstrap
[snip]
09:34:11 lanechr@lanechr /fuchsia ★  bash ./bootstrap
[snip]
09:34:37 lanechr@lanechr /fuchsia ★  export PATH=$PATH:/fuchsia/clean/devtools/bin
09:35:18 lanechr@lanechr /fuchsia ★  v23 update
[snip]
09:47:14 lanechr@lanechr /fuchsia ★  cd clean
10:54:13 lanechr@lanechr /fuchsia/clean ★  ./build/bootstrap.bash
[snip]
10:55:12 lanechr@lanechr /fuchsia/clean ★  ./fuchsia-build root.bp
10:56:52 lanechr@lanechr /fuchsia/clean ★  ./ninja/ninja -f build.ninja.in fuchsia/bootimg
[snip]
10:58:32 lanechr@lanechr /fuchsia/clean ★  qemu-system-x86_64 -display none -serial stdio -bios /usr/share/ovmf/OVMF.fd -hda /fuchsia/src/out/boot.img 
```
