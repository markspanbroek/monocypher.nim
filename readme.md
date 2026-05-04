Monocypher for Nim
==================

Allows the [Monocypher] cryptography library to be used in [Nim]. Please refer
to its [manual] for detailed usage and security considerations.

Examples
--------

Create a secret key using the [sysrandom] library, and ensure that it is
erased from memory once it's no longer used:

```nim
import monocypher
import sysrandom

let secretKey = getRandomBytes(sizeof(Key))
defer: crypto_wipe(secretKey)
```

Exchange a shared symmetric key using public keys:

```nim
let yourPublicKey = crypto_x25519_public_key(secretKey)
let theirPublicKey = # obtain public key from other party
let sharedKey = crypto_x25519(secretKey, theirPublicKey)
defer: crypto_wipe(sharedKey)
```

Encrypt a message using a symmetric key:

```nim
let nonce = getRandomBytes(sizeof(Nonce))
let plaintext = cast[seq[byte]]("hello")
let (mac, ciphertext) = crypto_aead_lock(sharedKey, nonce, plaintext)
```

Decrypt a message using a symmetric key:

```nim
let decrypted = crypto_aead_unlock(mac, sharedKey, nonce, ciphertext)
defer: crypto_wipe(decrypted)
```

Sign a message:

```nim
let seed = getRandomBytes(sizeof(Seed))
defer: crypto_wipe(seed)
let (secretKey, publicKey) = crypto_eddsa_key_pair(seed)
defer: crypto_wipe(secretKey)
let message = cast[seq[byte]]("hello")
let signature = crypto_eddsa_sign(secretKey, message)
```

Hash a byte array or a string:

```nim
let hashOfBytes = crypto_blake2b([1u8, 2u8, 3u8])
let hashOfString = crypto_blake2b("hello")
```

Timing-safe comparisons for byte arrays of length 16, 32 or 64:

```nim
let hash1 = crypto_blake2b("one")
let hash2 = crypto_blake2b("two")
let hashesAreEqual = crypto_verify(hash1, hash2) # false
```

Updating to a newer version
---------------------------

Follow these steps when updating the wrapper to a newer version of sss:

   1. update the git submodule in `sources/` to point to the new version
   2. run `build.sh`
   3. update the version in `monocypher.nimble`
   4. commit the changes

[Monocypher]: https://monocypher.org
[manual]: https://monocypher.org/manual/
[Nim]: https://nim-lang.org
[sysrandom]: https://github.com/euantorano/sysrandom.nim
