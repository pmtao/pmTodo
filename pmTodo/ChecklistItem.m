//
//  ChecklistItem.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-5.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

- (void)toggleChecked{
    self.checked = !self.checked;
}

//NSCoding协议方法:初始化解码
- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super init]))
    {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemId"];
    }
    
    return self;
}

//NSCoding协议方法：编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
}

- (id)init
{
    if((self = [super init])){
        self.itemId = [DataModel nextChecklistItemId];
    }
    
    return self;
}

//提醒设置安排消息通知
- (void)scheduleNotification{
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    
    if(existingNotification != nil){
        //NSLog(@"发现一个已有的通知：%@",existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
    
    if(self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending){
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemId":@(self.itemId)};
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        
        //NSLog(@"Scheduled notification %@ for itemId %ld",localNotification,(long)self.itemId);
    }
    
}

//在userInfo中查找当前通知并返回结果
- (UILocalNotification *)notificationForThisItem{
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    for(UILocalNotification *notification in allNotifications){
        NSNumber *number = [notification.userInfo objectForKey:@"ItemId"];
        if(number != nil && [number integerValue] == self.itemId){
            return notification;
        }
    }
    
    return nil;
}

//当用户删除某个单独的ChecklistItem待办事项,或者删除整个的Checklist都会调用dealloc方法取消通知。
- (void)dealloc{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if(existingNotification != nil){
        //NSLog(@"Removing existing notification %@",existingNotification);
        
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
}

//日期格式化为字符串
+ (NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

//具体事项列表按截止日期排序
- (NSComparisonResult)compare:(ChecklistItem *)otherChecklistItem{
    return [self.dueDate compare:otherChecklistItem.dueDate];
}

@end
