
//  ViewController.m
//  sockettest
//
//  Created by cyt on 14/11/17.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "ChatMsg.h"
#import "ChatTableViewCell.h"
#import "EmsgMsg.h"
#define MY_ACCOUNT @"aaa@test.com/123"
#define MY_ACCOUNT_PWD @"123123"

#define TA_ACCOUNT @"bbb@test.com/222"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title=@"EmsgClient";
    
    UIBarButtonItem *authBtn = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(auth)];
    
    self.navigationItem.rightBarButtonItem=authBtn;
    
    
    CGRect rect=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    table=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:table];
    
    toolview =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:toolview];
    [toolview setBackgroundColor:[UIColor whiteColor]];
    
    btnpic=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnpic setTitle:@"相册" forState:UIControlStateNormal];
    [btnpic setFrame:CGRectMake(0, 0, 50, 50)];
    [btnpic addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchUpInside];
    [toolview addSubview:btnpic];
    
    input=[[UITextField alloc] initWithFrame:CGRectMake(60, 10, toolview.frame.size.width-120, 30)];
    [input setBorderStyle:UITextBorderStyleRoundedRect];
    input.returnKeyType = UIReturnKeyDone;
    input.delegate=self;
    [toolview addSubview:input];
    
    
    btnsend=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnsend setTitle:@"发送" forState:UIControlStateNormal];
    [btnsend setFrame:CGRectMake(toolview.frame.size.width-50, 0, 50, 50)];
    [btnsend addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [toolview addSubview:btnsend];
    btnsend.enabled=NO;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    
    chatArray=[NSMutableArray array];
    
    
    client=[EmsgClient   sharedInstance];
    [client  setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:input];
}

-(void)auth
{
    if(![client isAuthed])
    {
        
        BOOL successed=[client auth:MY_ACCOUNT withPassword:MY_ACCOUNT_PWD];
        
        if(successed)//连接成功
        {
            HUD.mode= MBProgressHUDModeIndeterminate;
            HUD.labelText = @"登录中...";
            [HUD show:YES];
        }
        else{//连接失败
            HUD.mode= MBProgressHUDModeText;
            HUD.labelText = @"连接服务器失败，请检查网络⚠";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
        }
    }
    else{
        HUD.mode= MBProgressHUDModeText;
        HUD.labelText = @"已经登陆😢";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}
-(void)sendMessage
{
    if([client isAuthed])// 判断是否连接服务器
    {
        [client sendMessage:TA_ACCOUNT  content:input.text targetType:SINGLECHAT tag:arc4random()];
        ChatMsg *msg=[[ChatMsg alloc] init];
        msg.isMe=YES;
        msg.content=input.text;
        NSDate* date = [NSDate date];
        long timeSp=[date timeIntervalSince1970];
        msg.date=timeSp;
        [chatArray addObject:msg];
        [table reloadData];
        input.text=@"";
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else{
        HUD.mode= MBProgressHUDModeText;
        HUD.labelText = @"请先登陆😊";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}
- (void)sendImage
{
    if([client isAuthed])// 判断是否连接服务器
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    else{
        HUD.mode= MBProgressHUDModeText;
        HUD.labelText = @"请先登陆😊";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data=UIImageJPEGRepresentation(image,1.0);
    //    NSMutableDictionary *attrs=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [client sendImageData:data attrs:nil withName:@"test.jpg" toid:TA_ACCOUNT targetType:SINGLECHAT tag:arc4random()];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark EmsgClientDelegate
-(void) didAuthSuccessed
{
    
    HUD.mode= MBProgressHUDModeText;
    HUD.labelText = @"登陆成功😊";
    [HUD hide:YES afterDelay:1];
}
-(void) didAuthFailed:(NSString *)error
{
    HUD.mode= MBProgressHUDModeText;
    HUD.labelText = error;
    [HUD hide:YES afterDelay:1];
}

/*在线消息成功回调*/
-(void) didReceivedMessage:(EmsgMsg *)msg
{
    ChatMsg *chatmsg=[[ChatMsg alloc] init];
    chatmsg.isMe=NO;
    chatmsg.type=msg.contenttype;
    chatmsg.date=msg.timeSp;
    chatmsg.time=msg.contentlength;
    chatmsg.content=msg.content;
    [chatArray addObject:chatmsg];
    [table reloadData];
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/*离线消息成功回调*/
-(void) didReceivedOfflineMessageArray:(NSArray *)array
{
    for(int i=0;i<[array count];i++)
    {
        ChatMsg *chatmsg=[[ChatMsg alloc] init];
        EmsgMsg *msg=[array objectAtIndex:i];
        chatmsg.isMe=NO;
        chatmsg.type=msg.contenttype;
        chatmsg.date=msg.timeSp;
        chatmsg.time=msg.contentlength;
        chatmsg.content=msg.content;
        [chatArray addObject:chatmsg];
    }
    [table reloadData];
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/*发送消息成功回调*/
-(void) didSendMessageSuccessed:(long)tag
{
    
}
/*发送带附件信息百分比*/
-(void) didUploadPercent:(float)percent tag:(long)tag
{
    
}
/*上传附件完成*/
-(void) didUploadComplete:(NSString *)key tag:(long)tag
{
    ChatMsg *msg=[[ChatMsg alloc] init];
    msg.isMe=YES;
    msg.content=key;
    msg.type=@"image";
    NSDate* date = [NSDate date];
    long timeSp=[date timeIntervalSince1970];
    msg.date=timeSp;
    [chatArray addObject:msg];
    [table reloadData];
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/*发送信息失败*/
-(void) didSendMessageFailed:(long)tag
{
    
}
/*连接服务器失败,断开连接*/
-(void) willDisconnectWithError:(NSError *)err
{
    
}
/*强制下线*/
-(void) didKilledByServer
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您被迫强制下线😳" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)textFieldChanged:(id)sender
{
    if(input.text.length>0)
    {
        btnsend.enabled=YES;
    }
    else{
        btnsend.enabled=NO;
    }
    
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)willShowKeyboard{
    
    [UIView animateWithDuration:0.3 animations:^{
        [toolview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260-50, [UIScreen mainScreen].bounds.size.width, 44)];
        [table setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, table.frame.size.height-260)];
        
        if([chatArray count]>0)
        {
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}
-(void)hideShowKeyboard{
    [UIView animateWithDuration:0.3 animations:^{
        [toolview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50, [UIScreen mainScreen].bounds.size.width, 44)];
        [table setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, table.frame.size.height+260)];
        if([chatArray count]>0)
        {
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ChatTableViewCell *cell=(ChatTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    return cell.cellHeight;
    ChatMsg *msg=[chatArray objectAtIndex:indexPath.row];
    if(msg.type!=nil&&[msg.type isEqualToString:@"image"])
    {
        return  130;
    }
    else if(msg.type!=nil&&[msg.type isEqualToString:@"image"]){
        return 80;
    }
    else{
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
        CGSize contentSize=[msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
        CGFloat height=contentSize.height>60?contentSize.height:60;
        return height+20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier=@"cell";
    
    ChatTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell==nil)
    {
        cell=[[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setContent:[chatArray objectAtIndex:indexPath.row]];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [chatArray count];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reciveAuthTimeOut
{
 HUD.mode= MBProgressHUDModeText;
 HUD.labelText = @"连接服务器失败，请检查网络";
 [HUD show:YES];
 [HUD hide:YES afterDelay:1];
}

@end
