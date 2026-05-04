# Generated @ 2026-05-04T15:57:54+02:00
# Command line:
#   /home/user/.asdf/installs/nim/2.2.10/nimble/pkgs2/nimterop-0.6.13-a93246b2ad5531db11e51de7b2d188c42d95576a/nimterop/toast --compile=./sources/src/monocypher.c --pnim --noHeader ./sources/src/monocypher.h

{.push hint[ConvFromXtoItselfNotNeeded]: off.}


{.experimental: "codeReordering".}
{.compile: "./sources/src/monocypher.c".}
const
  CRYPTO_ARGON2_D* = 0
  CRYPTO_ARGON2_I* = 1
  CRYPTO_ARGON2_ID* = 2
type
  crypto_aead_ctx* {.bycopy.} = object ## ```
                                        ##   Authenticated stream
                                        ##      --------------------
                                        ## ```
    counter*: uint64
    key*: array[32, uint8]
    nonce*: array[8, uint8]
  crypto_blake2b_ctx* {.incompleteStruct.} = object ## ```
                                                     ##   Incremental interface
                                                     ## ```
  crypto_argon2_config* {.bycopy.} = object
    algorithm*: uint32       ## ```
                             ##   Argon2d, Argon2i, Argon2id
                             ## ```
    nb_blocks*: uint32       ## ```
                             ##   memory hardness, >= 8 nb_lanes
                             ## ```
    nb_passes*: uint32 ## ```
                       ##   CPU hardness, >= 1 (>= 3 recommended for Argon2i)
                       ## ```
    nb_lanes*: uint32        ## ```
                             ##   parallelism level (single threaded anyway)
                             ## ```
  crypto_argon2_inputs* {.bycopy.} = object
    pass*: ptr uint8
    salt*: ptr uint8
    pass_size*: uint32
    salt_size*: uint32       ## ```
                             ##   16 bytes recommended
                             ## ```
  crypto_argon2_extras* {.bycopy.} = object
    key*: ptr uint8          ## ```
                             ##   may be NULL if no key
                             ## ```
    ad*: ptr uint8           ## ```
                             ##   may be NULL if no additional data
                             ## ```
    key_size*: uint32        ## ```
                             ##   0 if no key (32 bytes recommended otherwise)
                             ## ```
    ad_size*: uint32         ## ```
                             ##   0 if no additional data
                             ## ```
  crypto_poly1305_ctx* {.incompleteStruct.} = object ## ```
                                                      ##   Incremental interface
                                                      ## ```
var crypto_argon2_no_extras* {.importc.}: crypto_argon2_extras
proc crypto_verify16*(a: array[16, uint8]; b: array[16, uint8]): cint {.importc,
    cdecl.}
  ## ```
           ##   Constant time comparisons
           ##      -------------------------
           ##      Return 0 if a and b are equal, -1 otherwise
           ## ```
proc crypto_verify32*(a: array[32, uint8]; b: array[32, uint8]): cint {.importc,
    cdecl.}
proc crypto_verify64*(a: array[64, uint8]; b: array[64, uint8]): cint {.importc,
    cdecl.}
proc crypto_wipe*(secret: pointer; size: uint) {.importc, cdecl.}
  ## ```
                                                                 ##   Erase sensitive data
                                                                 ##      --------------------
                                                                 ## ```
proc crypto_aead_lock*(cipher_text: ptr uint8; mac: array[16, uint8];
                       key: array[32, uint8]; nonce: array[24, uint8];
                       ad: ptr uint8; ad_size: uint; plain_text: ptr uint8;
                       text_size: uint) {.importc, cdecl.}
  ## ```
                                                          ##   Authenticated encryption
                                                          ##      ------------------------
                                                          ## ```
proc crypto_aead_unlock*(plain_text: ptr uint8; mac: array[16, uint8];
                         key: array[32, uint8]; nonce: array[24, uint8];
                         ad: ptr uint8; ad_size: uint; cipher_text: ptr uint8;
                         text_size: uint): cint {.importc, cdecl.}
proc crypto_aead_init_x*(ctx: ptr crypto_aead_ctx; key: array[32, uint8];
                         nonce: array[24, uint8]) {.importc, cdecl.}
proc crypto_aead_init_djb*(ctx: ptr crypto_aead_ctx; key: array[32, uint8];
                           nonce: array[8, uint8]) {.importc, cdecl.}
proc crypto_aead_init_ietf*(ctx: ptr crypto_aead_ctx; key: array[32, uint8];
                            nonce: array[12, uint8]) {.importc, cdecl.}
proc crypto_aead_write*(ctx: ptr crypto_aead_ctx; cipher_text: ptr uint8;
                        mac: array[16, uint8]; ad: ptr uint8; ad_size: uint;
                        plain_text: ptr uint8; text_size: uint) {.importc, cdecl.}
proc crypto_aead_read*(ctx: ptr crypto_aead_ctx; plain_text: ptr uint8;
                       mac: array[16, uint8]; ad: ptr uint8; ad_size: uint;
                       cipher_text: ptr uint8; text_size: uint): cint {.importc,
    cdecl.}
proc crypto_blake2b*(hash: ptr uint8; hash_size: uint; message: ptr uint8;
                     message_size: uint) {.importc, cdecl.}
  ## ```
                                                           ##   General purpose hash (BLAKE2b)
                                                           ##      ------------------------------
                                                           ##      Direct interface
                                                           ## ```
proc crypto_blake2b_keyed*(hash: ptr uint8; hash_size: uint; key: ptr uint8;
                           key_size: uint; message: ptr uint8;
                           message_size: uint) {.importc, cdecl.}
proc crypto_blake2b_init*(ctx: ptr crypto_blake2b_ctx; hash_size: uint) {.
    importc, cdecl.}
proc crypto_blake2b_keyed_init*(ctx: ptr crypto_blake2b_ctx; hash_size: uint;
                                key: ptr uint8; key_size: uint) {.importc, cdecl.}
proc crypto_blake2b_update*(ctx: ptr crypto_blake2b_ctx; message: ptr uint8;
                            message_size: uint) {.importc, cdecl.}
proc crypto_blake2b_final*(ctx: ptr crypto_blake2b_ctx; hash: ptr uint8) {.
    importc, cdecl.}
proc crypto_argon2*(hash: ptr uint8; hash_size: uint32; work_area: pointer;
                    config: crypto_argon2_config; inputs: crypto_argon2_inputs;
                    extras: crypto_argon2_extras) {.importc, cdecl.}
proc crypto_x25519_public_key*(public_key: array[32, uint8];
                               secret_key: array[32, uint8]) {.importc, cdecl.}
  ## ```
                                                                               ##   Key exchange (X-25519)
                                                                               ##      ----------------------
                                                                               ##      Shared secrets are not quite random.
                                                                               ##      Hash them to derive an actual shared key.
                                                                               ## ```
proc crypto_x25519*(raw_shared_secret: array[32, uint8];
                    your_secret_key: array[32, uint8];
                    their_public_key: array[32, uint8]) {.importc, cdecl.}
proc crypto_x25519_to_eddsa*(eddsa: array[32, uint8]; x25519: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   Conversion to EdDSA
                    ## ```
proc crypto_x25519_inverse*(blind_salt: array[32, uint8];
                            private_key: array[32, uint8];
                            curve_point: array[32, uint8]) {.importc, cdecl.}
  ## ```
                                                                             ##   scalar "division"
                                                                             ##      Used for OPRF.  Be aware that exponential blinding is less secure
                                                                             ##      than Diffie-Hellman key exchange.
                                                                             ## ```
proc crypto_x25519_dirty_small*(pk: array[32, uint8]; sk: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   "Dirty" versions of x25519_public_key().
                    ##      Use with crypto_elligator_rev().
                    ##      Leaks 3 bits of the private key.
                    ## ```
proc crypto_x25519_dirty_fast*(pk: array[32, uint8]; sk: array[32, uint8]) {.
    importc, cdecl.}
proc crypto_eddsa_key_pair*(secret_key: array[64, uint8];
                            public_key: array[32, uint8]; seed: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   Signatures
                    ##      ----------
                    ##      EdDSA with curve25519 + BLAKE2b
                    ## ```
proc crypto_eddsa_sign*(signature: array[64, uint8];
                        secret_key: array[64, uint8]; message: ptr uint8;
                        message_size: uint) {.importc, cdecl.}
proc crypto_eddsa_check*(signature: array[64, uint8];
                         public_key: array[32, uint8]; message: ptr uint8;
                         message_size: uint): cint {.importc, cdecl.}
proc crypto_eddsa_to_x25519*(x25519: array[32, uint8]; eddsa: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   Conversion to X25519
                    ## ```
proc crypto_eddsa_trim_scalar*(`out`: array[32, uint8]; `in`: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   EdDSA building blocks
                    ## ```
proc crypto_eddsa_reduce*(reduced: array[32, uint8]; expanded: array[64, uint8]) {.
    importc, cdecl.}
proc crypto_eddsa_mul_add*(r: array[32, uint8]; a: array[32, uint8];
                           b: array[32, uint8]; c: array[32, uint8]) {.importc,
    cdecl.}
proc crypto_eddsa_scalarbase*(point: array[32, uint8]; scalar: array[32, uint8]) {.
    importc, cdecl.}
proc crypto_eddsa_check_equation*(signature: array[64, uint8];
                                  public_key: array[32, uint8];
                                  h_ram: array[32, uint8]): cint {.importc,
    cdecl.}
proc crypto_chacha20_h*(`out`: array[32, uint8]; key: array[32, uint8];
                        `in`: array[16, uint8]) {.importc, cdecl.}
  ## ```
                                                                  ##   Chacha20
                                                                  ##      --------
                                                                  ##      Specialised hash.
                                                                  ##      Used to hash X25519 shared secrets.
                                                                  ## ```
proc crypto_chacha20_djb*(cipher_text: ptr uint8; plain_text: ptr uint8;
                          text_size: uint; key: array[32, uint8];
                          nonce: array[8, uint8]; ctr: uint64): uint64 {.
    importc, cdecl.}
  ## ```
                    ##   Unauthenticated stream cipher.
                    ##      Don't forget to add authentication.
                    ## ```
proc crypto_chacha20_ietf*(cipher_text: ptr uint8; plain_text: ptr uint8;
                           text_size: uint; key: array[32, uint8];
                           nonce: array[12, uint8]; ctr: uint32): uint32 {.
    importc, cdecl.}
proc crypto_chacha20_x*(cipher_text: ptr uint8; plain_text: ptr uint8;
                        text_size: uint; key: array[32, uint8];
                        nonce: array[24, uint8]; ctr: uint64): uint64 {.importc,
    cdecl.}
proc crypto_poly1305*(mac: array[16, uint8]; message: ptr uint8;
                      message_size: uint; key: array[32, uint8]) {.importc,
    cdecl.}
  ## ```
           ##   Poly 1305
           ##      ---------
           ##      This is aone time* authenticator.
           ##      Disclosing the mac reveals the key.
           ##      See crypto_lock() on how to use it properly.
           ##      Direct interface
           ## ```
proc crypto_poly1305_init*(ctx: ptr crypto_poly1305_ctx; key: array[32, uint8]) {.
    importc, cdecl.}
proc crypto_poly1305_update*(ctx: ptr crypto_poly1305_ctx; message: ptr uint8;
                             message_size: uint) {.importc, cdecl.}
proc crypto_poly1305_final*(ctx: ptr crypto_poly1305_ctx; mac: array[16, uint8]) {.
    importc, cdecl.}
proc crypto_elligator_map*(curve: array[32, uint8]; hidden: array[32, uint8]) {.
    importc, cdecl.}
  ## ```
                    ##   Elligator 2
                    ##      -----------
                    ##      Elligator mappings proper
                    ## ```
proc crypto_elligator_rev*(hidden: array[32, uint8]; curve: array[32, uint8];
                           tweak: uint8): cint {.importc, cdecl.}
proc crypto_elligator_key_pair*(hidden: array[32, uint8];
                                secret_key: array[32, uint8];
                                seed: array[32, uint8]) {.importc, cdecl.}
  ## ```
                                                                          ##   Easy to use key pair generation
                                                                          ## ```
{.pop.}
