//
//  EventDetailVC.swift
//  PBL6
//
//  Created by KietKoy on 13/10/2023.
//

import UIKit
import RxDataSources

class EventDetailVC: BaseVC<EventDetailVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var typeEventLabel: UILabel!
    @IBOutlet weak var statusEventLabel: UILabel!
    @IBOutlet weak var registeredQuantityLabel: UILabel!
    
    @IBOutlet weak var statusEventView: GradientView!
    @IBOutlet weak var generalInforButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndStart: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var speakerCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var speakerCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var roleCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var roleCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var organizationalCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var organizationalCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var nameOrganizationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    
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
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
        
    }
    
    init(eventId: String) {
        super.init()
        viewModel.eventId = eventId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        roleCollectionViewHC.constant = roleCollectionView.intrinsicContentSize.height
        speakerCollectionViewHC.constant
        = speakerCollectionView.intrinsicContentSize.height
        organizationalCollectionViewHC.constant = organizationalCollectionView.intrinsicContentSize.height
    }
    
    override func initViews() {
        super.initViews()
        
        generalView.isHidden = false
        detailView.isHidden = true
        
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
    }

    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        detailButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                generalView.isHidden = true
                detailView.isHidden = false
            })
            .disposed(by: bag)
        
        generalInforButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                generalView.isHidden = false
                detailView.isHidden = true
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.rolesDataS
            .map{ [SectionModel(model: (), items: $0)]}
            .bind(to: roleCollectionView.rx.items(dataSource: getRoleItemDataSource()))
            .disposed(by: bag)
        
        viewModel.eventDetailItemR
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.updateView(with: item)
            })
            .disposed(by: bag)
        
        viewModel.speakersDataS
            .map { [SectionModel(model: (), items: $0)]}
            .bind(to: speakerCollectionView.rx.items(dataSource: getSpeakerItemDataSource()))
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        roleCollectionView.registerCellNib(RoleItemCell.self)
        let layouRoleCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 52/327, minimumLineSpacing: 8, scrollDirection: .vertical)
        roleCollectionView.collectionViewLayout = layouRoleCollectionView
        
        speakerCollectionView.registerCellNib(SpeakerItemCell.self)
        let layoutspeakerCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 48/327, minimumLineSpacing: 16, scrollDirection: .vertical)
        speakerCollectionView.collectionViewLayout = layoutspeakerCollectionView
    }
}

private extension EventDetailVC {
    private func updateView(with item: EventDetailDto) {
        eventNameLabel.text = item.name
        typeEventLabel.text = item.type.lowercased().localized
        introductionLabel.text = item.introduction
        statusEventLabel.text = item.status.lowercased().localized
        capacityLabel.text = "\(item.capacity)"
        timeStartLabel.text = convertDateString(inputDate: item.startAt)
        timeEndStart.text = convertDateString(inputDate: item.endAt)
        placeLabel.text = item.address.fullAddress
        registeredQuantityLabel.text = "\(item.registered)"
        
        loadImageFromURL(from: item.imageUrl, into: eventImage)
        
        nameOrganizationLabel.text = item.representativeOrganization.name
    }
    
    private func updateStatusButton(status: String) {
        if status == EventStatus.Done.rawValue {
            statusEventView.startColor = "FFF09E".toUIColor()
            statusEventView.endColor = "FFE55A".toUIColor()
        } else if status == EventStatus.Happening.rawValue {
            statusEventView.startColor = "56ECFF".toUIColor()
            statusEventView.endColor = "58CCFE".toUIColor()
        } else {
            
        }
    }
}

extension EventDetailVC {
    func convertDateString(inputDate: String) -> String {
        let date = FormatUtils.formatStringToDate(inputDate, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        return FormatUtils.formatDateToString(date, formatterString: "HH:mm dd/MM/yyyy")
    }
}
