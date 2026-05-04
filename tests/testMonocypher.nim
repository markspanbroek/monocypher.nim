import unittest
import knownhashes
import sysrandom
import monocypher

test "hashing byte arrays":
  check crypto_blake2b(empty.toBytes()) == knownHashes[empty].toBytes()
  check crypto_blake2b(quick.toBytes()) == knownHashes[quick].toBytes()

test "hashing strings":
  check crypto_blake2b(empty) == knownHashes[empty].toBytes()
  check crypto_blake2b(quick) == knownHashes[quick].toBytes()

test "hashing with a key":
  let key = getRandomBytes(32)
  check crypto_blake2b(quick, key) == crypto_blake2b(quick, key)
  check crypto_blake2b(quick, key) != crypto_blake2b(quick)

test "key exchange":
  let secret1, secret2: Key = getRandomBytes(sizeof(Key))
  let public1 = crypto_x25519_public_key(secret1)
  let public2 = crypto_x25519_public_key(secret2)
  let shared1 = crypto_x25519(secret1, public2)
  let shared2 = crypto_x25519(secret2, public1)
  check shared1 == shared2

test "signing":
  let seed: Seed = getRandomBytes(sizeof(Seed))
  let (secretKey, publicKey) = crypto_eddsa_key_pair(seed)
  let message = cast[seq[byte]]("hello")

  let signature = crypto_eddsa_sign(secretKey, message)

  check crypto_eddsa_check(signature, publicKey, message)
  check not crypto_eddsa_check(signature, publicKey, message & 42u8)

test "encrypt and decrypt":
  let key: Key = getRandomBytes(sizeof(Key))
  let nonce: Nonce = getRandomBytes(sizeof(Nonce))
  let plaintext = cast[seq[byte]]("hello")
  let (mac, ciphertext) = crypto_aead_lock(key, nonce, plaintext)
  let decrypted = crypto_aead_unlock(mac, key, nonce, ciphertext)

  check decrypted == plaintext

test "decryption failure":
  let key: Key = getRandomBytes(sizeof(Key))
  let nonce: Nonce = getRandomBytes(sizeof(Nonce))
  let mac = getRandomBytes(sizeof(Mac))
  let cipherText = getRandomBytes(42)
  expect IOError:
    discard crypto_aead_unlock(mac, key, nonce, ciphertext)

test "constant time comparisons":

  proc check_crypto_verify(size: static uint) =
    var a, b: array[size, byte]
    a[^1] = 1
    b[^1] = 2
    check crypto_verify(a, a) == true
    check crypto_verify(b, b) == true
    check crypto_verify(a, b) == false

  check_crypto_verify(16)
  check_crypto_verify(32)
  check_crypto_verify(64)

test "wipe":
  let secretKey: Key = getRandomBytes(sizeof(Key))
  crypto_wipe(secretKey)
  var empty: Key
  check secretKey == empty
