import XCTest
@testable import TKTranslateSDK

final class TKTranslateSDKTests: XCTestCase {
    func testTranslateReturnsInputForNow() {
        let input = "Hello"
        let output = TKTranslateSDK.translate(input, to: "zh")
        XCTAssertTrue(output.contains(input))
    }

    func testTranslateBatch() {
        let inputs = ["Hi", "World"]
        let outputs = TKTranslateSDK.translateBatch(inputs, to: "zh")
        XCTAssertEqual(outputs.count, inputs.count)
        XCTAssertTrue(outputs[0].contains(inputs[0]))
        XCTAssertTrue(outputs[1].contains(inputs[1]))
    }

    func testSupportedLanguagesContainsEnglish() {
        let languages = TKTranslateSDK.supportedLanguages()
        XCTAssertTrue(languages.contains("en"))
    }

    func testDetectLanguage() {
        XCTAssertEqual(TKTranslateSDK.detectLanguage(of: "Hello"), "en")
        XCTAssertEqual(TKTranslateSDK.detectLanguage(of: "你好"), "zh")
        XCTAssertEqual(TKTranslateSDK.detectLanguage(of: ""), "und")
    }

    func testNormalizeTrimsWhitespace() {
        let input = "  hello \n"
        XCTAssertEqual(TKTranslateSDK.normalize(input), "hello")
    }
}
