FUNCTION generate_sec_random.

  ASSERT length > 0.

  WRITE '@KERNEL const crypto = await import("crypto");'.
  WRITE '@KERNEL random.set(crypto.randomBytes(length.get()).toString("hex").toUpperCase());'.
*  WRITE '@KERNEL console.dir(random);'.

ENDFUNCTION.