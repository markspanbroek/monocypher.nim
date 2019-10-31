import unittest
import sysrandom
import monocypher

test "signing":
  let secretKey: Key = getRandomBytes(32)
  let publicKey: Key = crypto_sign_public_key(secretKey)
  let message = "hello"

  let signature = crypto_sign(secretKey, public_key, message)

  check crypto_check(signature, publicKey, message)
  check not crypto_check(signature, publicKey, message & "!")
