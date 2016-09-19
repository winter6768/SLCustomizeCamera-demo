//
//  SLButton.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/9.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLButton.h"

@implementation SLButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;

//    标题和图片都存在时间隔才有意义
    if (CGSizeEqualToSize(imageRect.size, CGSizeZero) || CGSizeEqualToSize(titleRect.size, CGSizeZero))
    {
        self.spacing = 0;
    }
    
    switch (self.imageAligment) {

        case SLButtonImageAlignmentLeft:
            
            imageRect.origin.x = (self.frame.size.width - imageRect.size.width- titleRect.size.width - self.spacing) / 2.0f;
            imageRect.origin.y = (self.frame.size.height - imageRect.size.height) / 2.0f;
            
            titleRect.origin.x = imageRect.origin.x + imageRect.size.width + self.spacing;
            titleRect.origin.y = (self.frame.size.height  - titleRect.size.height) / 2.0f;
            
            break;
            
        case SLButtonImageAlignmentRight:
            
            titleRect.origin.x = (self.frame.size.width - imageRect.size.width- titleRect.size.width - self.spacing) / 2.0f;
            titleRect.origin.y = (self.frame.size.height - titleRect.size.height) / 2.0f;
            
            imageRect.origin.x = titleRect.origin.x + titleRect.size.width + self.spacing;
            imageRect.origin.y = (self.frame.size.height  - imageRect.size.height) / 2.0f;
            
            break;
            
        case SLButtonImageAlignmentTop:
            
            imageRect.origin.x = (self.frame.size.width - imageRect.size.width) / 2.0f;
            imageRect.origin.y = (self.frame.size.height - imageRect.size.height - titleRect.size.height - self.spacing) / 2.0f;
            
            titleRect.origin.x = (self.frame.size.width - titleRect.size.width) / 2.0f;
            titleRect.origin.y = imageRect.origin.y + imageRect.size.height + self.spacing;
            
            break;
            
        case SLButtonImageAlignmentBottom:
            
            titleRect.origin.x = (self.frame.size.width - titleRect.size.width) / 2.0f;
            titleRect.origin.y = (self.frame.size.height - imageRect.size.height - titleRect.size.height - self.spacing) / 2.0f;
            
            imageRect.origin.x = (self.frame.size.width - imageRect.size.width) / 2.0f;
            imageRect.origin.y = titleRect.origin.y + titleRect.size.height + self.spacing;
            
            break;
    }
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}



@end
