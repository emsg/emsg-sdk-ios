//
//  ViewController.h
//  EmsClientDemo
//
//  Created by cyt on 14/11/24.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmsgClient.h"
#import "MBProgressHUD.h"
@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    EmsgClient *client;
    UITableView *table;
    NSMutableArray *chatArray;
    MBProgressHUD *HUD;
    
    UIView *toolview;
    UITextField *input;
    UIButton *btnsend;
    UIButton *btnpic;
}
@end

