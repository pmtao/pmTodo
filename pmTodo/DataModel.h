//
//  DataModel.h
//  数据模型对象
//  pmTodo
//
//  Created by 阿涛 on 14-9-12.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic,strong)NSMutableArray *lists;

-(void)saveChecklists;

-(NSInteger)indexOfSelectedChecklist;

-(void)setIndexOfSelectedChecklist:(NSInteger)index;

//给总事项清单排序
-(void)sortChecklists;

@end
