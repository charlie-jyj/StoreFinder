//
//  LocalNetworkStub.swift
//  StoreFinderTests
//
//  Created by 정유진 on 2022/04/12.
//

import Foundation
import RxSwift
import Stubber

@testable import StoreFinder

class LocalNetworkStub: LocalNetwork {
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation, args: mapPoint)
    }
}
