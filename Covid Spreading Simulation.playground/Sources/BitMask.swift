public struct BitMask {
    public static let player: UInt32 = 1 << 1
    public static let enemy: UInt32 = 1 << 2
    public static let uninfectedPerson: UInt32 = 1 << 3
    public static let maskedPerson: UInt32 = 1 << 4
    public static let unmaskedPerson: UInt32 = 1 << 5
}
