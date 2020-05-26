# Judge0 API Base
<a href="https://patreon.com/hermanzdosilovic" target="_blank"><img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" alt="" height="43px" /></a>
<a href="https://paypal.me/hermanzdosilovic" target="_blank"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="Donate with PayPal" height="43px" /></a>

## About
**Judge0 API Base** is an base Docker image with installed compilers, interpreters and [sandbox](https://github.com/ioi/isolate).

## Supported Languages
### Standard Edition
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
|13|Clojure (1.10.1)|
|14|COBOL (GnuCOBOL 2.2)|
|15|Common Lisp (SBCL 2.0.0)|
|16|D (DMD 2.089.1)|
|17|Elixir (1.9.4)|
|18|Erlang (OTP 22.2)|
|19|Executable|
|20|F# (.NET Core SDK 3.1.202)|
|21|Fortran (GFortran 9.2.0)|
|22|Go (1.13.5)|
|23|Groovy (3.0.3)|
|24|Haskell (GHC 8.8.1)|
|25|Java (OpenJDK 13.0.1)|
|26|JavaScript (Node.js 12.14.0)|
|27|Kotlin (1.3.70)|
|28|Lua (5.3.5)|
|29|Objective-C (Clang 7.0.1)|
|30|OCaml (4.09.0)|
|31|Octave (5.1.0)|
|32|Pascal (FPC 3.0.4)|
|33|Perl (5.28.1)|
|34|PHP (7.4.1)|
|35|Plain Text|
|36|Prolog (GNU Prolog 1.4.5)|
|37|Python (2.7.17)|
|38|Python (3.8.1)|
|39|R (4.0.0)|
|40|Ruby (2.7.0)|
|41|Rust (1.40.0)|
|42|Scala (2.13.2)|
|43|SQL (SQLite 3.27.2)|
|44|Swift (5.2.3)|
|45|TypeScript (3.7.4)|
|46|Visual Basic<span>.</span>Net (vbnc 0.0.0.5943)|

### Extra Edition
|#|Name|
|:---:|:---:|
|1|Bosque (latest)|
|2|C (Clang 10.0.1)|
|3|C++ (Clang 10.0.1)|
|4|C3 (latest)|
|5|Java (OpenJDK 14.0.1)|
|6|Java Test (OpenJDK 14.0.1, JUnit Platform Console Standalone 1.6.2)|
|7|MPI (OpenRTE 3.1.3) with C (GCC 8.4.0)|
|8|MPI (OpenRTE 3.1.3) with C++ (GCC 8.4.0)|
|9|MPI (OpenRTE 3.1.3) with Python (3.7.7)|
|10|Nim (stable)|
|11|Python for ML (3.7.7)|

## Sandbox
For sandbox we are using [isolate](https://github.com/ioi/isolate) (licensed under [GPL v2](https://github.com/ioi/isolate/blob/master/LICENSE)).

>Isolate is a sandbox built to safely run untrusted executables, offering them a limited-access environment and preventing them from affecting the host system. It takes advantage of features specific to the Linux kernel, like namespaces and control groups.

Huge thanks to [Martin Mareš](https://github.com/gollux) and [Bernard Blackham](https://github.com/bblackham) for developing and maintaining this project. Thanks to all [contributors](https://github.com/ioi/isolate/graphs/contributors) for their contributions to isolate project.

Isolate was used as sandbox environment (part of [CMS](https://github.com/cms-dev/cms) system) on big programming contests like [International Olympiad in Informatics](http://www.ioinformatics.org/index.shtml) (a.k.a. IOI) in 2012, and we trust that it works and does its job.

## Donate
Your are more than welcome to support Judge0 on [Patreon](https://www.patreon.com/hermanzdosilovic), via [PayPal](https://paypal.me/hermanzdosilovic) or [Revolut](https://pay.revolut.com/profile/hermancy5). Your monthly or one-time donation will help cover server costs and will allow me to spend more time on development and maintenance. Thank you! ♥
