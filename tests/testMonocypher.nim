import unittest
import sysrandom
import monocypher

test "key exchange":
  let secret1, secret2: Key = getRandomBytes(32)
  let public1 = crypto_key_exchange_public_key(secret1)
  let public2 = crypto_key_exchange_public_key(secret2)
  let shared1 = crypto_key_exchange(secret1, public2)
  let shared2 = crypto_key_exchange(secret2, public1)
  check shared1 == shared2

test "signing":
  let secretKey: Key = getRandomBytes(32)
  let publicKey: Key = crypto_sign_public_key(secretKey)
  let message = "hello"

  let signature = crypto_sign(secretKey, public_key, message)

  check crypto_check(signature, publicKey, message)
  check not crypto_check(signature, publicKey, message & "!")
