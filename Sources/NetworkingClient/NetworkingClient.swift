// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import pingx

actor NetworkingClient {
    let key = "networking.data"
    let pinger: AsyncPinger
    let request: Request
    var history: [String: Double]
    public static let shared = NetworkingClient()
    
    public init(pinger: AsyncPinger = AsyncPinger(configuration: PingConfiguration(intervalBetweenRequests: .seconds(5.0 * 60.0))),
         request: Request = Request(destination: IPv4Address(address: (8, 8, 8, 8)), timeoutInterval: .seconds(60), demand: .unlimited),
                 history: [String: Double] = [:]) {
        self.pinger = pinger
        self.request = request
        self.history = history
    }
    
    public func profile() async {
        let sequence = pinger.ping(request: request)

        do {
            for try await result in sequence {
                switch result {
                case .success(let response):
                    print(response.duration)
                    let dateAsString = Date().ISO8601Format()
                    history[dateAsString] = response.duration.seconds
                case .failure(let error):
                    print(error.localizedDescription)
                }
                UserDefaults.standard.set(history, forKey: key)
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
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
