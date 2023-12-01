#!/usr/bin/env hhvm
namespace AOC\Day1;
use namespace HH\Lib\{File,IO,Str};

// https://adventofcode.com/2023/day/1


// in the extension for part two, we have the additional requirement of spelled-out digits:
// one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".



function calibration_line(string $str): int {
  // $str
  // return 1;
  // return Str\length($str);

  // first, handle digit replacements.
  // yes this is inefficient, but it's still O(n) :shipit:

  // originally i'd hoisted this map to the top of the file, like i would in js, but i get the following error:
  // Fatal error: Found top-level code in /app/day1/two.hack on line 21

  // so for now i'm inlining this, even though it's less efficient or whatever
  $words = dict[
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
  'zero' => '0'
];


  \printf("orig: $str\n");
  foreach ($words as $word => $digit) {
    $str = Str\replace($str, $word, $digit);
    // there's also a Str\replace_every fn that could make this a oneliner, but for now getting comfortable with foreach syntax seems useful
  }

  // ok for real here is my stopping point: the way i have it implemented, we go in order of the dict, but this test case shows instead we have to get more parserlike and go in order of the input string:
  // eightwothree => 23 (*) - wrong, this is what i currently get
  // eightwothree => 83
  // when i pick this up, i think i can go back to the main traversal loop below, and at each character, in the not-digit case, look ahead to see if it matches a word key, and if it does, well, thats ok because none of our words are ambiguous so we can just keep iterating character-wise and it should Just WorkTM


  \printf("then: $str\n");

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

  // printf("%s  - %s\n", "1abc2", calibration_line("1abc2"));
  // printf("%s  - %s\n", "treb7uchet", calibration_line("treb7uchet"));

  // read a whole doc, line-wise, then sum all the lines

  $reader = new IO\BufferedReader(File\open_read_only(__DIR__.'/two.ex'));

  $sum = 0;
  foreach ($reader->linesIterator() await as $line) {
    // do_stuff($line);
    $val = calibration_line($line);
    $sum = $sum + $val;
    \printf(":: $line :: $val :: $sum\n");
  }

  \printf("$sum\n");
}

