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
    let currentLocationButtonTapped = PublishRelay<Void>()
}
