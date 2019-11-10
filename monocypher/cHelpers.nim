type
  Bytes* = openArray[byte]

func pointerAndLength*(bytes: Bytes): (ptr[byte], uint) =
  result = (cast[ptr[byte]](unsafeAddr bytes), uint(len(bytes)))
