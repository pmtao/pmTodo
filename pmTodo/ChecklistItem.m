//
//  ChecklistItem.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-5.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "ChecklistItem.h"

@implementation ChecklistItem

-(void)toggleChecked{
    self.checked = !self.checked;
}

@end
