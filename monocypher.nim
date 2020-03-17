from monocypher/cImports as c import nil
import monocypher/cHelpers

type
  Hash* = array[64, byte]
  Key* = array[32, byte]
  Nonce* = array[24, byte]
  Mac* = array[16, byte]
  Signature* = array[64, byte]

func crypto_blake2b*(message: Bytes, key: Bytes = []): Hash =
  let (messagePtr, messageLen) = pointerAndLength(message)
  let (keyPtr, keyLen) = pointerAndLength(key)
  c.crypto_blake2b_general(addr result[0], 64,
                          keyPtr, keyLen, messagePtr, messageLen)

func crypto_blake2b*(message: string, key: Bytes = []): Hash =
  crypto_blake2b(cast[seq[byte]](message), key)

func crypto_key_exchange_public_key*(secretKey: Key): Key =
  c.crypto_key_exchange_public_key(result, secretKey)

func crypto_key_exchange*(yourSecretKey, theirPublicKey: Key): Key =
  c.crypto_key_exchange(result, yourSecretKey, theirPublicKey)

func crypto_sign_public_key*(secretKey: Key): Key =
  c.crypto_sign_public_key(result, secretKey)

func crypto_sign*(secretKey, publicKey: Key, message: Bytes): Signature =
  let (messagePtr, messageLen) = pointerAndLength(message)
  c.crypto_sign(result, secretKey, publicKey, messagePtr, messageLen)

func crypto_check*(signature: Signature, publicKey: Key, message: Bytes): bool =
  let (messagePtr, messageLen) = pointerAndLength(message)
  result = c.crypto_check(signature, publicKey, messagePtr, messageLen) == 0

func crypto_lock*(key: Key, nonce: Nonce, plaintext: Bytes): (Mac, seq[byte]) =
  let (plainPtr, plainLen) = pointerAndLength(plaintext)
  var mac: Mac
  var ciphertext = newSeq[byte](plainLen)
  c.crypto_lock(mac, addr ciphertext[0], key, nonce, plainPtr, plainLen)
  result = (mac, ciphertext)

func crypto_unlock*(key: Key, nonce: Nonce, mac: Mac, ciphertext: Bytes): seq[byte] =
  let (cipherPtr, cipherLen) = pointerAndLength(ciphertext)
  result = newSeq[byte](cipherLen)
  let plainPtr = addr result[0]
  let success = c.crypto_unlock(plainPtr, key, nonce, mac, cipherPtr, cipherLen)
  if not success == 0:
    raise newException(IOError, "message corrupted")

func crypto_wipe*(secret: pointer, size: uint) =
  c.crypto_wipe(secret, size)

func crypto_wipe*(secret: openArray[any]) =
  let (secretPtr, secretLen) = pointerAndLength(secret)
  crypto_wipe(secretPtr, secretLen)

func crypto_verify*(a: array[16, byte], b: array[16, byte]): bool =
  c.crypto_verify16(a, b) == 0

func crypto_verify*(a: array[32, byte], b: array[32, byte]): bool =
  c.crypto_verify32(a, b) == 0

func crypto_verify*(a: array[64, byte], b: array[64, byte]): bool =
  c.crypto_verify64(a, b) == 0
