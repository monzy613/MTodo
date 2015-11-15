//
//  ToDoListViewController+UIViewControllerPreviewingDelegate.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/15.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

extension ToDoListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location), cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return nil
        }
        guard let showViewController = storyboard?.instantiateViewControllerWithIdentifier("ShowViewController") as? ShowViewController else { return nil }
        previewingContext.sourceRect = cell.frame
        let index = list.count - indexPath.row - 1
        showViewController.note = list[index]
        return showViewController
    }
}
