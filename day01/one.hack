#!/usr/bin/env hhvm
use namespace HH\Lib\{File,IO,Str};

// https://adventofcode.com/2023/day/1

// For example:
// 1abc2          => 12
// pqr3stu8vwx    => 38
// a1b2c3d4e5f    => 15
// treb7uchet     => 77    (first and last digit are the same index)
function calibration_line(string $str): int {
  // $str
  // return 1;
  // return Str\length($str);

  $chars = Str\split($str, "");

  // \print_r($chars);

  $first_digit = null;
  $last_digit = null;

  foreach ($chars as $idx => $char) {
    // printf("$idx: $char\n");
    $as_int = Str\to_int($char); // returns nullable int, null if not a digit
    if (!($as_int is null)) {
      // it's a digit
      if ($first_digit is null) {
        $first_digit = $as_int;
      }
      $last_digit = $as_int;
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

  $lines = AOC\fileInput(__DIR__.'/input.txt');

  $out = await AOC\reduce($lines, 0, ($acc, $line) ==> {
     $val = calibration_line($line);
    \printf("line: $line :: val: $val\n");
    $acc += $val;
    return $acc;
  });
  printf("out: $out\n");

}

