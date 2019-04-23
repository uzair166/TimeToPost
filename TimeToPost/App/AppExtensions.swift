import Foundation

// MARK: Formatter

extension Formatter {
    static let withPoint: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

// MARK: Integer

extension BinaryInteger {
    var formattedWithPoint: String {
        return Formatter.withPoint.string(for: self) ?? ""
    }
}

// MARK: String

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
