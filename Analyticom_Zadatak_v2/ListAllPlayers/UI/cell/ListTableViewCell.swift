//
//  ListTableViewCell.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "play")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateFromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date from:"
        return label
    }()
    
    let dateFromValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateToLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date to:"
        return label
    }()
    
    let dateToValue: UILabel = {
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
        contentView.addSubviews(playImage, nameLabel, clubLabel, dateFromLabel, dateFromValue, dateToLabel, dateToValue,  separatorView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        separatorView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(dateFromLabel.snp.bottom).offset(15)
            maker.height.equalTo(2)
        }
        
        playImage.snp.makeConstraints { (maker) in
            maker.size.equalTo(25)
            maker.leading.equalTo(contentView).offset(15)
            maker.top.equalTo(contentView).offset(5)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(playImage.snp.trailing).offset(5)
            maker.centerY.equalTo(playImage)
            maker.trailing.equalTo(contentView)
        }
        
        clubLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(playImage)
            maker.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        dateFromLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(playImage)
            maker.top.equalTo(clubLabel.snp.bottom).offset(3)
        }
        
        dateFromValue.snp.makeConstraints { (maker) in
            maker.leading.equalTo(dateFromLabel.snp.trailing).offset(3)
            maker.top.equalTo(dateFromLabel)
        }
        
        dateToLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(dateFromValue.snp.trailing).offset(3)
            maker.top.equalTo(dateFromLabel)
        }
        
        dateToValue.snp.makeConstraints { (maker) in
            maker.leading.equalTo(dateToLabel.snp.trailing).offset(3)
            maker.top.equalTo(dateFromLabel)
        }
        
    }
    
    public func configureCell(data: PlayersListDataSource){
        nameLabel.text = data.name
        clubLabel.text = data.club
        dateFromValue.text = stringFromDate(data.dateFrom)
        dateToValue.text = stringFromDate(data.dateTo)
    }
    
    private func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter.string(from: date)
    }

}
