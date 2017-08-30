# Judge0 API Base
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

## About
*Judge0 API Base* is an base API Docker image with installed compilers, interpreters and sandbox environment [isolate](https://github.com/ioi/isolate).

## Compilers and Interpreters
Each compiler and interpreter is compiled during build of an image, or if precompiled binary was available for x86_64 architecture, then this binary was used.

We used this approach of compiling each compiler/interpreter instead of installing available packages because we have full control of choosing where this compiler or interpreter will be installed. That also gives us ability to install some compilers or interpreters that are not available via package manager.

As a consequence, *Judge0 API Base* image is large (4.836 GB uncompressed) and build time takes few hours, but we successfully installed 20 different compilers and interpreters and more of them can be added easily.

We are open to any suggestions on how to reduce size of this image but retain flexibility of adding/removing new compilers/interpreters.

Here is a list of installed compilers and interpreters:

|#|Name|Version|Documentation|Download Link|
|:---:|:---:|:---:|---|---|
|1|gcc|6.3.0|https://gcc.gnu.org/onlinedocs/6.3.0/ |http://ftpmirror.gnu.org/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2
|2|gcc|5.4.0|https://gcc.gnu.org/onlinedocs/5.4.0/ |http://ftpmirror.gnu.org/gcc/gcc-5.4.0/gcc-5.4.0.tar.bz2
|3|gcc|4.9.4|https://gcc.gnu.org/onlinedocs/4.9.4/ |http://ftpmirror.gnu.org/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2
|4|gcc|4.8.5|https://gcc.gnu.org/onlinedocs/4.8.5/ |http://ftpmirror.gnu.org/gcc/gcc-4.8.5/gcc-4.8.5.tar.bz2
|5|bash|4.4|https://www.gnu.org/software/bash/manual/bash.html |http://ftpmirror.gnu.org/bash/bash-4.4.tar.gz
|6|bash|4.0|https://www.gnu.org/software/bash/manual/bash.html |http://ftpmirror.gnu.org/bash/bash-4.0.tar.gz
|7|ruby|2.4.0|http://ruby-doc.org/core-2.4.0/ |https://cache.ruby-lang.org/pub/ruby/ruby-2.4.0.tar.bz2
|8|ruby|2.3.3|http://ruby-doc.org/core-2.3.3/ |https://cache.ruby-lang.org/pub/ruby/ruby-2.3.3.tar.bz2
|9|ruby|2.2.6|http://ruby-doc.org/core-2.2.6/ |https://cache.ruby-lang.org/pub/ruby/ruby-2.2.6.tar.bz2
|10|ruby|2.1.9|http://ruby-doc.org/core-2.1.9/ |https://cache.ruby-lang.org/pub/ruby/ruby-2.1.9.tar.bz2
|11|python|3.6.0|https://docs.python.org/3/ |https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz
|12|python|3.5.3|https://docs.python.org/3.5/ |https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tar.xz
|13|python|2.7.9|https://docs.python.org/2.7/ |https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
|14|python|2.6.9|https://docs.python.org/2.6/ |https://www.python.org/ftp/python/2.6.9/Python-2.6.9.tar.xz
|15|OpenJDK|8|https://docs.oracle.com/javase/8/docs/api/ |http://openjdk.java.net/install/
|16|OpenJDK|7|https://docs.oracle.com/javase/7/docs/api/ |http://openjdk.java.net/install/
|17|fpc|3.0.0|http://www.freepascal.org/docs.var |ftp://ftp.freepascal.org/fpc/dist/3.0.0/x86_64-linux/fpc-3.0.0.x86_64-linux.tar
|18|ghc|8.0.2|http://downloads.haskell.org/~ghc/8.0.2/docs/html/ |http://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-x86_64-deb8-linux.tar.xz
|19|mono|4.8.0.472|http://www.mono-project.com/docs/ |https://download.mono-project.com/sources/mono/mono-4.8.0.472.tar.bz2
|20|octave|4.2.0|https://www.gnu.org/software/octave/doc/interpreter/ |https://ftp.gnu.org/gnu/octave/octave-4.2.0.tar.gz
|21|nodejs|4.8.1|https://nodejs.org/docs/v4.8.1/api/ |https://nodejs.org/dist/v4.8.1/node-v4.8.1.tar.gz
|22|nodejs|6.10.1|https://nodejs.org/docs/v6.10.1/api/ |https://nodejs.org/dist/v6.10.1/node-v6.10.1.tar.gz

## Sandbox Environment
Sandbox environment is also included in this image. For sandbox environment we are using [isolate](https://github.com/ioi/isolate) (licensed under [GPL v2](https://github.com/ioi/isolate/blob/master/LICENSE)).

>Isolate is a sandbox built to safely run untrusted executables, offering them a limited-access environment and preventing them from affecting the host system. It takes advantage of features specific to the Linux kernel, like namespaces and control groups.

Huge thanks to [Martin Mareš](https://github.com/gollux) and [Bernard Blackham](https://github.com/bblackham) for developing and maintaining this project. Also, thanks to all other people who contributed to *isolate* project.

*Isolate* was used as sandbox environment (part of [CMS](https://github.com/cms-dev/cms) system) on big programming contests like [International Olympiad in Informatics](http://www.ioinformatics.org/index.shtml) (a.k.a. IOI) in 2012, and we trust that this sandbox environment works and does its job. Thanks again!

## Building Docker Image
If you want to build your own *Judge0 API Base* image:

1. Clone or download this project.
2. Make changes if you want.
3. Run `docker build -t yourRepoName .`
4. Grab some coffee, this **will** take a while.

## Pulling Docker Image

Take a look at [Docker Hub](https://hub.docker.com/r/judge0/api-base/tags/). There are version tags and `latest` tag.

`latest` tag will always be equal to highest version tag. Dockerfiles for all versions will be available in [tags](https://github.com/judge0/api-base/tags) or [releases](https://github.com/judge0/api-base/releases) pages of GitHub.

To pull version `0.1.2`:

1. `docker pull judge0/api-base:0.1.2`
2. Grab some coffee, this **might** take a while.

## Adding New Compiler or Interpreter

Adding new compiler or interpreter is easy as long as you know how to compile it properly or as long as you know what precompiled binary you need to download.

You should add installation of your favorite compiler between installation of last compiler and *isolate* installation. Installation of *isolate* should always be the last, because it is then easier to rebuild image when new version of *isolate* is available.

You should also install your favorite compiler inside `/usr/local/` folder. For example `gcc v6.3.0` is installed inside `/usr/local/gcc-6.3.0` folder.

Please note that when you add new compiler or interpreter there is still some work that needs to be done for it to be usable on *Judge0 API*, but adding it to *Judge0 API Base* image is the first step. After that read documentation of [Judge0 API](https://github.com/judge0/api) for next steps.
