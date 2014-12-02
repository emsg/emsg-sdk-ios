//
//  ChatTableViewCell.h
//  sockettest
//
//  Created by cyt on 14/11/19.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ChatMsg.h"

@interface ChatTableViewCell : UITableViewCell
{
    
    UIImageView *header;
    UIImageView *bg;
    UILabel *contentLabel;
    UIImageView *contentImage;
    UIButton *contentAudio;
    UILabel *contentAudioTime;
}
-(void)setContent:(ChatMsg *)msg;
@end
