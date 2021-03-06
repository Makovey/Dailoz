//
//  TableViewUtils.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 09.01.2022.
//

import Foundation
import UIKit

struct TableViewUtils {
    
    static func createDeleteAction(task: Task, indexPath: IndexPath, tableView: UITableView) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete".localize()) { _, _, completion in
            DBHelper.removeUserTaskWithId(task.id) {
                NotificationCenter.default.post(name: Notification.Name.deletetdTask, object: nil, userInfo: ["DeletedTask": task])
                tableView.deleteRows(at: [indexPath], with: .right)
            }
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.circle")
        deleteAction.backgroundColor = UIColor.init(named: "orangeTypeText")
        
        if task.isNeededRemind {
            Utilities.deleteNotificationById(task.id)
        }
        
        return deleteAction
    }
    
    static func createUpdateAction(task: Task, tableView: UITableView, viewController: UIViewController) -> UIContextualAction {
        let updateAction = UIContextualAction(style: .normal, title: "Update".localize()) { _, _, completion in
            viewController.performSegue(withIdentifier: K.taskSegue, sender: viewController)
            completion(true)
        }
        updateAction.image = UIImage(systemName: "pencil.tip.crop.circle")
        updateAction.backgroundColor = UIColor.init(named: "CompletedCardBlue")
        
        return updateAction
    }
    
    static func createDoneAction(task: Task, cell: TaskCell) -> UIContextualAction {
        var finishable = UIContextualAction()
        
        if !task.isDone {
            finishable = UIContextualAction(style: .normal, title: "Done".localize()) { _, _, completion in
                if var userTask = DBHelper.userTasks.filter({$0.id == task.id}).first {
                    userTask.isDone = true
                    DBHelper.updateUserTask(updatableTask: userTask, data: [K.FStore.Field.isDone: true]) {
                        Utilities.showBunner(title: "Wohoo".localize(), subtitle: "\(task.title) " + "is done.".localize(), style: .success)
                        cell.doneImage.alpha = 1
                    }
                }
                
                completion(true)
            }
            finishable.image = UIImage(systemName: "checkmark.circle")
            finishable.backgroundColor = UIColor.init(named: "PendingCardPurple")
        } else {
            finishable = UIContextualAction(style: .normal, title: "Active".localize()) { _, _, completion in
                if var userTask = DBHelper.userTasks.filter({$0.id == task.id}).first {
                    userTask.isDone = false
                    DBHelper.updateUserTask(updatableTask: userTask, data: [K.FStore.Field.isDone: false]) {
                        Utilities.showBunner(title: "Task in active".localize(), subtitle: "\(task.title) " + "in progress.".localize(), style: .info)
                        cell.doneImage.alpha = 0
                    }
                }
                
                completion(true)
            }
            finishable.image = UIImage(systemName: "xmark.circle")
            finishable.backgroundColor = UIColor.init(named: "GraphicBorder")
        }
        
        return finishable
    }
}
