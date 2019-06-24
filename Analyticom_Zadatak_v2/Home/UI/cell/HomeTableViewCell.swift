//
//  HomeTableViewCell.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "play")
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubviews(playImage, titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints(){
        containerView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview()
            maker.trailing.equalTo(contentView.snp.centerX)
        }
        
        playImage.snp.makeConstraints { (maker) in
            maker.size.equalTo(25)
            maker.leading.equalTo(containerView).offset(15)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(playImage.snp.trailing).offset(15)
            maker.centerY.equalTo(playImage)
        }
    }
    
    public func configureCell(data: String){
        titleLabel.text = data
    }

}
