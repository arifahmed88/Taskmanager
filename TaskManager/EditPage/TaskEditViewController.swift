//
//  TaskEditViewController.swift
//  TaskManager
//
//  Created by ArifAhmed on 27/6/24.
//

import UIKit

protocol TaskEditViewControllerDelegate:AnyObject{
    func addButtonPressAction()
    func cancelButtonPressAction()
}

enum TaskEditState{
    case new, update
}

class TaskEditViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descripTionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate:TaskEditViewControllerDelegate?
    private var previousTaskdata:TaskCoreDataInfo?
    private var state:TaskEditState = .new
    private var viewModel = HomeViewModel()
    
    var service:TaskManagerService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allViewPropertySetup()
    }
    
    
    private func allViewPropertySetup(){
        allTextfieldSetup()
        datePickerSetup()
        textUpdate()
        viewCornerradiusAdd(view: titleTextView, radius: 8)
        viewCornerradiusAdd(view: descripTionTextView, radius: 8)
    }
    
    private func allTextfieldSetup(){
        titleTextView.delegate = self
        descripTionTextView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textViewDoneButtonTapped))

        toolbar.setItems([flexible, doneButton], animated: false)
        titleTextView.inputAccessoryView = toolbar
        descripTionTextView.inputAccessoryView = toolbar
        
    }
    
    func configureVC(state:TaskEditState, data: TaskCoreDataInfo?, service:TaskManagerService?){
        self.service = service
        self.state = state
        self.previousTaskdata = data
    }
    
    private func textUpdate(){
        if state == .update {
            labelTextUpdate(text: "Update Task", label: viewTitleLabel)
            saveButton.setTitle("Update", for: .normal)
            if let previousTaskdata{
                titleTextView.text = previousTaskdata.title
                descripTionTextView.text = previousTaskdata.taskDescription
                datePicker.date = previousTaskdata.dueDate ?? Date()
            } else {
                titleTextView.text = ""
                descripTionTextView.text = ""
                datePicker.date = .now
            }
        } else {
            labelTextUpdate(text: "Add New Task", label: viewTitleLabel)
            saveButton.setTitle("Save", for: .normal)
            titleTextView.text = ""
            descripTionTextView.text = ""
            datePicker.date = .now
        }
    }
    
    private func labelTextUpdate(text:String, label:UILabel){
        label.text = text
        label.sizeToFit()
    }
    
   
    private func datePickerSetup(){
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        if let color = UIColor(named: "ThemeColor"){
            datePicker.tintColor = color
        }
    }
    
    private func viewCornerradiusAdd(view:UIView,radius:CGFloat){
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = radius
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
        delegate?.cancelButtonPressAction()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if saveValidityCheck(){
            if state == .new{
                let title = titleTextView.text ?? ""
                let titleDes = descripTionTextView.text ?? ""
                let dueDate = datePicker.date
                let taskInfo = TaskDataModel(title: title, description: titleDes, dueDate: dueDate)
                
                service?.addTask(taskInfo: taskInfo)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.02, execute: {[weak self] in
                    self?.delegate?.addButtonPressAction()
                    self?.dismiss(animated: true)
                })
            } else {
                previousTaskdata?.title = titleTextView.text
                previousTaskdata?.taskDescription = descripTionTextView.text
                previousTaskdata?.dueDate = datePicker.date
                
                
                if let previousTaskdata{
                    service?.updateTask(task: previousTaskdata)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.02, execute: {[weak self] in
                    self?.delegate?.addButtonPressAction()
                    self?.dismiss(animated: true)
                })
                
            }
        }
        
    }
    
    
    private func saveValidityCheck()->Bool{
        if let title  = titleTextView.text{
            if title.trimmingCharacters(in: .whitespaces) == ""{
                showAlert(text: "Title field empty")
                return false
            }

        } else if let des  = descripTionTextView.text{
            if des.trimmingCharacters(in: .whitespaces) == ""{
                showAlert(text: "Description field empty")
                return false
            }
        }
        
        return true
    }
    
    
    @objc func textViewDoneButtonTapped() {
        titleTextView.resignFirstResponder()
        descripTionTextView.resignFirstResponder()
    }
    
    
    func showAlert(text:String) {
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }

    
}

extension TaskEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}



