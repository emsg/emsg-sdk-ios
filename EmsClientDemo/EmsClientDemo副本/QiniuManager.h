//
//  QiniuClient.h
//  sockettest
//
//  Created by cyt on 14/11/21.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
typedef void (^QNUpCompletionHandler)(QNResponseInfo *info, NSString *key, NSDictionary *resp);
typedef void (^QNUpProgressHandler)(NSString *key, float percent);
@interface QiniuManager : NSObject
{
    QNUploadManager *upManager;
}
+ (QiniuManager *)defaultManager;
-(void)uploadData:(NSString *)token data:(NSData *)data withKey:(NSString *)key complete:(QNUpCompletionHandler)completionHandler progress:(QNUpProgressHandler)progressHandler;
@end