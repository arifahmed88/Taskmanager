//
//  TaskCollectionViewCell.swift
//  TaskManager
//
//  Created by ArifAhmed on 27/6/24.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var holderVIew: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    
    static let identifier = "TaskCollectionViewCell"
    
    var taskDeleteAction: (()->Void)? = nil
    var taskEditAction: (()->Void)? = nil
    var taskCheckAction: ((Bool)->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewInit()
    }
    
    private func viewInit(){
        holderVIew.clipsToBounds = true
        holderVIew.layer.masksToBounds = true
        holderVIew.layer.cornerRadius = 6
        checkBoxSetup()
    }
    
    private func checkBoxSetup(){
        checkBox.isChecked = false
        checkBox.style = .tick
        checkBox.borderStyle = .roundedSquare(radius: 2)
        checkBox.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        print("oni1 = \(sender.isChecked)")
        
        labelTextUpdate(text: titleLabel.attributedText?.string ?? "", label: titleLabel, isChecked: sender.isChecked)
        labelTextUpdate(text: titleDescription.attributedText?.string ?? "", label: titleDescription, isChecked: sender.isChecked)
        taskCheckAction?(sender.isChecked)
    }
        
    func setupCell(title:String?,description:String?,date:Date?,isChecked:Bool){
        labelTextUpdate(text: title ?? "", label: titleLabel, isChecked: isChecked)
        labelTextUpdate(text: description ?? "", label: titleDescription, isChecked: isChecked)
        
        
        let dateText:String
        if let newDate = date{
            let dateFormatter = DateFormatter.localizedString(from: newDate, dateStyle: .medium, timeStyle: .short)
            dateText = "\(dateFormatter)"
        } else {
            dateText = ""
        }
        labelTextUpdate(text: dateText, label: dateLabel, isChecked: false)
        checkBox.isChecked = isChecked
    }
    
    private func labelTextUpdate(text:String, label:UILabel, isChecked:Bool){
        label.updateTextWithStrikeThrough(labelText: text, isStrikeThrough: isChecked)
        label.sizeToFit()
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        taskDeleteAction?()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        taskEditAction?()
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
