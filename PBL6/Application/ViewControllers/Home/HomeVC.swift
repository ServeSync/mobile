//
//  HomeVC.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import UIKit

class HomeVC: BaseVC<HomeVM> {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var happenningCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var doneCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error,
                                                                  description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
    }

    override func initViews() {
        super.initViews()
        
        searchTextField.setLeftPaddingPoints(56)
    }
    
    override func configureListView() {
        super.configureListView()
        
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.registerCellNib(EventItemCell.self)
        
        happenningCollectionView.dataSource = self
        happenningCollectionView.delegate = self
        happenningCollectionView.registerCellNib(EventItemCell.self)
        
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
        upcomingCollectionView.registerCellNib(EventItemCell.self)
        
        doneCollectionView.dataSource = self
        doneCollectionView.delegate = self
        doneCollectionView.registerCellNib(EventItemCell.self)
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == happenningCollectionView {
            return viewModel.hapeningEvents.count
        } else if collectionView == upcomingCollectionView {
            return viewModel.upcomingEvents.count
        } else if collectionView == doneCollectionView {
            return viewModel.doneEvents.count
        } else {
            return viewModel.favoriteEvents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventItemCell.identifier, for: indexPath) as! EventItemCell
        
        if collectionView == happenningCollectionView {
            cell.configure(item: viewModel.hapeningEvents[indexPath.row])
        } else if collectionView == upcomingCollectionView {
            cell.configure(item: viewModel.upcomingEvents[indexPath.row])
        } else if collectionView == doneCollectionView {
            cell.configure(item: viewModel.doneEvents[indexPath.row])
        } else {
            cell.configure(item: viewModel.favoriteEvents[indexPath.row])
        }
        
        return cell
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 256)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
