const fs = require('fs/promises')

// camel cards

// you get a list of hands, and your goal is to order them based on the strength of each hand.A hand consists of five cards labeled one of A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card follows this order, where A is the highest and 2 is the lowest.

const Card = Object.freeze({ // enum, value is card strength
  A: 14,
  K: 13,
  Q: 12,
  J: 11,
  T: 10,
  9: 9,
  8: 8,
  7: 7,
  6: 6,
  5: 5,
  4: 4,
  3: 3,
  2: 2
})

// Five of a kind, where all five cards have the same label: AAAAA
// Four of a kind, where four cards have the same label and one card has a different label: AA8AA
// Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
// Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
// Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
// One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
// High card, where all cards' labels are distinct: 23456
const HandType = Object.freeze({ // value is type strength
  '5kind': 7,
  '4kind': 6,
  'fullhouse': 5,
  '3kind': 4,
  '2pair': 3,
  'pair': 2,
  'high': 1
})

class Hand {
  cards // string where each char is a card
  bid // number
  constructor(cards, bid) {
    this.cards = cards
    this.bid = bid
    this.t = this.type(cards)
  }
  type(cards) {
    // all rules for hand types involve counts, so we can divide this into a wordcount problem
    const w = {};
    [...cards].forEach(char => {
      w[char] = w[char] ?? 0
      w[char]++
    })

    // now we know how many cards of each type, lets sort these types by count desc
    const tc = Object.keys(w)
    tc.sort((a, b) => w[b] - w[a])

    // TODO: we could maybe also sort matching counts (runs) 2nd by card type score

    const firstRun = w[tc[0]]
    const secondRun = w[tc[1]]

    switch (firstRun) {
      case 5:
        return HandType['5kind']
      case 4:
        return HandType['4kind']
      case 3:
        return secondRun === 2 ? HandType.fullhouse : HandType['3kind']
      case 2:
        return secondRun === 2 ? HandType['2pair'] : HandType.pair
      default:
        return HandType.high
    }

  }
}

function parseHand(line) {
  const [cards, bid] = line.trim().split(' ')
  return new Hand(cards, parseInt(bid))
}
function totalWinnings(hands) {
  // sort hands to get rank
  //    first by type, second by card rank
  //
  // sum(rank * bid)
  const c = [...hands]
  c.sort((a, b) => {
    const byType = a.t - b.t
    if (byType === 0) {
      // secondary by in-order card score
      // If these cards are different, the hand with the stronger first card is considered stronger.
      for (let i = 0; i < a.cards.length; i++) { // zip cards from a and b
        const ac = Card[a.cards[i]]
        const bc = Card[b.cards[i]]
        if (ac === bc) continue;
        return ac - bc
      }
    } else {
      return byType
    }
  })

  const sum = c.reduce((acc, el, i) => {
    const rank = i + 1
    // console.log(el, rank)
    return acc + (rank * el.bid)
  }, 0)

  return sum
}

async function main() {

  //   const test = `
  //   32T3K 765
  // T55J5 684
  // KK677 28
  // KTJJT 220
  // QQQJA 483
  // `.trim().split('\n')
  //   const lines = test
  const lines = (await fs.readFile('./input.txt', 'utf8')).split('\n')

  const hands = lines.map(line => parseHand(line))

  // console.log(hands)
  const out = totalWinnings(hands)
  console.log(out)
  // console.log('expect: 6440')

}
main().then(() => { })