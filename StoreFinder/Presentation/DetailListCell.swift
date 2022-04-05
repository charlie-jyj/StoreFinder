//
//  DetailListCell.swift
//  StoreFinder
//
//  Created by 정유진 on 2022/04/05.
//

import UIKit
import SnapKit

class DetailListCell: UITableViewCell {
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: DetailListCellData){
        placeNameLabel.text = data.placeName
        addressLabel.text = data.address
        distanceLabel.text = data.distance
    }
    
    private func attribute() {
        backgroundColor = .white
        placeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .darkGray
    }
    
    private func layout() {
        [placeNameLabel, addressLabel, distanceLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
    }
}
