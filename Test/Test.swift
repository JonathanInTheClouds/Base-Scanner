//
//  Test.swift
//  Test
//
//  Created by Mettaworldj on 4/25/21.
//

import XCTest
import SwiftUI
@testable import Base_Scan

class Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageRecognitions() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var string = ""
        
        let bString:Binding<String> = .init { () -> String in
            return string
        } set: { (txt) in
            string = txt
        }

        let scanDocumentView = ScanDocumentView(recognizedText: bString)
        let coordinator = Coordinator(recognizedText: bString, parent: scanDocumentView)
        
        guard let binaryUIImage = UIImage(named: "binary"), let binaryCGImage = binaryUIImage.cgImage else { return XCTFail("Image not found!") }
        
        let images = [binaryCGImage]
        let results = coordinator.recognizedText(from: images)
        XCTAssertEqual(results, "010101010101010101010101010101")
    }
    
    func testConversions() throws {
        let baseCoverter = BaseConverter()
        
        guard let value1 = baseCoverter.convert(fromBase: "2", fromNumber: "010101010101010101010101010101", toBase: "10") else { return XCTFail("Conversion Fail") }
        XCTAssertEqual(value1, "357913941")
        
        guard let value2 = baseCoverter.convert(fromBase: "2", fromNumber: "010101010101010101010101010101", toBase: "16") else { return XCTFail("Conversion Fail") }
        XCTAssertEqual(value2, "15555555")
        
        guard let value3 = baseCoverter.convert(fromBase: "2", fromNumber: "010101010101010101010101010101", toBase: "23") else { return XCTFail("Conversion Fail") }
        XCTAssertEqual(value3, "29DMHKG")
        
        guard let value4 = baseCoverter.convert(fromBase: "2", fromNumber: "010101010101010101010101010101", toBase: "32") else { return XCTFail("Conversion Fail") }
        XCTAssertEqual(value4, "ALALAL")
        
        guard let value5 = baseCoverter.convert(fromBase: "2", fromNumber: "010101010101010101010101010101", toBase: "36") else { return XCTFail("Conversion Fail") }
        XCTAssertEqual(value5, "5X3C5X")
        
    }
    

}
