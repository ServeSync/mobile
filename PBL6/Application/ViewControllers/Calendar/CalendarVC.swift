//
//  CalendarVC.swift
//  PBL6
//
//  Created by KietKoy on 27/12/2023.
//

import UIKit
import FSCalendar

class CalendarVC: BaseVC<EventCalendarVM> {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    calendar.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchDailysEvents(date: Date())
        collectionView.reloadData()
    }
    
    override func initViews() {
        super.initViews()
        
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    override func configureListView() {
        super.configureListView()
        
        collectionView.registerCellNib(EventCalendarCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
    }
}

extension CalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if viewModel.datesHavingEvents.first(where: {compareDatesIgnoringTime(date1: $0, date2: date)}) != nil {
            return 1
        } else {
            return 0
        }
    }
}

extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.fetchDailysEvents(date: date)
        collectionView.reloadData()
        collectionView.scrollToFirstItem(animated: true)
    }
}

extension CalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyView.isHidden = !(viewModel.dailyEvents.count < 1)
        return viewModel.dailyEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReuseable(ofType: EventCalendarCell.self, indexPath: indexPath).apply {
            $0.configure(viewModel.dailyEvents[indexPath.row])
        }
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = 75.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension CalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pushVC(EventDetailVC(eventId: self.viewModel.dailyEvents[indexPath.row].id))
    }
}
