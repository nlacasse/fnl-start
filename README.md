# fnl-start
Contains manifests and scripts to tie all the other FNL repos together.  (New?
Start here.)

## Syncing the source with jiri
Fuchsia uses the `jiri` tool to manage repositories. The `$JIRI_ROOT` variable
determines where `jiri` and the Fuchsia repositories will be placed.

```
$JIRI_ROOT/
    devtools/    # A jiri repo
    fnl-start/   # A Fuchsia repo
    kernel/      # Another Fuchsia repo
    release/     # The other jiri repo
    ...
```

The list of these repos is contained in the XML manifests in `$JIRI_ROOT/.manifest/v2`;
in particular, the `default` and `minimal` files. The `jiri` tool imposes the location
 and name of this directory (`v2` means we are using the second version of the manifest syntax).

To access the `jiri` repositories, you must create a password by going to
[the repos' website](https://vanadium.googlesource.com) and clicking "Generate
Password" in the upper right corner of the page.

The `jiri` setup will check that the `$JIRI_ROOT` variable is set to a directory
that does not exist, which it will create and populate.

Once you have set `$JIRI_ROOT`, you can download and invoke
[bootstrap](https://raw.githubusercontent.com/effenel/fnl-start/master/bootstrap).
This will install `jiri`, and use it to install all of the repositories listed in
`manifest`.

Once you have installed `jiri`, you should add `$JIRI_ROOT/devtools/bin` to your
`$PATH`.

`jiri update` will update all repositories to the branches specified in the
manifest.

## Build dependencies
Building Fuchsia depends on (at least) the following aptitude packages:

1. bc
1. bison
1. cgpt
1. flex
1. gdisk
1. golang
1. libssl-dev
1. m4
1. nasm
1. python-mako
1. re2c
1. upx-ucl
1. uuid-dev
1. vboot-kernel-utils
1. android-tools-fsutils

## Building Fuchsia
Once the source is downloaded, build Fuchsia for the first time with these
commands:

```
$  cd $JIRI_ROOT
$  ./build/bootstrap.bash
$  ./fuchsia-build root.bp
$  ./ninja/ninja -f build.ninja.in fuchsia/bootimg/[target]
$  # [target] is a hardware target like 'qemu' or 'pixel2'
```

Only the `ninja` command is required to re-build Fuchsia thereafter.

The bootstrap script creates `fuchsia-build`, which parses
[Blueprint](https://github.com/google/blueprint) files and creates `build.ninja.in`.
`ninja` builds the final image using the rules and dependencies from `build.ninja.in`.
`fuchsia/bootimg/foo` is the build target, and the products are placed in `./out`.
For more documentation on the build system, see
[`build/README.md`](https://github.com/effenel/build/blob/master/README.md).

The products in the out directory depend on the target chosen.  For qemu, `./out/boot.img`
is a UEFI system partition image you can boot with `qemu-system-x86_64`.  For pixel2, a
kernel image and a root directory structure are created (`./out/bootimg/pixel2_kernel.bin`
and `./out/root/x86_64-fuchsia-linux-musl`, respectively).

## Contributing
For instructions on filing issues or contributing changes, see
[CONTRIBUTING.md].

## Appendix: from empty directory to booting a built image
Below is a sample record of the commands used to go from an empty directory to a
full build for the pixel2.  These are provided as reference only; if you don't know
what a command does, you should probably find out before running it.

```
09:33:38 lanechr@lanechr ~ ★  cd /fuchsia
09:33:41 lanechr@lanechr /fuchsia ★  ls -l clean
ls: cannot access clean: No such file or directory
09:33:44 lanechr@lanechr /fuchsia ★  export JIRI_ROOT=/fuchsia/clean
09:33:54 lanechr@lanechr /fuchsia ★  wget https://raw.githubusercontent.com/effenel/fnl-start/master/bootstrap
[snip]
09:34:11 lanechr@lanechr /fuchsia ★  bash ./bootstrap
[snip]
09:34:37 lanechr@lanechr /fuchsia ★  export PATH=$PATH:$JIRI_ROOT/devtools/bin
09:35:18 lanechr@lanechr /fuchsia ★  jiri update
[snip]
09:47:14 lanechr@lanechr /fuchsia ★  cd $JIRI_ROOT
10:54:13 lanechr@lanechr /fuchsia/clean ★  ./build/bootstrap.bash
[snip]
10:55:12 lanechr@lanechr /fuchsia/clean ★  ./fuchsia-build root.bp
10:56:52 lanechr@lanechr /fuchsia/clean ★  ./ninja/ninja -f build.ninja.in fuchsia/bootimg/pixel2
[snip]
10:58:32 lanechr@lanechr /fuchsia/clean ★  sudo ./rootimg/make_bootable_usb.sh /dev/sdd ./out/bootimg/pixel2_kernel.bin ./out/root/x86_64-fuchsia-linux-musl
```

[CONTRIBUTING.md]: CONTRIBUTING.md
