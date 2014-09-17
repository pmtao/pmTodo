//
//  ChecklistViewController.h
//  pmTodo
//
//  Created by 阿涛 on 14-9-4.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

@interface ChecklistViewController : UITableViewController<ItemDetailViewControllerDelegate>

@property(nonatomic,strong)Checklist *checklist;

@end
