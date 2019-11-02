from monocypher/cImports import nil
import monocypher/cHelpers

type
  Key* = array[32, byte]
  Signature* = array[64, byte]

func crypto_key_exchange_public_key*(secretKey: Key): Key =
  cimports.crypto_key_exchange_public_key(result, secretKey)

func crypto_key_exchange*(yourSecretKey, theirPublicKey: Key): Key =
  discard cimports.crypto_key_exchange(result, yourSecretKey, theirPublicKey)

func crypto_sign_public_key*(secretKey: Key): Key =
  cimports.crypto_sign_public_key(result, secretKey)

func crypto_sign*(secretKey: Key, publicKey: Key, message: Bytes): Signature =
  let (messagePtr, messageLen) = pointerAndLength(message)
  cimports.crypto_sign(result, secretKey, publicKey, messagePtr, messageLen)

func crypto_sign*(secretKey: Key, publicKey: Key, message: string): Signature =
  result = crypto_sign(secretKey, publicKey, bytes(message))

func crypto_check*(signature: Signature, publicKey: Key, message: Bytes): bool =
  let (messagePtr, messageLen) = pointerAndLength(message)
  result = cimports.crypto_check(signature, publicKey, messagePtr, messageLen) == 0

func crypto_check*(signature: Signature, publicKey: Key, message: string): bool =
  result = crypto_check(signature, publicKey, bytes(message))

