//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Konstantin on 12.02.2024.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        let array = [1,1,2,3,4]
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutRange() throws {
        let array = [1,1,2,3,4]
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}
