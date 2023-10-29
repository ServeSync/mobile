//
//  SeeAllEventVC.swift
//  PBL6
//
//  Created by KietKoy on 17/10/2023.
//

import UIKit
import RxDataSources

class SeeAllEventVC: BaseVC<SeeAllEventVM> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    
    init(statusEvent: EventStatus?) {
        super.init()
        
        self.viewModel.eventStatus = statusEvent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData(isRefresh: true, page: 0)
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
    
    override func initViews() {
        super.initViews()
        
        switch viewModel.eventStatus {
        case .Upcoming:
            titleLabel.text = "upcoming".localized
        case .Done:
            titleLabel.text = "done".localized
        case .Happening:
            titleLabel.text = "happening".localized
        case .Favorite:
            titleLabel.text = "favorite".localized
        default:
            showToast(message: "Error", state: .error)
        }
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
        
        viewModel.eventsR
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
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.pushVC(EventDetailVC(eventId: item.id))
            })
            .disposed(by: bag)
        
        collectionView.rx
            .modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
    }
}

extension SeeAllEventVC {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchData(isRefresh: true, page: 0)
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
