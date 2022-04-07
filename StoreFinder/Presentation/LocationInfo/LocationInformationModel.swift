//
//  LocationInformationModel.swift
//  StoreFinder
//
//  Created by 정유진 on 2022/04/07.
//

import Foundation
import RxSwift

struct LocationInformationModel {
    let localNetwork: LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocation(by: mapPoint)
    }
    
    func documentToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data.map {
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMapPoint($0)
            return DetailListCellData(placeName: $0.placeName, address: address, distance: $0.distance, point: point)
        }
    }
    
    private func documentToMapPoint(_ doc: KLDocument) -> MTMapPoint {
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(doc.x) ?? .zero, longitude: Double(doc.y) ?? .zero))
    }
    
}
