#!/usr/bin/env hhvm
use namespace HH\Lib\{Str, Vec};
use namespace AOC;

// https://adventofcode.com/2023/day/7

<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();

  $lines = AOC\fileInput(__DIR__.'/input.txt');
  // $lines = AOC\testInput(vec[
  //   "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  //   "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  //   "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  //   "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  //   "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  // ]);
  // $test_actual = tuple(12,13,14);
  $actual = tuple(12,13,14);

  $out = await \AOC\reduce($lines, 0, ($acc, $line) ==> {
     $game = parseGame($line);
     if (is_possible($actual, $game)) {
      // add up the IDs of the games that would have been possible
      $acc += $game[0];
     }
    // \printf("line: $line :: val: %s\n", \print_r($game, true));
    // $acc += $val;
    return $acc;
  });
  \printf("out: $out\n");

}
