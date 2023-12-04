// now i'm being lazy and just trying to write this in something i don't have to think too hard about

const fs = require('fs/promises')
function nop() { }

function parseCard(raw) {
  const winning = new Set()
  const actual = new Set()

  // Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  // AAAAAA BBBBBBBBBBBBBBBB CCCCCCCCCCCCCCCCCCCCCCCC

  let mode = nop
  let acc = null // Array<digit chars> base10
  const END = () => {
    if (acc === null) { return }
    // handle transition away from prev token by mode
    mode()
    acc = null
  }
  const tokenTypes = [
    [/:/, () => { // section B
      END()
      mode = () => winning.add(parseInt(acc.join('')))
    }],
    [/\|/, () => { // section C
      END()
      mode = () => actual.add(parseInt(acc.join('')))
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

  return { winning, actual }
}

// figure out which of the numbers you have appear in the list of winning numbers.
// returns int
function scoreCard({ winning, actual }) {
  // lol js sets don't have builtin intsersection :S
  const matches = [...winning].filter((n => actual.has(n)))
  if (matches.length === 0) { return 0 }
  // The first match makes the card worth one point and each match after the first doubles the point value of that card.
  return 2 ** (matches.length - 1)
}


async function main() {

  const file = await fs.open('./input.txt')

  let sum = 0
  for await (const line of file.readLines()) {
    // console.log(line)
    const card = parseCard(line)
    const score = scoreCard(card)
    // console.log('   ->', score)
    sum += score
  }
  console.log('total:', sum)
}

main().then(() => console.log('done'))