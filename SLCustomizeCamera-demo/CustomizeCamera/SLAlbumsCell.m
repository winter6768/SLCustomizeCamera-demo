//
//  SLAlbumsCell.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/12.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLAlbumsCell.h"

@implementation SLAlbumsCell
{
    UIImageView *contentImageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        contentImageView = [UIImageView new];
        contentImageView.frame = self.bounds;
        contentImageView.backgroundColor = [UIColor lightGrayColor];
        contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        contentImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:contentImageView];
    }
    return self;
}

-(void)setContentImage:(UIImage *)contentImage
{
    _contentImage = contentImage;
    
    contentImageView.image = contentImage;
}

@end
