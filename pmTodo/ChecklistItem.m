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

//NSCoding协议方法:初始化解码
-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super init]))
    {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    }
    
    return self;
}

//NSCoding协议方法：编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
}

@end
