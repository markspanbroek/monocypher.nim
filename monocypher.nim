from monocypher/cImports import nil
import monocypher/cHelpers

type
  Key* = array[32, byte]
  Nonce* = array[24, byte]
  Mac* = array[16, byte]
  Signature* = array[64, byte]

func crypto_key_exchange_public_key*(secretKey: Key): Key =
  cimports.crypto_key_exchange_public_key(result, secretKey)

func crypto_key_exchange*(yourSecretKey, theirPublicKey: Key): Key =
  discard cimports.crypto_key_exchange(result, yourSecretKey, theirPublicKey)

func crypto_sign_public_key*(secretKey: Key): Key =
  cimports.crypto_sign_public_key(result, secretKey)

func crypto_sign*(secretKey, publicKey: Key, message: Bytes): Signature =
  let (messagePtr, messageLen) = pointerAndLength(message)
  cimports.crypto_sign(result, secretKey, publicKey, messagePtr, messageLen)

func crypto_check*(signature: Signature, publicKey: Key, message: Bytes): bool =
  let (messagePtr, messageLen) = pointerAndLength(message)
  result = cimports.crypto_check(signature, publicKey, messagePtr, messageLen) == 0

func crypto_lock*(key: Key, nonce: Nonce, plaintext: Bytes): (Mac, seq[byte]) =
  let (plainPtr, plainLen) = pointerAndLength(plaintext)
  var mac: Mac
  var ciphertext = newSeq[byte](plainLen)
  cimports.crypto_lock(mac, addr ciphertext[0], key, nonce, plainPtr, plainLen)
  result = (mac, ciphertext)

func crypto_unlock*(key: Key, nonce: Nonce, mac: Mac, ciphertext: Bytes): seq[byte] =
  let (cipherPtr, cipherLen) = pointerAndLength(ciphertext)
  result = newSeq[byte](cipherLen)
  let unlockResult = cimports.crypto_unlock(addr result[0], key, nonce, mac, cipherPtr, cipherLen)
  if not unlockResult == 0:
    raise newException(IOError, "message corrupted")

func crypto_wipe*(secret: pointer, size: uint) =
  cimports.crypto_wipe(secret, size)

func crypto_wipe*(secret: openArray[any]) =
  let (secretPtr, secretLen) = pointerAndLength(secret)
  crypto_wipe(secretPtr, secretLen)
