//
//  SevenMilesTests.swift
//  SevenMilesTests
//
//  Created by SEAN BLAKE on 12/11/21.
//

import XCTest

@testable import SevenMiles

class SevenMilesTests: XCTestCase {
    func testPostModelChildPath() {
        let id = UUID().uuidString
        let user = User(username: "lenablack",
                        profilePictureURL: nil,
                        indentifier: "123")
        let post = PostModel(identifier: id,
                             user: user)
        XCTAssertTrue(post.caption.isEmpty)
//        post.caption = "WhaGwaan"
//        XCTAssertFalse(post.caption.isEmpty)
//        XCTAssert(post.caption, "WhagWAAN")
//        XCTAssertEqual(post.videoChildPath, "videos/lenablack/")
    }
}
