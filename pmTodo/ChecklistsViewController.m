//
//  ChecklistsViewController.m
//  pmTodo
//
//  Created by 阿涛 on 14-9-4.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "ChecklistsViewController.h"
#import "ChecklistItem.h"

@interface ChecklistsViewController ()


@end

@implementation ChecklistsViewController{
    
    NSMutableArray *_items;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _items = [[NSMutableArray alloc]initWithCapacity:20];
    ChecklistItem *item;
    
    item = [[ChecklistItem alloc]init];
    item.text =@"观看嫦娥⻜天和玉兔升空的视频";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"了解Sony a7和MBP的最新价格";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"复习苍⽼老师的经典视频教程";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"去电影院看地⼼引力";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"看西甲巴萨新败的⽐比赛回放";
    item.checked = NO;
    [_items addObject:item];
    
//    _items[1].checked;
//    _items[3].checked;// = YES;
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

//-(void)configureCheckmarkForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
//    ChecklistItem *item = _items[indexPath.row];

-(void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if(item.checked){
        label.text = @"√";
    }else{
        label.text = @"";
    }
    
}

-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    ChecklistItem *item = _items[indexPath.row];
    
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = _items[indexPath.row];
    
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

//代理方法：关闭增加记录页面
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//代理方法：添加行并关闭增加记录页面
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//代理方法：编辑记录并关闭
-(void)itemDetailViewController:(ItemDetailViewController*)controller didFinishEditingItem:(ChecklistItem*)item{
    NSInteger index=[_items indexOfObject:item];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];

    [self configureTextForCell:cell withChecklistItem:item];
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
        controller.itemToEdit = _items[indexPath.row];
    }
}

@end
