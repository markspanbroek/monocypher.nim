type
  Bytes* = openArray[byte]

func pointerAndLength*(bytes: Bytes): (ptr[byte], uint) =
  result = (unsafeAddr bytes[0], uint(len(bytes)))
