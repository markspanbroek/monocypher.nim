from monocypher/cwrapper as c import nil
import monocypher/cHelpers

type
  Hash* = array[64, byte]
  Key* = array[32, byte]
  Seed* = array[32, byte]
  EddsaPrivateKey* = array[64, byte]
  Nonce* = array[24, byte]
  Mac* = array[16, byte]
  Signature* = array[64, byte]

func crypto_blake2b*(message: Bytes, key: Bytes = []): Hash =
  let (messagePtr, messageLen) = pointerAndLength(message)
  if key.len == 0:
    c.crypto_blake2b(addr result[0], 64, messagePtr, messageLen)
  else:
    let (keyPtr, keyLen) = pointerAndLength(key)
    c.crypto_blake2b_keyed(addr result[0], 64,
                            keyPtr, keyLen, messagePtr, messageLen)

func crypto_blake2b*(message: string, key: Bytes = []): Hash =
  crypto_blake2b(cast[seq[byte]](message), key)

func crypto_x25519_public_key*(secretKey: Key): Key =
  c.crypto_x25519_public_key(result, secretKey)

func crypto_x25519*(yourSecretKey, theirPublicKey: Key): Key =
  c.crypto_x25519(result, yourSecretKey, theirPublicKey)

func crypto_eddsa_key_pair*(seed: Seed): (EddsaPrivateKey, Key) =
  c.crypto_eddsa_key_pair(result[0], result[1], seed)

func crypto_eddsa_sign*(secretKey: EddsaPrivateKey, message: Bytes): Signature =
  let (messagePtr, messageLen) = pointerAndLength(message)
  c.crypto_eddsa_sign(result, secretKey, messagePtr, messageLen)

func crypto_eddsa_check*(signature: Signature, publicKey: Key, message: Bytes): bool =
  let (messagePtr, messageLen) = pointerAndLength(message)
  result = c.crypto_eddsa_check(signature, publicKey, messagePtr, messageLen) == 0

func crypto_aead_lock*(key: Key, nonce: Nonce, plaintext: Bytes, additional: Bytes = []): (Mac, seq[byte]) =
  let (additionalPtr, additionalLen) = pointerAndLength(additional)
  let (plainPtr, plainLen) = pointerAndLength(plaintext)
  var mac: Mac
  var cipherText = newSeq[byte](plainLen)
  c.crypto_aead_lock(addr cipherText[0], mac, key, nonce, additionalPtr, additionalLen, plainPtr, plainLen)
  (mac, cipherText)

func crypto_aead_unlock*(mac: Mac, key: Key, nonce: Nonce, ciphertext: Bytes, additional: Bytes = []): seq[byte] =
  let (additionalPtr, additionalLen) = pointerAndLength(additional)
  let (cipherPtr, cipherLen) = pointerAndLength(ciphertext)
  result = newSeq[byte](cipherLen)
  let success = c.crypto_aead_unlock(addr result[0], mac, key, nonce, additionalPtr, additionalLen, cipherPtr, cipherLen)
  if not success == 0:
    raise newException(IOError, "message corrupted")

func crypto_wipe*(secret: pointer, size: uint) =
  c.crypto_wipe(secret, size)

func crypto_wipe*(secret: Bytes) =
  let (secretPtr, secretLen) = pointerAndLength(secret)
  crypto_wipe(secretPtr, secretLen)

func crypto_verify*(a: array[16, byte], b: array[16, byte]): bool =
  c.crypto_verify16(a, b) == 0

func crypto_verify*(a: array[32, byte], b: array[32, byte]): bool =
  c.crypto_verify32(a, b) == 0

func crypto_verify*(a: array[64, byte], b: array[64, byte]): bool =
  c.crypto_verify64(a, b) == 0
