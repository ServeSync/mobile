//
//  SearchVC.swift
//  PBL6
//
//  Created by KietKoy on 05/11/2023.
//

import UIKit
import RxDataSources

class SearchVC: BaseVC<SearchVM> {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    private var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initViews() {
        super.initViews()
        
        searchTextField.delegate = self
        searchTextField.setLeftPaddingPoints(56)
        searchTextField.setRightPaddingPoints(48)
        
        headerView.roundDifferentCorners(bottomLeft: 24,
                                         bottomRight: 24)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        searchButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                viewModel.searchEvent(keyword: searchTextField.text ?? "")
                    .subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            return
                        case .Error(let error):
                            if error?.code == Configs.Server.errorCodeRequiresLogin {
                                AppDelegate.shared().windowMainConfig(vc: LoginVC())
                            } else {
                                viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                            }
                        }
                    })
                    .disposed(by: bag)
            })
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.pushVC(EventDetailVC(eventId: item.id))
            })
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        let layout = ColumnFlowLayout(cellsPerRow: 2, ratio: 222/168, minimumInteritemSpacing: 8, minimumLineSpacing: 8, scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
        collectionView.registerCellNib(MyEventCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSAttributedString.Key.foregroundColor: "text".toUIColor()])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor  = "Primary".toUIColor()
        collectionView.refreshControl = self.refreshControl
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.messageData.asObservable()
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                AlertVC.showMessage(self, message: AlertMessage(type: alert.type,
                                                                description: alert.description)) {}
            })
            .disposed(by: bag)
        
        viewModel.eventsData
            .do{ [weak self] data in
                guard let self = self else { return }
                if data.isEmpty {
                    collectionView.setEmptyMessage("no_event".localized)
                } else {
                    collectionView.hideEmptyMessage()
                }
            }
            .map{[SectionModel(model: (), items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: getEventItemDataSource()))
            .disposed(by: bag)
        
        collectionView.rx.willDisplayCell
            .subscribe(onNext: {[weak self] cell, indexPath in
                guard let self = self else { return }
                if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                    self.viewModel.loadMore()
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                return
                            case .Error(let error):
                                if error?.code == Configs.Server.errorCodeRequiresLogin {
                                    AppDelegate.shared().windowMainConfig(vc: LoginVC())
                                } else {
                                    viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                                }
                            }
                        })
                        .disposed(by: bag)
                }
            })
            .disposed(by: bag)
    }
}

extension SearchVC {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.refreshData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.searchEvent(keyword: searchTextField.text ?? "")
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
        textField.resignFirstResponder()
        
        return true
    }
}
