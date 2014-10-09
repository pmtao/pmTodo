//
//  ChecklistViewController.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-4.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "Checklist.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController

////创建数据模型,并加载plist文件
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if((self =[super initWithCoder:aDecoder]))
//    {
//        [self loadChecklistItems];
//    }
//    
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = self.checklist.name;
  
//    NSLog(@"文件夹的路径是：%@", [self documentsDirectory]);
//    NSLog(@"数据文件的最终路径是：%@", [self dataFilePath]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.checklist.items count];
}

//设置具体待办列表的完成标志
-(void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];//通过tag进行访问，1001即tag。
    
    if(item.checked){
        label.text = @"√";
    }else{
        label.text = @"";
    }
    
    label.textColor = self.view.tintColor;
}

//设置具体待办事项的显示名称
-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
    //label.text = [NSString stringWithFormat:@"%ld:%@",(long)item.itemId,item.text];//名称前添加编号
    
    //事项名称下面显示截止日期
    UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1002];
    if(item.shouldRemind){
        dueDateLabel.text = [NSString stringWithFormat:@"截止日期：%@" ,[ChecklistItem formatDate:item.dueDate]];
    }else{
        dueDateLabel.text = @"";
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];

    ChecklistItem *item = self.checklist.items[indexPath.row];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell;
}

//点击记录更改完成标志状态
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//滑动删除记录
-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

//代理方法：关闭增加记录页面
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//代理方法：添加行并关闭增加记录页面
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
//    NSInteger newRowIndex = [self.checklist.items count];
    [self.checklist.items addObject:item];
    [self.checklist sortChecklistItem];//按截止日期排序
    [self.tableView reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
//    NSArray *indexPaths = @[indexPath];
//    
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

//代理方法：编辑记录并关闭
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem*)item{
//    NSInteger index=[self.checklist.items indexOfObject:item];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
//    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
//
//    [self configureTextForCell:cell withChecklistItem:item];
//
    
    [self.checklist sortChecklistItem];//按截止日期排序
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//当界面跳转的时候,UIKit会触发segue的prepareForSegue方法。segue是storyboard中两个视图控制器之间的那个箭头。
//prepareForSegue允许我们向新的视图控制器传递数据。
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddItem"]){
        
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController*) navigationController.topViewController;
        controller.delegate = self;
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController*) navigationController.topViewController;
        controller.delegate = self;
        
        //这里的sender参数其实指的就是触发了该segue的控件,在这里就是table view cell中的细节显示按钮。
        //通过它可以找到对应的index-path,然后获取要编辑的ChecklistItem对象的行编号。
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.checklist.items[indexPath.row];
    }
}

@end
