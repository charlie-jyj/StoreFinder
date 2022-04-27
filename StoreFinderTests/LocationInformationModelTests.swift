//
//  LocationInformationModelTests.swift
//  StoreFinderTests
//
//  Created by 정유진 on 2022/04/12.
//

import XCTest
import Nimble

@testable import StoreFinder

class LocationInformationModelTests: XCTestCase {
    let stubNetwork = LocalNetworkStub()
    var doc: [KLDocument]!
    var model: LocationInformationModel!
    
    override func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        self.doc = cvsList // 전역 변수
    }
    
    func testDocumentsToCellData() {
        let cellData = model.documentToCellData(doc)
        let placeName = doc.map { $0.placeName }
        
        expect(cellData.map { $0.placeName }).to(equal(placeName), description: "DetailListCellData의 placeName은 document의 placename 이다.")
        
        let address0 = cellData[1].address
        let roadAddressName = doc[1].roadAddressName
        
        expect(address0).to(equal(roadAddressName), description: "KLDocument의 RoadAddressName이 빈 값이 아닐 경우 roadAddress가 cellData에 전달된다.")
    }

}
