//
//  Checklist.h
//  pmTodo
//
//  Created by 阿涛 on 14-9-12.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject<NSCoding>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSMutableArray *items;

@property(nonatomic,copy)NSString *iconName;

//统计某个代办事项的详细清单中，还有多少未完成事项。
-(int)countUncheckedItems;

@end
