//
//  HomeVC.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import UIKit
import RxDataSources

class HomeVC: BaseVC<HomeVM> {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var happeningCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var doneCollectionView: UICollectionView!
    
    @IBOutlet weak var emptyFavoriteView: UIView!
    @IBOutlet weak var emptyHappeningView: UIView!
    @IBOutlet weak var emptyUpcomingView: UIView!
    @IBOutlet weak var emptyDoneView: UIView!
    
    @IBOutlet weak var seeAllFavoriteEventButton: UIButton!
    @IBOutlet weak var seeAllHappeningEventButton: UIButton!
    @IBOutlet weak var seeAllUpcomingEventButton: UIButton!
    @IBOutlet weak var seeAllDoneEventButton: UIButton!
    
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
                                                                  description: getErrorDescription(forErrorCode: error!.code)
                                                                 ))
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
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.registerCellNib(EventItemCell.self)
        
        happeningCollectionView.delegate = self
        happeningCollectionView.registerCellNib(EventItemCell.self)
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.registerCellNib(EventItemCell.self)
        
        doneCollectionView.delegate = self
        doneCollectionView.registerCellNib(EventItemCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.happeningEventsR
            .do { [weak self] data in
                guard let self = self else { return }
                if data.isEmpty {
                    emptyHappeningView.isHidden = false
                } else {
                    emptyHappeningView.isHidden = true
                }
            }
            .map{[SectionModel(model: (), items: $0)]}
            .bind(to: happeningCollectionView.rx.items(dataSource: getPreviewEventItemDataSource()))
            .disposed(by: bag)
        
        viewModel.upcomingEventsR
            .do { [weak self] data in
                guard let self = self else { return }
                if data.isEmpty {
                    emptyUpcomingView.isHidden = false
                } else {
                    emptyUpcomingView.isHidden = true
                }
            }
            .map{[SectionModel(model: (), items: $0)]}
            .bind(to: upcomingCollectionView.rx.items(dataSource: getPreviewEventItemDataSource()))
            .disposed(by: bag)
        
        viewModel.doneEventsR
            .do { [weak self] data in
                guard let self = self else { return }
                if data.isEmpty {
                    emptyDoneView.isHidden = false
                } else {
                    emptyDoneView.isHidden = true
                }
            }
            .map{[SectionModel(model: (), items: $0)]}
            .bind(to: doneCollectionView.rx.items(dataSource: getPreviewEventItemDataSource()))
            .disposed(by: bag)
        
        searchTextField.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        happeningCollectionView.rx.modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.pushVC(EventDetailVC(eventId: item.id))
            })
            .disposed(by: bag)
        
        upcomingCollectionView.rx.modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.pushVC(EventDetailVC(eventId: item.id))
            })
            .disposed(by: bag)
        
        doneCollectionView.rx.modelSelected(FlatEventDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.pushVC(EventDetailVC(eventId: item.id))
            })
            .disposed(by: bag)
        
        seeAllHappeningEventButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(SeeAllEventVC(statusEvent: .Happening))
            })
            .disposed(by: bag)
        
        seeAllFavoriteEventButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(SeeAllEventVC(statusEvent: .Favorite))
            })
            .disposed(by: bag)
        
        seeAllUpcomingEventButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(SeeAllEventVC(statusEvent: .Upcoming))
            })
            .disposed(by: bag)
        
        seeAllDoneEventButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(SeeAllEventVC(statusEvent: .Done))
            })
            .disposed(by: bag)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
