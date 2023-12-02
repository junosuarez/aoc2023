#!/usr/bin/env hhvm
use namespace HH\Lib\{Math, Str, Vec};
use namespace AOC;

// https://adventofcode.com/2023/day/2

class Game {
  public int $id;
  public vec<CubeSet> $draws;

  public function possible(CubeSet $actual): bool {
    foreach ($this->draws as $draw) {
      if ($draw->r > $actual->r ||
        $draw->g > $actual->g ||
        $draw->b > $actual->b) {
      // \printf("Game %d - too many: D %s ; A %s", $game[0], \print_r($draw, true), \print_r($actual, true));
        return false;
      }
    }
    return true;
  }

  public static function parse(string $game_str): Game {
    $it = new Game();

    // first parse game id, eg "Game 11: ..."
    $parts = Str\split($game_str, ": ");
    $it->id = Str\to_int(Str\split($parts[0], " ")[1]);

    // then parse draws, semicolon-delimited
    $draw_strs = Str\split($parts[1], "; ");
    $it->draws = Vec\map($draw_strs, ($draw_str) ==> {
      return CubeSet::parse($draw_str);
    });

    return $it;
  }
}

class CubeSet {
  public function __construct(
    public int $r = 0,
    public int $g = 0,
    public int $b = 0
  ) {}

  public function power(): int {
    return $this->r * $this->g * $this->b;
  }

  public static function parse(string $draw_str): CubeSet {
    // eg "1 red, 2 green" or "4 blue, 1 red, 2 green"
    $it = new CubeSet();

    foreach(Str\split($draw_str, ", ") as $color_str) {
      $color = Str\split($color_str, " ");
      $val = Str\to_int($color[0]);
      switch ($color[1]){
        case "red":
          $it->r = $val;
        break;
        case "green":
          $it->g = $val;
        break;
        case "blue":
          $it->b = $val;
        break;
      }
    }

    return $it;
  }
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


  $actual = new CubeSet(12, 13, 14);

  $out = await \AOC\reduce($lines, 0, ($acc, $line) ==> {
    $game = Game::parse($line);

    // Part One:
    // Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?

    // printf("game %d, possible %b\n", $game->id, $game->possible($actual));
    // if ($game->possible($actual)) {
    //   $acc += $game->id;
    // }


    // Part Two:
    // For each game, find the minimum set of cubes that must have been present. What is the sum of the power of these sets?

    $minset = new CubeSet();
    foreach ($game->draws as $draw) {
      $minset->r = Math\max(vec[$minset->r, $draw->r]);
      $minset->g = Math\max(vec[$minset->g, $draw->g]);
      $minset->b = Math\max(vec[$minset->b, $draw->b]);
    }
    // printf("g %s - m %s\n", $game->id, print_r($minset, true));
    $acc += $minset->power();

    return $acc;
  });
  \printf("out: $out\n");

}
