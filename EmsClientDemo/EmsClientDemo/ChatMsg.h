//
//  ChatMsg.h
//  sockettest
//
//  Created by cyt on 14/11/19.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMsg : NSObject
@property(nonatomic,assign)  BOOL isMe;
@property(nonatomic,copy)  NSString *content;
@property(nonatomic,copy)  NSString *type;
@property(nonatomic,copy)  NSString *time;
@property(nonatomic,assign)  long  date;
@end
