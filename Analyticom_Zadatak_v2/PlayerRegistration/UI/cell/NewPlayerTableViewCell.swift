//
//  NewPlayerTableViewCell.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift

class NewPlayerTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        return textField
    }()
    
    var onTextEdit: ((_ text: String) -> Void)?
    private var secureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    private var clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueTextField.isUserInteractionEnabled = true
        disposeBag = DisposeBag() // this resets the cell's bindings
    }

    
    private func setupUI(){
        selectionStyle = .none
        contentView.addSubviews(titleLabel, valueTextField )
        setupConstraints()
    }
    
    private func setupConstraints(){
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview().inset(10)
            maker.trailing.equalTo(contentView.snp.centerX)
        }
        
        valueTextField.snp.makeConstraints { (maker) in
            maker.leading.equalTo(contentView.snp.centerX)
            maker.trailing.equalToSuperview().offset(-5)
            maker.centerY.equalTo(titleLabel)
        }
    }
    
    public func configureCell(data: RegistartionTableSource, type: RegistrationTableType){
        titleLabel.text = data.label
        valueTextField.text = data.value
        restoreTextState(type: type)
    }
    
    private func restoreTextState(type: RegistrationTableType){
        if type == .dateInput {
            self.setupDateButton()
            self.valueTextField.isSecureTextEntry = true
        } else if type == .customInput {
            self.setupClearValueButton()
            self.valueTextField.isSecureTextEntry = false
        } else {
            self.valueTextField.rightView = nil
            self.valueTextField.isSecureTextEntry = false
        }
    }
    
    private func setupDateButton() {
        self.secureButton.setImage(UIImage(named: "play"), for: .normal)
        self.secureButton.addTarget(self, action: #selector(self.resetValue), for: .touchUpInside)
        self.secureButton.contentMode = .center
        
        self.valueTextField.rightView = self.secureButton
        self.valueTextField.rightViewMode = .always
        
    }
    
    private func setupClearValueButton() {
        self.clearButton.setImage(UIImage(named: "play"), for: .normal)
        self.clearButton.addTarget(self, action: #selector(self.resetValue), for: .touchUpInside)
        self.clearButton.contentMode = .center
        self.valueTextField.rightView = self.clearButton
        self.valueTextField.rightViewMode = .always
    }
    
    @objc public func resetValue() {
        self.valueTextField.text = ""
    }


    
    public func setupPublisher(){
        valueTextField.rx.text.orEmpty
            .debounce(RxTimeInterval.init(exactly: 0.03) ?? 0.03, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .distinctUntilChanged()
            .enumerated()
            .skipWhile({ $0.index == 0 })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (string) in
                self.onTextEdit?(string.element)
            }, onError: { (error) in
                debugPrint(error)
            }).disposed(by: disposeBag)
    }


}
