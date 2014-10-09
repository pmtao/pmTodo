//
//  ChecklistItem.h
//  pmTodo
//
//  Created by 阿涛 on 14-9-5.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject<NSCoding>

@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)BOOL checked;

//消息提示属性
@property(nonatomic,copy)NSDate *dueDate;
@property(nonatomic,assign)BOOL shouldRemind;
@property(nonatomic,assign)NSInteger itemId;

- (void)toggleChecked;

//提醒设置安排消息通知
- (void)scheduleNotification;

//日期格式化为字符串
+ (NSString *)formatDate:(NSDate *)date;

//- (NSComparisonResult)Acompare:(ChecklistItem *)otherChecklistItem;//自定义比较方法名

@end
