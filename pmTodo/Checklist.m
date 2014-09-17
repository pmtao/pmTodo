//
//  Checklist.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-12.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"

@implementation Checklist

-(id)init{
    if((self=[super init])){
        self.items=[[NSMutableArray alloc]initWithCapacity:20];
        self.iconName = @"No Icon";//默认代办事项图标
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self=[super init])){
        self.name=[aDecoder decodeObjectForKey:@"Name"];
        self.items=[aDecoder decodeObjectForKey:@"Items"];
        self.items=[aDecoder decodeObjectForKey:@"iconName"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.items forKey:@"iconName"];
}

//统计某个代办事项的详细清单中，还有多少未完成事项。
-(int)countUncheckedItems{
    
    int count = 0;
    
    for (ChecklistItem *item in self.items) {
        if(!item.checked){
            count +=1;
        }
    }
    
    return count;
}

//总事项列表排序算法
-(NSComparisonResult)compare:(Checklist *)otherChecklist{
    return [self.name localizedStandardCompare:otherChecklist.name];
}

@end
