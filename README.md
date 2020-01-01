# Judge0 API Base
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://github.com/judge0/api-base/blob/master/LICENSE)
[![Become a Patron](https://img.shields.io/badge/Donate-Patreon-orange)](https://www.patreon.com/hermanzdosilovic)
[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/hermanzdosilovic)

## About
**Judge0 API Base** is an base API Docker image with installed compilers, interpreters and sandbox environment - [isolate](https://github.com/ioi/isolate).

## Compilers and Interpreters
Each compiler and interpreter is compiled during image build, or if precompiled binary was available for x86_64 architecture then this binary is used.

We used this approach of compiling each compiler and interpreter instead of installing available packages because we have full control of choosing where this compiler and interpreter will be installed. That also gives us ability to install some compilers and interpreters that are not available with package manager.

As a consequence, Judge0 API Base image is large and build time takes few hours, but we successfully installed many different compilers and interpreters and more of them can be added easily.

We are open to any suggestions on how to reduce size of this image but retain flexibility of adding/removing new compilers and interpreters.

Here is a list of supported languages:

|#|Name|
|:---:|:---:|
|1|Assembly (NASM 2.14.02)|
|2|Bash (5.0.0)|
|3|Basic (FBC 1.07.1)|
|4|C (GCC 7.4.0)|
|5|C++ (GCC 7.4.0)|
|6|C (GCC 8.3.0)|
|7|C++ (GCC 8.3.0)|
|8|C (GCC 9.2.0)|
|9|C++ (GCC 9.2.0)|
|10|C# (Mono 6.6.0.161)|
|11|Common Lisp (SBCL 2.0.0)|
|12|D (DMD 2.089.1)|
|13|Elixir (1.9.4)|
|14|Erlang (OTP 22.2)|
|15|Executable|
|16|Fortran (GFortran 9.2.0)|
|17|Go (1.13.5)|
|18|Haskell (GHC 8.8.1)|
|19|Java (OpenJDK 13.0.1)|
|20|JavaScript (Node.js 12.14.0)|
|21|Lua (5.3.5)|
|22|OCaml (4.09.0)|
|23|Octave (5.1.0)|
|24|Pascal (FPC 3.0.4)|
|25|PHP (7.4.1)|
|26|Plain Text|
|27|Prolog (GNU Prolog 1.4.5)|
|28|Python (2.7.17)|
|29|Python (3.8.1)|
|30|Ruby (2.7.0)|
|31|Rust (1.40.0)|
|32|TypeScript (3.7.4)|

## Sandbox Environment
Sandbox environment is also included in this image. For sandbox environment we are using [isolate](https://github.com/ioi/isolate) (licensed under [GPL v2](https://github.com/ioi/isolate/blob/master/LICENSE)).

>Isolate is a sandbox built to safely run untrusted executables, offering them a limited-access environment and preventing them from affecting the host system. It takes advantage of features specific to the Linux kernel, like namespaces and control groups.

Huge thanks to [Martin Mareš](https://github.com/gollux) and [Bernard Blackham](https://github.com/bblackham) for developing and maintaining this project. Also, thanks to all other people who contributed to isolate project.

Isolate was used as sandbox environment (part of [CMS](https://github.com/cms-dev/cms) system) on big programming contests like [International Olympiad in Informatics](http://www.ioinformatics.org/index.shtml) (a.k.a. IOI) in 2012, and we trust that this sandbox environment works and does its job.

## Building Docker Image
If you want to build your own Judge0 API Base image:

1. Clone or download this project.
2. Make changes if you want.
3. Run `docker build -t yourRepoName .`
4. Grab some coffee, this **will** take some time.

## Pulling Docker Image
Take a look at [Docker Hub](https://hub.docker.com/r/judge0/api-base/tags/). There are version tags and `latest` tag.

`latest` tag will always be equal to highest version tag. Dockerfiles for all versions will be available in [tags](https://github.com/judge0/api-base/tags) or [releases](https://github.com/judge0/api-base/releases) pages of GitHub.

To pull version `1.0.0`:

1. `docker pull judge0/api-base:1.0.0`
2. Grab some coffee, this **might** take a while.

## Adding New Compiler or Interpreter
Adding new compiler or interpreter is easy as long as you know how to compile it properly or as long as you know what precompiled binary you need to download.

You should add installation of your favorite compiler between installation of last compiler and isolate installation. Installation of isolate should always be the last, because it is then easier to rebuild image when new version of isolate is available.

You should also install your favorite compiler inside `/usr/local/` folder. For example `GCC 9.2.0` is installed inside `/usr/local/gcc-9.2.0` folder.

Please note that when you add new compiler or interpreter there is still some work that needs to be done for it to be usable on [**Judge0 API**](https://api.judge0.com), but adding it to Judge0 API Base image is the first step. After that read documentation of [Judge0 API](https://github.com/judge0/api) for the next steps.

## Donate
Your are more than welcome to support Judge0 on [Patreon](https://www.patreon.com/hermanzdosilovic) or via [PayPal](https://www.paypal.me/hermanzdosilovic). Your monthly or one-time donation will help pay server costs and will improve future development and maintenance. Thank you ♥