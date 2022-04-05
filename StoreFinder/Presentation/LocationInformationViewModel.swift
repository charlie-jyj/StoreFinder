//
//  LocationInformationViewModel.swift
//  StoreFinder
//
//  Created by 정유진 on 2022/04/05.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationInformationViewModel {
    let disposeBag = DisposeBag()
   
    // viewModel -> view
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    
    // view -> viewmodel
    let currentLocationButtonTapped = PublishRelay<Void>()
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    
    init() {
        //MARK: 지도 중심점 설정
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation) // current location을 한 번이라도 받은 이 후에 (최초 한 번이 count되지 않음)
        
        // when? 최초 currentLocation 을 받을 때 + currentLocationButton이 tapped 되었을 때 => setMapCenter Signal 전달
        let currentMapCenter = Observable
            .merge(
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
    }
}
