// now i'm being lazy and just trying to write this in something i don't have to think too hard about

const fs = require('fs/promises')
function nop() { }

function parseCard(raw) {
  const card = {
    id: null,
    winning: new Set(),
    actual: new Set()
  }

  // Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  // AAAAAA BBBBBBBBBBBBBBBB CCCCCCCCCCCCCCCCCCCCCCCC

  let mode = () => card.id = chompInt()
  let acc = null // Array<digit chars> base10
  const chompInt = () => {
    const c = parseInt(acc.join(''))
    acc = null
    return c
  }
  const END = () => {
    if (acc === null) { return }
    // handle transition away from prev token by mode
    mode()
    acc = null
  }
  const tokenTypes = [
    [/:/, () => { // section B
      END()
      mode = () => card.winning.add(chompInt())
    }],
    [/\|/, () => { // section C
      END()
      mode = () => card.actual.add(chompInt())
    }],
    [/ /, () => END()],
    [/\d/, (char) => {
      acc = [...acc ?? [], char]
    }]
  ]


  raw.split('').forEach(char => {
    for (const [pattern, tokenize] of tokenTypes) {
      if (pattern.test(char)) {
        tokenize(char)
        break
      }
    }
  })
  END()

  // console.log(raw)
  // console.log(card)

  return card
}

// figure out which of the numbers you have appear in the list of winning numbers.
// returns int
function scoreCard({ winning, actual }) {
  // lol js sets don't have builtin intsersection :S
  const matches = [...winning].filter((n => actual.has(n)))

  // part 2 rule:
  return matches.length


  // if (matches.length === 0) { return 0 }
  // // The first match makes the card worth one point and each match after the first doubles the point value of that card.
  // return 2 ** (matches.length - 1)
}

function magic(matchesByGame) {
  const copiesByGame = {};
  [...matchesByGame.keys()].forEach(gameId => {
    copiesByGame[gameId] ||= 0
    copiesByGame[gameId]++
    let m = matchesByGame.get(gameId)
    while (m) {
      const nextId = gameId + m
      copiesByGame[nextId] ||= 0
      const times = copiesByGame[gameId]
      copiesByGame[nextId] += times // "make copies"
      m--
    }
  })
  // console.log(matchesByGame)
  // console.log(copiesByGame)

  // console.log({ 1: 1, 2: 2, 3: 4, 4: 8, 5: 14, 6: 1 }, 30)
  const sum = Object.values(copiesByGame).reduce((a, b) => a + b)
  return sum
}


async function main() {

  const file = await fs.open('./input.txt')

  const src = file.readLines()
  //   const src = `
  //   Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  //   Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  //   Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  //   Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  //   Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  //   Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  // `.trim().split('\n')

  const matches = new Map() // (cardId, matches)

  for await (const line of src) {
    const card = parseCard(line)
    matches.set(card.id, scoreCard(card))
  }

  const sum = magic(matches)

  // console.log('matches', matches)
  console.log('total:', sum)
}

main().then(() => console.log('done'))