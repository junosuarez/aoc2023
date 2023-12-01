#!/usr/bin/env hhvm

// https://adventofcode.com/2023/day/1

// For example:
// 1abc2          => 12
// pqr3stu8vwx    => 38
// a1b2c3d4e5f    => 15
// treb7uchet     => 77    (first and last digit are the same index)
function calibration_line(string $str): int {
  // $str
  return 1;
}

<<__EntryPoint>>
function main(): void {
  require_once(__DIR__.'/../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();

  $e1 = "1abc2";


  printf("%s  - %s\n", $e1, calibration_line($e1));

}

