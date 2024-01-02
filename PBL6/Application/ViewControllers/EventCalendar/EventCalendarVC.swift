//
//  EventCalendarVC.swift
//  PBL6
//
//  Created by KietKoy on 28/12/2023.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI
import RxSwift

class EventCalendarVC: DayViewController, EKEventEditViewDelegate {
    @Inject
    var viewModel: EventCalendarVM!
    
    private var eventStore = EKEventStore()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        requestAccessToCalendar()
        subscribeToNotifications()
        
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func requestAccessToCalendar() {
        let completionHandler: EKEventStoreRequestAccessCompletionHandler =  { [weak self] granted, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: completionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: completionHandler)
        }
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }

    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc private func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    // MARK: - DayViewDataSource
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: nil)
        
//        let eventKitEvents = eventStore.events(matching: predicate)
        let eventKitEvents = viewModel.events.map { event in
            let e = EKEvent(eventStore: eventStore)
            e.title = event.name
            e.startDate = FormatUtils.formatStringToDate(event.startAt)
            e.endDate = FormatUtils.formatStringToDate(event.endAt)
            e.calendar = EKCalendar(for: .event, eventStore: eventStore)
            e.calendar.cgColor = randomColor().cgColor
            return e
        }
        
        print(eventKitEvents.count, "###")
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        
        return calendarKitEvents
    }
    
    // MARK: - DayViewDelegate
    
    // MARK: Event Selection
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.ekEvent)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing = true
        navigationController?.pushViewController(eventController,
                                                 animated: true)
    }
    
    // MARK: Event Editing
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        let newEKWrapper = createNewEvent(at: date)
        create(event: newEKWrapper, animated: true)
    }
    
    private func createNewEvent(at date: Date) -> EKWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var components = DateComponents()
        components.hour = 1
        let endDate = calendar.date(byAdding: components, to: date)
        
        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = "New event"

        let newEKWrapper = EKWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? EKWrapper else {
            return
        }
        endEventEditing()
        beginEditing(event: descriptor,
                     animated: true)
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EKWrapper else { return }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if originalEvent === editingEvent {
                presentEditingViewForEvent(editingEvent.ekEvent)
            } else {
                try! eventStore.save(editingEvent.ekEvent,
                                     span: .thisEvent)
            }
        }
        reloadData()
    }
    
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    // MARK: - EKEventEditViewDelegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EventCalendarVC {
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
