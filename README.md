# aoc2023

[adventure of code, v2.0.23](https://adventofcode.com/) (in a variety of ecclectic languages)

Most likely won't go all the way to the end, but this will serve as a platform for several light daliances with some programming languages encountered in various situs.

Below is stream-of-conscious dev log notes as I go, including setting up dev environments on my mac.

## Day 1

Language: [hacklang](https://docs.hhvm.com/hack)

### setup

First off, installing hhvm per https://docs.hhvm.com/hhvm/installation/introduction

It seems the homebrew package is deprecated, just as well it will force me to set up a dev container.

> podman pull hhvm/hhvm

it complains about the arch, but running it still appears to be successful on my apple silicon laptop. c'mon, hhvm - risc architecture is gonna change everything.

```
;; podman run --tty --interactive hhvm/hhvm:latest hhvm --version
WARNING: image platform (linux/amd64) does not match the expected platform (linux/arm64)
HipHop VM 4.172.0 (rel) (non-lowptr)
Compiler: 1667340154_989010953
Repo schema: 63eaf8b56fb7edbc7a8ca9e32786eb0c1f8f508c
```

slight detour, needing to re-init my podman machine to get bind mounts working, please hold...
(following https://github.com/ansible/vscode-ansible/wiki/macos ):

```
podman machine stop
podman machine rm
podman machine init --cpus=4 --memory=4096 -v $HOME:$HOME -v /private/tmp:/private/tmp -v /var/folders/:/var/folders/
podman machine start
```

(i wish i had set up my local docker image read through caching server but i digress. maybe one day. not now.)

created a binstub, so now i can run hhvm in a container with this local repo directory mounted in /app like:

```
./hhvm <foo>
```

installed vscode hack extension: https://marketplace.visualstudio.com/items?itemName=pranayagarwal.vscode-hack

so now i'm able to run the helloworld example from https://docs.hhvm.com/hack/source-code-fundamentals/program-structure via:

```
./hhvm day1/hi.hack
```

### part one

now, mind you, the last time i wrote some php was maybe a year ago when i modified some phabricator cli helper files, but before that, who knows how long, 5 years? a decade? 15 years? a while, my friends. a while. so! here goes.

i'm not really attemping _idiomatic_ hacklang, at least not initially. for now it's sufficient to, uh, hack my way through it. this first problem looks like some good ol' string programming.

annoying that i have to manually type semicolons. i hear there's an autoformatting tool, but it's not working with the vscode extension out of the box (maybe because docker?). i'll maybe try to figure it out later.

ok, two new learnings, both on the hack environment side and not the puzzle side:

1. there is a `hh_client` bin which runs a daemonized syntax checker (maybe also typechecker? i'm guessing it behaves like the flowjs cli, more or less). i wrapped this in a containerized binstup called `/.hh` (might have to go more verbose on the name but this is good for now)
2. apparently now i'm getting name collisions for having two functions in two separate files named `main`, even though my mental model right now is they're separate, like how i would consider separate files in a nodejs project. presumably this is wrong and i instead need to declare namespaces, maybe, like in java. note, however, that when i try running the file with `hhvm day1/one.hack` this doesn't come up, so maybe it's more of a warning or a lint message. i can see how a real project would benefit from proper namespacing but for my purposes right now it's just noise!

what i need to figure out, however, is how to import the `Str\format` function I'm trying to use, which i _think_ comes from the hsl (hack std lib), and i'm surprised that it's not just... there.

i guess i need to go through this drudgery: https://docs.hhvm.com/hack/getting-started/starting-a-real-project

manually downloaded some php package manager called "composer" per https://getcomposer.org/download/ - it's now here in my repo for funsies.

i will never complain about setting up a typescript project by hand again :)

um, so i set up "autoloading"? sounds like a module map for hacklang

```
php composer.phar require hhvm/hhvm-autoload
# ...
# this is confidence inspiring:
Package hhvm/hhvm-autoload is abandoned, you should avoid using it. No replacement was suggested.
```

ok, i now appear to have a `composer.json`, `composer.lock` as well as a `vendor` directory, which contains, uh, additional stuff. think `node_modules`ish.

sadly, running `hh_client` now gives me even more errors - 21 in total, stemming from files in the `vendor` dir.
running `hhvm dayone/one.hack` still gives me the `Str\format` undefined function error.

i guess i need to add hsl to my `composer.json`:

```
php composer.phar require hhvm/hsl hhvm/hhvm-autoload
```

still no dice. i'm gonna try things from https://docs.hhvm.com/hack/getting-started/starting-a-real-project#starting-a-real-project__an-example

```
curl https://raw.githubusercontent.com/hhvm/hhast/master/.hhconfig > .hhconfig
```

and adding an `hh_autoload.json` file, except modifying it because i'm a masochist i guess to use a folder layout more like i want.

ok, after all that and running composer again (`composer require hhvm/hsl hhvm/hhvm-autoload`) i'm back to my original 3 errors in `hh_client`. p...pr...progress??

so i added this magic incantation inside my main function:

```
require_once(__DIR__.'/../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();
```

and it still griefs me for Str\format, but also I noticed that there's a builtin `printf` so I'll just use that for now. Anyway. hacking!

very slow progress but now i can run a barebones script, so that's something:

```
root@bc7fb67094e1:/app# hhvm day1/one.hack
1abc2  - 1
```

decided to go copy off of some other code, and sure enough it seems like there are `use` statements at the top for the Str namespace:
https://github.com/hhvm/hhast/blob/main/src/File.hack

```
use namespace HH\Lib\{C, Dict, Keyset, Regex, Str, Vec};
```

adding that makes it work, and i can call (at long last) `Str\length`. Woo! now we're hackin'

ok now to figure out how to iterate an array (`vec`) https://docs.hhvm.com/hack/arrays-and-collections/vec-keyset-and-dict

...

ok, after a little bit of fumbling through the std lib docs, i was able to get part one working, and i'm going to call it a night.

i'm a notorious fake exiter at parties. so i finished it, ugly but working. the way vectors and dicts work seem pretty nice, and so far my hit rate is pretty good navigating the docs to find what I need. Rough onboarding curve for "just setting up my dev environment" but after that, writing it seems pretty nice. Will be nicer once I have the editor extensions like intellisense or autofmt working, but even just syntax highlighting and manual typing is, um, not terrible?

## Day 2

tk!
