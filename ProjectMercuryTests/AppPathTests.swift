//
//  ProjectMercuryTests.swift
//  ProjectMercuryTests
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import XCTest
@testable import ProjectMercury
    
final class ProjectMercuryTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppPathParsing() {
        
        let appPaths: [AppPath?] = [
            AppPath(pathComponents: ["home", "whats-new"], query: [:]),
            AppPath(pathComponents: ["home"], query: [:]),
            AppPath(pathComponents: ["lost-money"], query: [:]),
            AppPath(pathComponents: ["lost-money-detail"], query: [:]),
            AppPath(pathComponents: [], query: ["pocket": "invest"]),
            AppPath(pathComponents: ["pockets"], query: [:]),
            AppPath(pathComponents: ["cashback"], query: [:]),
            AppPath(pathComponents: ["cashback-detail"], query: [:]),
            AppPath(pathComponents: ["investments"], query: ["fund_name": "Balanced Bundle"]),
            AppPath(pathComponents: ["investments", "Tech Giants"], query: [:]),
            AppPath(pathComponents: ["subscriptions"], query: [:])
        ]
        
        guard case AppPath.home? = appPaths[0] else { XCTFail(); return }
        guard case AppPath.home? = appPaths[1] else { XCTFail(); return }
        guard case AppPath.lostMoney? = appPaths[2] else { XCTFail(); return }
        guard case AppPath.lostMoneyDetail? = appPaths[3] else { XCTFail(); return }
        guard case AppPath.home? = appPaths[4] else { XCTFail(); return }
        guard case AppPath.pockets? = appPaths[5] else { XCTFail(); return }
        guard case AppPath.cashback? = appPaths[6] else { XCTFail(); return }
        guard case AppPath.cashbackDetail? = appPaths[7] else { XCTFail(); return }
        
        if case let AppPath.investments(urlName) = appPaths[8]! {
            XCTAssert(urlName == "Balanced Bundle")
        } else {
            XCTFail()
        }
        
        if case let AppPath.investments(urlName) = appPaths[9]! {
            XCTAssert(urlName == "Tech Giants")
        } else {
            XCTFail()
        }
        
        if case let AppPath.unknown(urlName) = appPaths[10]! {
            XCTAssert(urlName == "subscriptions")
        } else {
            XCTFail()
        }
        
    }
    
}
