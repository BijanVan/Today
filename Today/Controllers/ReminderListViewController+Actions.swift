//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-02.
//

import UIKit

extension ReminderListCollectionViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
