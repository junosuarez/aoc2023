#!/usr/bin/env hhvm
namespace AOC\Day1;
use namespace HH\Lib\{File,IO,Str};
use namespace AOC\util;

// https://adventofcode.com/2023/day/1


function calibration_line(string $str): int {
  $words = dict[
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9,
  'zero' => 0
];

  $chars = Str\split($str, "");

  $first_digit = null;
  $last_digit = null;

  foreach ($chars as $idx => $char) {
    // printf("$idx: $char\n");
    $as_int = Str\to_int($char); // returns nullable int, null if not a digit
    if ($as_int is nonnull) {
      // it's a digit
      if ($first_digit is null) {
        $first_digit = $as_int;
      }
      $last_digit = $as_int;
    } else {
      // not a digit, but let's check to see if it's a spelled-out number word
      $rest = Str\slice($str, $idx);
      foreach ($words as $word => $int) {
        if (Str\starts_with($rest, $word)) {
          if ($first_digit is null) {
            $first_digit = $int;
          }
          $last_digit = $int;
        }
      }
    }
  }

  // at this point we've traversed the whole string and we have our first and last digits. now concat them and return

  $ret = ($first_digit * 10) + $last_digit;

  return $ret;
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();


  $lines = \AOC\fileInput(__DIR__.'/input.txt');

  $out = await \AOC\reduce($lines, 0, ($acc, $line) ==> {
     $val = calibration_line($line);
    \printf("line: $line :: val: $val\n");
    $acc += $val;
    return $acc;
  });
  \printf("out: $out\n");

}

