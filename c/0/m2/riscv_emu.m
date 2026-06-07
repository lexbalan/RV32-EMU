

public const mmioStart = 0xF00C0000
public const mmioSize = 0xFFFF
public const mmioEnd = mmioStart + mmioSize

public const consoleMMIOAdr = mmioStart + 0x10
public const consolePrintChar8Adr = consoleMMIOAdr + 0x00
public const consoleScanChar8Adr = consoleMMIOAdr + 0x01
public const consolePrintInt32Adr = consoleMMIOAdr + 0x10
public const consolePrintUInt32Adr = consoleMMIOAdr + 0x14
public const consolePrintInt32HexAdr = consoleMMIOAdr + 0x18
public const consolePrintUInt32HexAdr = consoleMMIOAdr + 0x1C

