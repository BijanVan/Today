//
//  ReminderViewController.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-02.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>

    var reminder: Reminder
    private var dataSource: DataSource!
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
     }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")

        updateSnapshot()
    }
    
    // MARK: Private functions
    private func text(for row: Row) -> String? {
        switch row {
        case .viewDate: return reminder.due.dayText
        case .viewNotes: return reminder.notes
        case .viewTime: return reminder.due.formatted(date: .omitted, time: .shortened)
        case .viewTitle: return reminder.title
        }
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([.viewTitle, .viewDate, .viewTime, .viewNotes], toSection: 0)
        dataSource.apply(snapshot)
    }
    
}

#if DEBUG

import SwiftUI

struct ReminderViewControllerPreview: PreviewProvider {
    
    // xcrun simctl list devicetypes
    static var devices = ["iPhone 14 Pro", "iPhone 13 mini"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReminderViewController(reminder: Reminder.sampleData[0])
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
    
}

#endif
