//
//  ButtonTableViewCell.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    public var onButtonClick: (()->Void)?
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save".uppercased(), for: .normal)
        button.layer.borderWidth = 2
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(saveButton)
        setupConstraints()
        saveButton.addTarget(self, action: #selector(onSaveClick), for: .touchUpInside)
    }
    
    private func setupConstraints(){
        saveButton.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    @objc func onSaveClick(){
        onButtonClick?()
    }
    
    public func configureCell(isEnable: Bool){
        saveButton.isEnabled = isEnable
    }

}
