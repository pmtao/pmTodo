//
//  DataModel.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-12.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"

@implementation DataModel

#pragma mark 数据加载和保存

//获取Documents文件夹的完整路径
-(NSString *)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths firstObject];
    return documentsDirectory;
}

//创建数据保存文件的完整路径
-(NSString *)dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

//将事项数据写入到文件中
-(void)saveChecklists{
    NSMutableData *data = [[NSMutableData alloc]init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

//加载plist记录数据文件
-(void)loadChecklists{
    
    NSString *path =[self dataFilePath];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:path]){
        NSData *data = [[NSData alloc]initWithContentsOfFile:path ];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
        
        [unarchiver finishDecoding];
        
    }else{
        self.lists = [[NSMutableArray alloc]initWithCapacity:5];
    }
}

#pragma mark init初始化

-(void)registerDefaults{
    NSDictionary *dictionary = @{@"ChecklistIndex" :@-1,@"FirstTime":@"YES",@"ChecklistItemId":@0};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
}

-(id)init{
    if((self=[super init])){
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    
    return self;
}

-(NSInteger)indexOfSelectedChecklist{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"ChecklistIndex"];
}

-(void)setIndexOfSelectedChecklist:(NSInteger)index{
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"ChecklistIndex"];
}

//首次启动应用时，默认打开List待办事项。
-(void)handleFirstTime{
    BOOL firstTime = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"];
    if(firstTime){
        Checklist *checklist = [[Checklist alloc]init];
        checklist.name = @"事项清单";
        [self.lists addObject: checklist];
        [self setIndexOfSelectedChecklist:0];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTime"];
    }
}

//给总事项清单排序
-(void)sortChecklists{
    [self.lists sortUsingSelector:@selector(compare:)];
}

+ (NSInteger)nextChecklistItemId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemId = [userDefaults integerForKey:@"ChecklistItemId"];
    [userDefaults setInteger:itemId+1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];
    
    return itemId;
}

@end
