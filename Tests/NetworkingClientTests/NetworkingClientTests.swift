import pingx
import XCTest
@testable import NetworkingClient

final class NetworkingClientTests: XCTestCase {
    
    func testProfileAndHistory() async throws {
        let _ = await NetworkingClient.shared.profile()
        let history = await NetworkingClient.shared.history
        XCTAssertNotNil(history.count > 0)
    }
    
    func testAverageOrGrouping() async throws {
        let _ = await NetworkingClient.shared.profile()
        let grouped = await NetworkingClient.shared.averageDurationPerHour()
        XCTAssertTrue(grouped.count > 0)
    }
    
    func testSaveToDevice() async throws {
        let _ = await NetworkingClient.shared.profile()
        let data = await NetworkingClient.shared.getDataFromDevice()
        XCTAssertTrue(data.keys.count > 0)
        XCTAssertTrue(data.values.count > 0)
    }
}
