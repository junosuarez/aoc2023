#!/usr/bin/env hhvm
use namespace HH\Lib\{Math, Str, Vec};
use namespace AOC;

// https://adventofcode.com/2023/day/2

// it sounds like a monty hall style game

// data: gameId, multiple sets of (number of cubes of r, g, b)
// eg:
// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green

// representation:
//  tuple(int game_id, \HH\Set<vec<tuple(int red, int blue, int green)>>)
// if a color isn't listed in the line string, its tuple value is 0

// query:
// which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes

newtype DrawRgb = (int, int, int);
newtype Game = (int, vec<DrawRgb>); // (int game_id, vec[DrawRgb] draws)

function parseGame(string $str): Game {

  // first parse game id
  $parts = Str\split($str, ": ");
  // $parts[0] = "Game 1"
  $game_id = Str\to_int(Str\split($parts[0], " ")[1]);

  // then parse draws, semicolon-delimited
  $draw_strs = Str\split($parts[1], "; ");
  // print_r($draw_strs);
  // parse each draw string into a DrawRgb tuple, filling in 0 if absent
  // note colors may appear in any order
  $draws = Vec\map($draw_strs, ($draw_str) ==> {
    // eg "1 red, 2 green, 6 blue"
    $r = 0;
    $g = 0;
    $b = 0;

    foreach(Str\split($draw_str, ", ") as $color_str) {
      $c = Str\split($color_str, " ");
      if ($c[1] == "red") {
        $r = Str\to_int($c[0]);
      } else if ($c[1] == "green") {
        $g = Str\to_int($c[0]);
      } else if ($c[1] == "blue") {
        $b = Str\to_int($c[0]);
      }
    }

    return tuple($r, $g, $b);
  });

  return tuple($game_id, $draws);
}

function is_possible(DrawRgb $actual, Game $game): bool {
  $draws = $game[1];
  foreach ($draws as $draw) {
    if ($draw[0] > $actual[0] ||
    $draw[1] > $actual[1] ||
    $draw[2] > $actual[2]) {
      // \printf("Game %d - too many: D %s ; A %s", $game[0], \print_r($draw, true), \print_r($actual, true));
      return false;
    }
  }
  return true;
}

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

  $r = 0;
  $g = 0;
  $b = 0;

  $out = await \AOC\reduce($lines, 0, ($acc, $line) ==> {
     $game = parseGame($line);
      // fewest number of cubes of each color that could have been in the bag to make the game possible

      // so, as we iterate games and draws, keep track of the max for each of r, g, b
      foreach ($game[1] as $draw) {
        $r = Math\max(vec[$r, $draw[0]]);
        $g = Math\max(vec[$g, $draw[1]]);
        $b = Math\max(vec[$b, $draw[2]]);
      }

      // compute power
      $power = $r * $g * $b;

    return $acc + $power;
  });
  \printf("out: $out\n");

}

