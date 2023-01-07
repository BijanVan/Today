//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-02.
//

import UIKit

extension ReminderListCollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter {id in filteredReminders.contains(where: { id == $0.id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminders[indexPath.item]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.due.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessories = [.customView(configuration: doneButtonConfiguration),
                            .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func add(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders.remove(at: index)
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
    
}
