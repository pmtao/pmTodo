//
//  ItemDetailViewController.h
//  pmTodo
//
//  Created by 阿涛 on 14-9-5.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import <UIKit/UIKit.h>

//通知代理协议ItemDetailViewController、ChecklistItem对象的存在。
@class ItemDetailViewController;
@class ChecklistItem;

//ItemDetailViewController与ViewController的代理协议，包含2个方法申明。
@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController*)controller;
-(void)itemDetailViewController:(ItemDetailViewController*)controller didFinishAddingItem:(ChecklistItem*)item;
-(void)itemDetailViewController:(ItemDetailViewController*)controller didFinishEditingItem:(ChecklistItem*)item;

@end

//接口定义，包含取消、完成按钮的动作链接方法，输入框、完成按钮链接属性、代理属性。
@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property(nonatomic,weak) id <ItemDetailViewControllerDelegate> delegate;
@property(nonatomic,strong) ChecklistItem *itemToEdit;

@end
