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
