import nimterop/[build, cimport]
import os

const
  src = currentSourcePath.parentDir/"build"

static:
  gitPull("https://github.com/LoupVaillant/Monocypher.git", checkout = "3.1.2", outdir = src)

static:
  cCompile(src/"src"/"monocypher.c")

cImport(src/"src"/"monocypher.h")

template crypto_key_exchange_public_key*(args: varargs[untyped]) =
  crypto_x25519_public_key(args)
