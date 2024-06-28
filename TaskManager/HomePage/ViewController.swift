//
//  ViewController.swift
//  TaskManager
//
//  Created by ArifAhmed on 27/6/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewPreviousSelectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    var viewModel = TaskDataListInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateList()
        allViewPropertySetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionViewUpdate()
    }
    
    private func allViewPropertySetup(){
        viewCornerradiusAdd(view: addItemButton, radius: addItemButton.frame.height*0.5)
        showDate()
        configureCollectionView()
    }
    
   
    
    private func configureCollectionView() {
        
        let customFlowLayout = CustomCVLayout()
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 16
        customFlowLayout.minimumLineSpacing = 16
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 22, bottom: 44, right: 22)
        collectionView.collectionViewLayout = customFlowLayout
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        
        collectionView.clipsToBounds = true
        
        let nib = UINib(nibName: TaskCollectionViewCell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        collectionView.dataSource = self
    }
    
    private func showDate(){
        let dateFormatter = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        datelabel.text = "\(dateFormatter)"
    }
    
    private func viewCornerradiusAdd(view:UIView,radius:CGFloat){
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = radius
    }
    
    @IBAction func addItemButtonAction(_ sender: Any) {
        let vc = TaskEditViewController()
        vc.delegate = self
        vc.configureVC(state: .new, data: nil)
        present(vc, animated: true)
    }
    
    @IBAction func deleteAllbuttonAction(_ sender: Any) {
        showAlertForDeleteAllBtnAction()
    }
    
    @IBAction func syncButtonAction(_ sender: Any) {
    }
    
    func showAlertForDeleteAllBtnAction() {
        let alert = UIAlertController(title: "Delete All", message: "Are you sure you want to remove All Tsaks? Your data will be lost permanently.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {[weak self] (_: UIAlertAction!) in
            
            self?.viewModel.removeAllItem()
            self?.collectionViewUpdate()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    
    private func collectionViewUpdate(){
        deleteAllButton.isHidden = (viewModel.getTotalDataCount() == 0)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {[weak self] in
            self?.collectionView.reloadData()
        })
    }
    
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getTotalDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.identifier, for: indexPath) as? TaskCollectionViewCell{
            let taskInfo = viewModel.getData(index: indexPath.item)
            
            let title = "\(indexPath.item+1). \(taskInfo?.title ?? "")"
            cell.setupCell(title: title, description: taskInfo?.taskDescription, date: taskInfo?.dueDate, isChecked: taskInfo?.isChecked ?? false)
            
           
            let id = taskInfo?.uniqueID
            cell.taskDeleteAction = {[weak self] in
                if let id{
                    self?.viewModel.removeItem(id: id)
                    self?.collectionViewUpdate()
                }
            }
            
            cell.taskEditAction = {[weak self] in
                self?.gotoTaskEditPage(taskIndex: indexPath.item)
            }
            
            cell.taskCheckAction = {[weak self] isChecked in
                self?.viewModel.updateItemCheckState(isChecked: isChecked, index: indexPath.item)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func gotoTaskEditPage(taskIndex:Int){
        
        let task = viewModel.getData(index: taskIndex)
        let vc = TaskEditViewController()
        vc.delegate = self
        vc.configureVC(state: .update, data: task)
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == collectionViewPreviousSelectedIndex{
            return
        }
        
        collectionViewPreviousSelectedIndex = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionViewUpdate()
    }
}

extension ViewController: TaskEditViewControllerDelegate {
    func addButtonPressAction() {
        viewModel.updateList()
        collectionViewUpdate()
    }
    
    func cancelButtonPressAction() {
        
    }
}
