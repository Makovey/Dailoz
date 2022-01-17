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
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { action, view, completion in
            DBHelper.removeUserTaskWithId(task.id) {
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
        let updateAction = UIContextualAction(style: .normal, title: "Update") { action, view, completion in
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
            finishable = UIContextualAction(style: .normal, title: "Done") { action, view, completion in
                if var userTask = DBHelper.userTasks.filter({$0.id == task.id}).first {
                    userTask.isDone = true
                    DBHelper.updateUserTask(updatableTask: userTask, data: [K.FStore.Field.isDone: true]) {
                        Utilities.showBunner(title: "Wohoo", subtitle: "\(task.title) is done.", style: .success)
                        cell.doneImage.alpha = 1
                    }
                }
                
                completion(true)
            }
            finishable.image = UIImage(systemName: "checkmark.circle")
            finishable.backgroundColor = UIColor.init(named: "PendingCardPurple")
        } else {
            finishable = UIContextualAction(style: .normal, title: "Active") { action, view, completion in
                if var userTask = DBHelper.userTasks.filter({$0.id == task.id}).first {
                    userTask.isDone = false
                    DBHelper.updateUserTask(updatableTask: userTask, data: [K.FStore.Field.isDone: false]) {
                        Utilities.showBunner(title: "Task in active", subtitle: "\(task.title) in progress.", style: .info)
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
