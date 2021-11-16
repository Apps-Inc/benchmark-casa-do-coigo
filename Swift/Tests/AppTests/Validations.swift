@testable import App
import XCTVapor

final class ValidatorTests: XCTestCase {
    func testCpfValidator() throws {
        // Passing cases
        XCTAssertTrue(isValidCpf("11600297684"))
        XCTAssertTrue(isValidCpf("116.002.976-84"))
        XCTAssertTrue(isValidCpf("116 002 976 84"))

        // Failing cases
        XCTAssertFalse(isValidCpf("123.456.789-02"))
        XCTAssertFalse(isValidCpf("23.456.789-02"))
        XCTAssertFalse(isValidCpf("1160097684"))
        XCTAssertFalse(isValidCpf(""))
        XCTAssertFalse(isValidCpf("\016 002 976 84"))
        XCTAssertFalse(isValidCpf("116 002 976 94"))
    }

    func testCnpjValidator() throws {
        // passing cases
        XCTAssertTrue(isValidCnpj("22779182000183"))
        XCTAssertTrue(isValidCnpj("22 779 182 0001 83"))
        XCTAssertTrue(isValidCnpj("22.779.182/0001-83"))

        // failing cases
        XCTAssertFalse(isValidCnpj("2.779.182/0001-73"))
        XCTAssertFalse(isValidCnpj(""))
        XCTAssertFalse(isValidCnpj("22.779.182/0001-73"))
        XCTAssertFalse(isValidCnpj("22.779.182/0001-82"))
    }
}

func isValidCpf(_ str: String) -> Bool {
    !Validator<String>.cpfCnpj.validate(str).isFailure
}

func isValidCnpj(_ str: String) -> Bool {
    !Validator<String>.cpfCnpj.validate(str).isFailure
}