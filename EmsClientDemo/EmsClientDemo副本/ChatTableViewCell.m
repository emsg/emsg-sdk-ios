//
//  ChatTableViewCell.m
//  sockettest
//
//  Created by cyt on 14/11/19.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ChatTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        header=[[UIImageView alloc] initWithFrame:CGRectZero];
        header.frame=CGRectMake(0, 0, 60, 60);
        [self.contentView addSubview:header];
        
        bg=[[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bg];
        contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        contentLabel.numberOfLines=0;
        contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        [bg addSubview:contentLabel];
        
        
        contentImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [bg addSubview:contentImage];
        
        
        contentAudio=[UIButton buttonWithType:UIButtonTypeCustom];
        [bg addSubview:contentAudio];
        contentAudioTime=[[UILabel alloc]initWithFrame:CGRectZero];
        contentAudioTime.numberOfLines=1;
        contentAudioTime.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        [self.contentView addSubview:contentAudioTime];
        [self.contentView addSubview:bg];
    }
    return self;
}
-(void)setContent:(ChatMsg *)msg
{
    CGSize winSize=[UIScreen mainScreen].bounds.size;

    if(msg.type!=nil&&[msg.type isEqualToString:@"image"])//图片
    {
        contentAudio.frame=CGRectZero;
        contentAudioTime.frame=CGRectZero;
        contentLabel.frame=CGRectZero;
        if(msg.isMe)
        {
            UIImage *image=[UIImage imageNamed:@"chatto_bg.png"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
            [bg setImage:image];
            
                [header setImage:[UIImage imageNamed:@"icon01.jpg"]];
            header.frame=CGRectMake(winSize.width-10-60, 0, 60, 60);
            contentImage.frame=CGRectMake(10, 10, 80, 80);
            bg.frame=CGRectMake(winSize.width-10-header.frame.size.width-110, 0, 110, 110);
        }
        else{
            UIImage *image=[UIImage imageNamed:@"chatfrom_bg.png"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
            [bg setImage:image];
            [header setImage:[UIImage imageNamed:@"icon02.jpg"]];
            header.frame=CGRectMake(10, 0, 60, 60);
            contentImage.frame=CGRectMake(20, 10, 80, 80);
            bg.frame=CGRectMake(10+header.frame.size.width, 0, 110, 110);
        }
        [contentImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://emsg.qiniudn.com/%@",msg.content]]];
    }
    else if(msg.type!=nil&&[msg.type isEqualToString:@"audio"])//语音
    {
        contentLabel.frame=CGRectZero;
        contentImage.frame=CGRectZero;
        if(msg.isMe)
        {
            UIImage *image=[UIImage imageNamed:@"chatto_bg.png"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
            [bg setImage:image];
            
            [header setImage:[UIImage imageNamed:@"icon01.jpg"]];
            header.frame=CGRectMake(winSize.width-10-60, 0, 60, 60);
            contentAudio.frame=CGRectMake(10, 11.5, 27, 33);
            [contentAudio setImage:[UIImage imageNamed:@"voice_r.png"] forState:UIControlStateNormal];
            bg.frame=CGRectMake(winSize.width-50-60-60, 0, 60, 60);
            NSString *time=[NSString stringWithFormat:@"%@ ''",msg.time];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
            CGSize timeSize=[time boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
            contentAudioTime.frame=CGRectMake(winSize.width-50-60-60-timeSize.width-5, 23, timeSize.width, timeSize.height);
            contentAudioTime.text=time;
           
        }
        else{
            UIImage *image=[UIImage imageNamed:@"chatfrom_bg.png"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
            [bg setImage:image];
            [header setImage:[UIImage imageNamed:@"icon02.jpg"]];
            header.frame=CGRectMake(10, 0, 60, 60);
            contentAudio.frame=CGRectMake(20, 11.5, 27, 33);
            [contentAudio setImage:[UIImage imageNamed:@"voice_l.png"] forState:UIControlStateNormal];

            bg.frame=CGRectMake(10+header.frame.size.width, 0, 60, 60);
            NSString *time=[NSString stringWithFormat:@"%@ ''",msg.time];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
            CGSize timeSize=[time boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
            contentAudioTime.frame=CGRectMake(10+header.frame.size.width+60+5, 23, timeSize.width, timeSize.height);
            contentAudioTime.text=time;
        }
    }
    else//普通文本
    {
        contentAudio.frame=CGRectZero;
        contentAudioTime.frame=CGRectZero;
        contentImage.image=nil;
        contentImage.frame=CGRectZero;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
        CGSize contentSize=[msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        if(msg.isMe)
        {
        UIImage *image=[UIImage imageNamed:@"chatto_bg.png"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
        [bg setImage:image];
        [header setImage:[UIImage imageNamed:@"icon01.jpg"]];
        header.frame=CGRectMake(winSize.width-10-60, 0, 60, 60);
        CGFloat contentX=winSize.width-50-contentSize.width-60;
        contentLabel.frame=CGRectMake(10, 5, contentSize.width, contentSize.height);
        bg.frame=CGRectMake(contentX, 0, contentSize.width+30, contentSize.height+20);
        
        }
        else{
        UIImage *image=[UIImage imageNamed:@"chatfrom_bg.png"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
        [bg setImage:image];
        [header setImage:[UIImage imageNamed:@"icon02.jpg"]];
        header.frame=CGRectMake(10, 0, 60, 60);
        contentLabel.frame=CGRectMake(20, 5, contentSize.width, contentSize.height);
        bg.frame=CGRectMake(10+header.frame.size.width, 0, contentSize.width+30, contentSize.height+20);

       }
       contentLabel.text=msg.content;
    }
    

}
@end
