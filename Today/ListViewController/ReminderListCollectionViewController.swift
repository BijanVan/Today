//
//  ReminderListCollectionViewController.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-01.
//

import UIKit

class ReminderListCollectionViewController: UICollectionViewController {
    
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.due) }.sorted { $0.due < $1.due }
    }
    var listStyle: ReminderListStyle = .today
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl

        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        showDetail(for: id)
        
        return false
    }
    
    // MARK: Private functions
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = false
        config.backgroundColor = .clear
        config.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

#if DEBUG

import SwiftUI

struct RootViewControllerPreview: PreviewProvider {
    
    // xcrun simctl list devicetypes
    static var devices = ["iPhone 14 Pro", "iPhone 13 mini"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReminderListCollectionViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
    
}

#endif
