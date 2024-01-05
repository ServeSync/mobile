//
//  EventVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit
import RxDataSources

class EventVC: BaseVC<EventVM> {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var happeningCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var upcomingCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var doneCollectionView: IntrinsicCollectionView!
    
    @IBOutlet weak var emptyHappeningView: UIView!
    @IBOutlet weak var emptyUpcomingView: UIView!
    @IBOutlet weak var emptyDoneView: UIView!
    
    @IBOutlet weak var happeningCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var upcomingCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var doneCollectionViewHC: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showLoading()
        viewModel.fetchDataRemote()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                self.hideLoading()
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
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initViews() {
        super.initViews()
        
        headerView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        if happeningCollectionView.intrinsicContentSize.height < 256 {
//            happeningCollectionViewHC.constant = 256
//        } else {
//            happeningCollectionViewHC.constant = happeningCollectionView.intrinsicContentSize.height
//        }
//        
//        if upcomingCollectionView.intrinsicContentSize.height < 256 {
//           upcomingCollectionViewHC.constant = 256
//        } else {
//            upcomingCollectionViewHC.constant = upcomingCollectionView.intrinsicContentSize.height
//        }
//        
//        if doneCollectionView.intrinsicContentSize.height < 256 {
//            doneCollectionViewHC.constant = 256
//        } else {
//            doneCollectionViewHC.constant = doneCollectionView.intrinsicContentSize.height
//        }
        setCollectionViewHeightConstraint(collectionView: happeningCollectionView, heightConstraint: happeningCollectionViewHC)
        setCollectionViewHeightConstraint(collectionView: upcomingCollectionView, heightConstraint: upcomingCollectionViewHC)
        setCollectionViewHeightConstraint(collectionView: doneCollectionView, heightConstraint: doneCollectionViewHC)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        calendarButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(CalendarVC())
            })
            .disposed(by: bag)
        
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
    }
    
    override func bindViewModel() {
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
            .bind(to: happeningCollectionView.rx.items(dataSource: getEventItemDataSource()))
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
            .bind(to: upcomingCollectionView.rx.items(dataSource: getEventItemDataSource()))
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
            .bind(to: doneCollectionView.rx.items(dataSource: getEventItemDataSource()))
            .disposed(by: bag)
        
        viewModel.loadingData
            .subscribe(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showLoading() : self.hideLoading()
            })
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        happeningCollectionView.registerCellNib(MyEventCell.self)
        upcomingCollectionView.registerCellNib(MyEventCell.self)
        doneCollectionView.registerCellNib(MyEventCell.self)
        
        happeningCollectionView.delegate = self
        upcomingCollectionView.delegate = self
        doneCollectionView.delegate = self
    }
}

extension EventVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        let height = width * (222/167)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension EventVC {
    func setCollectionViewHeightConstraint(collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
        let minHeight: CGFloat = 256
        let newHeight = max(minHeight, collectionView.intrinsicContentSize.height)
        heightConstraint.constant = newHeight
    }
}
