import pingx
import XCTest
@testable import NetworkingClient

final class NetworkingClientTests: XCTestCase {
    var networkingClient: NetworkingClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let pings = UInt(5)
        let intervalBetweenRequests = 1.0
        let pinger = AsyncPinger(configuration: PingConfiguration(intervalBetweenRequests: .seconds(intervalBetweenRequests)))
        let request = Request(destination: IPv4Address(address: (8, 8, 8, 8)), timeoutInterval: .seconds(60), demand: .max(pings))
        networkingClient = NetworkingClient(pinger: pinger, request: request)
    }
    
    func testProfileAndHistory() async throws {
        let _ = await networkingClient.profile()
        let history = await NetworkingClient.shared.history
        XCTAssertNotNil(history)
    }
    
    func testAverageOrGrouping() async throws {
        let _ = await networkingClient.profile()
        let grouped = await networkingClient.averageDurationPerHour()
        XCTAssertTrue(grouped.count > 0)
    }
    
    func testSaveToDevice() async throws {
        let _ = await networkingClient.profile()
        let data = await networkingClient.getDataFromDevice()
        XCTAssertTrue(data.keys.count > 0)
        XCTAssertTrue(data.values.count > 0)
    }
}
