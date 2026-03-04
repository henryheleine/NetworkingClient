// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public actor NetworkingClient {
    let key = "networking.data"
    var request: URLRequest
    var history: [String: Double]
    public static let shared = NetworkingClient()
    
    public init(request: URLRequest = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/upload/\(Int.random(in: 0...1000000))")!), history: [String: Double] = [:]) {
        self.request = request
        self.request.httpMethod = "POST"
        self.history = history
    }
    
    public func profile() async {
        let start = Date()
        do {
            let _ = try await URLSession.shared.data(for: request)
            let duration = Date().timeIntervalSince(start)
            self.saveAndUpdateHistory(duration: duration)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func saveAndUpdateHistory(duration: Double) {
        let date = Date().ISO8601Format()
        history[date] = duration
        UserDefaults.standard.set(history, forKey: key)
    }
    
    public func averageDurationPerHour() -> [Date: Double] {
        // @example = [ 9am: 0.5s, 10am: 0.75s, 11am: 1.8s, 5pm: 0.4s ]
        return Dictionary(grouping: history) {
            Calendar.current.dateInterval(of: .hour, for: $0.key.dateFromString())!.start
        }
        .mapValues { entries in
            let timestamps = entries.compactMap { $0.value }
            let total = timestamps.reduce(0, +)
            return total / Double(timestamps.count)
        }
    }
    
    public func getDataFromDevice() -> [String: Double?] {
        if let data = UserDefaults.standard.object(forKey: key) as? [String: Double?] {
            return data
        }
        return [String: Double?]()
    }
}

extension String {
    var isoFormatter: ISO8601DateFormatter {
        return ISO8601DateFormatter()
    }
    
    public func dateFromString() -> Date {
        return isoFormatter.date(from: self) ?? Date()
    }
}

extension Date {
    var isoFormatter: ISO8601DateFormatter {
        return ISO8601DateFormatter()
    }
    
    public func dateToString() -> String {
        return isoFormatter.string(from: self)
    }
}
