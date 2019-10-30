import unittest
import sysrandom
import monocypher

let secretKey = getRandomBytes(32)
let message = [1u8, 2u8, 3u8]

test "signing":
  var publicKey: array[32, uint8]
  var signature: array[64, uint8]

  let messagePtr = unsafeAddr message[0]
  let messageLen = uint(sizeof(message))

  crypto_sign_public_key(public_key, secretKey)
  crypto_sign(signature, secretKey, public_key, messagePtr, messageLen)
  
  check crypto_check(signature, public_key, messagePtr, messageLen) == 0
