#!/usr/bin/env hhvm
use namespace HH\Lib\{Str};
use namespace AOC;

// https://adventofcode.com/2023/day/2

function impl(string $str): void {
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();

  // $lines = AOC\fileInput(__DIR__.'/one.in');
  $lines = AOC\testInput(vec["a","b","z"]);

  $out = await AOC\reduce($lines, ($acc, $line) ==> {
    printf("line: $line\n");
    return $acc + 1;
  }, 0);
  printf("out: $out\n");

}

