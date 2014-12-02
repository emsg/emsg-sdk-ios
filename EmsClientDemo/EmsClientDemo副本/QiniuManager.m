//
//  QiniuClient.m
//  sockettest
//
//  Created by cyt on 14/11/21.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import "QiniuManager.h"

#define ACCESS_KEY  @"eau6doiUgYfcnZiqzWl_xs6amhn5VZ5jC4IPpDwd"
#define SECRET_KEY  @"QsSEMBIDMMv3SlVtIrZzLCIDQKjB5N71FdLX8Lwj"

@implementation QiniuManager
static QiniuManager *qiniuManager = nil;

+ (QiniuManager *)defaultManager {
    if (!qiniuManager)
    {
        qiniuManager = [[self alloc] init];
    }
    return qiniuManager;
}
-(id)init
{
    if(self=[super init])
    {
       upManager = [[QNUploadManager alloc] init];
    }
    return  self;
}
-(void)uploadData:(NSString *)token data:(NSData *)data withKey:(NSString *)key complete:(QNUpCompletionHandler)completionHandler progress:(QNUpProgressHandler)progressHandler
{

    QNUploadOption *option=[[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        progressHandler(key,percent);
    } params:nil checkCrc:nil cancellationSignal:nil];
    
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  completionHandler(info,key,resp);
                  
              } option:option];
}

-(void)dealloc
{
    [super dealloc];
    [upManager release];
}
@end
