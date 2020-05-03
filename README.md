# Judge0 API Base
<a href="https://patreon.com/hermanzdosilovic" target="_blank"><img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" alt="" height="43px" /></a>
<a href="https://paypal.me/hermanzdosilovic" target="_blank"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="Donate with PayPal" height="43px" /></a>

## About
**Judge0 API Base** is an base Docker image with installed compilers, interpreters and [sandbox](https://github.com/ioi/isolate).

## Supported Languages

|#|Name|
|:---:|:---:|
|1|Assembly (NASM 2.14.02)|
|2|Bash (5.0.0)|
|3|Basic (FBC 1.07.1)|
|4|C (Clang 7.0.1)|
|5|C (GCC 7.4.0)|
|6|C (GCC 8.3.0)|
|7|C (GCC 9.2.0)|
|8|C# (Mono 6.6.0.161)|
|9|C++ (Clang 7.0.1)|
|10|C++ (GCC 7.4.0)|
|11|C++ (GCC 8.3.0)|
|12|C++ (GCC 9.2.0)|
|13|COBOL (GnuCOBOL 2.2)|
|14|Common Lisp (SBCL 2.0.0)|
|15|D (DMD 2.089.1)|
|16|Elixir (1.9.4)|
|17|Erlang (OTP 22.2)|
|18|Executable|
|19|Fortran (GFortran 9.2.0)|
|20|Go (1.13.5)|
|21|Haskell (GHC 8.8.1)|
|22|Java (OpenJDK 13.0.1)|
|23|JavaScript (Node.js 12.14.0)|
|24|Kotlin (1.3.70)|
|25|Lua (5.3.5)|
|26|Objective-C (Clang 7.0.1)|
|27|OCaml (4.09.0)|
|28|Octave (5.1.0)|
|29|Pascal (FPC 3.0.4)|
|30|PHP (7.4.1)|
|31|Plain Text|
|32|Prolog (GNU Prolog 1.4.5)|
|33|Python (2.7.17)|
|34|Python (3.8.1)|
|35|R (4.0.0)|
|36|Ruby (2.7.0)|
|37|Rust (1.40.0)|
|38|SQL (SQLite 3.27.2)|
|39|Swift (5.2.3)|
|40|TypeScript (3.7.4)|
|41|Visual Basic<span>.</span>Net (vbnc 0.0.0.5943)|

## Sandbox
For sandbox we are using [isolate](https://github.com/ioi/isolate) (licensed under [GPL v2](https://github.com/ioi/isolate/blob/master/LICENSE)).

>Isolate is a sandbox built to safely run untrusted executables, offering them a limited-access environment and preventing them from affecting the host system. It takes advantage of features specific to the Linux kernel, like namespaces and control groups.

Huge thanks to [Martin Mareš](https://github.com/gollux) and [Bernard Blackham](https://github.com/bblackham) for developing and maintaining this project. Thanks to all [contributors](https://github.com/ioi/isolate/graphs/contributors) for their contributions to isolate project.

Isolate was used as sandbox environment (part of [CMS](https://github.com/cms-dev/cms) system) on big programming contests like [International Olympiad in Informatics](http://www.ioinformatics.org/index.shtml) (a.k.a. IOI) in 2012, and we trust that it works and does its job.

## Donate
Your are more than welcome to support Judge0 on [Patreon](https://www.patreon.com/hermanzdosilovic), via [PayPal](https://paypal.me/hermanzdosilovic) or [Revolut](https://pay.revolut.com/profile/hermancy5). Your monthly or one-time donation will help cover server costs and will allow me to spend more time on development and maintenance. Thank you! ♥
