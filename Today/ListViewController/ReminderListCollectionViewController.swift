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
    
    init() {
        super.init(collectionViewLayout: ReminderListCollectionViewController.listLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        showDetail(for: id)
        
        return false
    }
    
    // MARK: Private functions
    private class func listLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = false
        config.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: config)
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
