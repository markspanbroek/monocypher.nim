import strutils
import tables
export tables.`[]`

type
  HexString = distinct string

const empty* = ""
const quick* = "The quick brown fox jumps over the lazy dog"

const knownHashes* = toTable({
  empty: HexString(
    "786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419" &
    "d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce"
  ),
  quick: HexString(
    "a8add4bdddfd93e4877d2746e62817b116364a1fa7bc148d95090bc7333b3673" &
    "f82401cf7aa2e4cb1ecd90296e3f14cb5413f8ed77be73045b13914cdcd6a918"
  )
})

proc toString*(hex: HexString): string =
  parseHexStr(string(hex))

proc toBytes*(s: string): seq[uint8] =
  cast[seq[byte]](s)

proc toBytes*(hex: HexString): seq[uint8] =
  toBytes(hex.toString())
