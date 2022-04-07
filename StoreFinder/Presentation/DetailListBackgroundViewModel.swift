//
//  DetailListBackgroundViewModel.swift
//  StoreFinder
//
//  Created by 정유진 on 2022/04/07.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    // viewmodel -> view
    let isStatusLabelHidden: Signal<Bool>
    
    // viewmodel -> viewmodel
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
