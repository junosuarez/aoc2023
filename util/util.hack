namespace AOC;
use namespace HH\Lib\{File,IO,Str};

function fileInput(string $path): \HH\AsyncIterator<string> {
  $reader = new IO\BufferedReader(File\open_read_only($path));
  $lines = $reader->linesIterator();
  return $lines;
}

async function testInput(vec<string> $lines): AsyncIterator<string> {
  foreach ($lines as $line) {
    yield $line;
  }
}

// reads a file, maps each line, returns accumulated value
async function reduce<TAcc>(
  \HH\AsyncIterator<string> $lines,
  TAcc $init,
  (function(TAcc, string): TAcc) $collect
): Awaitable<TAcc> {

  $acc = $init;
  foreach ($lines await as $line) {
    $acc = $collect($acc, $line);
  }

  return $acc;
}
