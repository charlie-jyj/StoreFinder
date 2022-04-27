//
//  LocationInformationViewModelTests.swift
//  StoreFinderTests
//
//  Created by 정유진 on 2022/04/21.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import StoreFinder

class LocationInformationViewModelTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    let stubNetwork = LocalNetworkStub()
    var model: LocationInformationModel!
    var viewModel: LocationInformationViewModel!
    var doc: [KLDocument]!
    
    override func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        self.viewModel = LocationInformationViewModel(model: model)
        self.doc = cvsList
    }
    
    func testSetMapCenter() {
        let scheduler = TestScheduler(initialClock: 0)
        
        // 더미데이터 이벤트
        // createHotObservable(events: [Recorded<Event<Element>>]
        let dummyDataEvent = scheduler.createHotObservable([
            .next(0, cvsList)
        ])
        
        /*
         cvsLocationDtaValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag) 과 동일하다.
         */
        let documentData = PublishSubject<[KLDocument]>()
        dummyDataEvent
            .subscribe(documentData)
            .disposed(by: disposeBag)
        
        // 1. DetailList 아이템(셀) 탭 이벤트
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0)
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: disposeBag)
        
        // documentData를 받은 후 그것을 source로 하여 selectedItem 의 index로 접근
        let selectedItemMapPoint = itemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map(model.documentToMapPoint)
        
        // 2. 최초 현재 위치 이벤트
        let initialMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(37.394225), longitude: Double(127.110341)))!
        let currentLocationEvent = scheduler.createHotObservable([
            .next(0, initialMapPoint)
        ])
        
        let initialCurrentLocation = PublishSubject<MTMapPoint>()
        currentLocationEvent
            .subscribe(initialCurrentLocation)
            .disposed(by: disposeBag)
        
        // 3. 현재 위치 버튼 탭 이벤트
        let currentLocationButtonTapEvent = scheduler.createHotObservable([
            .next(2, Void()),
            .next(3, Void())
        ])
        
        let currentLocationButtonTapped = PublishSubject<Void>()
        
        currentLocationButtonTapEvent
            .subscribe(currentLocationButtonTapped)
            .disposed(by: disposeBag)
        
        let moveToCurrentLocation =
            currentLocationButtonTapped
            .withLatestFrom(initialCurrentLocation)  // initialCurrentLocation이 최초에 일어난 후에
        
        // merge
        let currentMapCenter = Observable
            .merge(
                selectedItemMapPoint,
                initialCurrentLocation.take(1),
                moveToCurrentLocation
            )
        
        let currentMapCenterObserver =
        scheduler.createObserver(Double.self)
        
        currentMapCenter
            .map { $0.mapPointGeo().latitude }
            .subscribe(currentMapCenterObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        /*
         시나리오
         0 : 최초의 current Location 수집
         1 : tableView의 0번째 행 tap
         2 : current Location button tapped (위치 바뀌지 않기 때문에 경도 동일하다)
         3 : current Location button tapped
         */
        
        let secondMapPoint = model.documentToMapPoint(doc[0])
        
        expect(currentMapCenterObserver.events).to(equal([
            .next(0, initialMapPoint.mapPointGeo().latitude),
            .next(1, secondMapPoint.mapPointGeo().latitude),
            .next(2, initialMapPoint.mapPointGeo().latitude),
            .next(3, initialMapPoint.mapPointGeo().latitude)
        ]))
    }
}
