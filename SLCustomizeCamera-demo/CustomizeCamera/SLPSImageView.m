//
//  SLPSImageView.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLPSImageView.h"

@implementation SLPSImageView
{
    UIImageView *_imageview;
    UIImageView *_selectedImage;
    UILabel *_label;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setPsImage:(UIImage *)psImage
{
    _psImage = psImage;
    
    if (_imageview)
    {
        _imageview.image = psImage;
        return;
    }
    
    _imageview = [[UIImageView alloc]initWithImage:psImage];
    _imageview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [self addSubview:_imageview];
    
    _selectedImage = [UIImageView new];
    _selectedImage.hidden = YES;
    _selectedImage.backgroundColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    _selectedImage.frame = CGRectMake(0, self.frame.size.width - 2, self.frame.size.width, 2);
    [self addSubview:_selectedImage];
}

-(void)setPsTitle:(NSString *)psTitle
{
    _psTitle = psTitle;
    
    if (_label)
    {
        _label.text = psTitle;
        return;
    }
    
    _label = [UILabel new];
    _label.text = psTitle;
    _label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.frame = CGRectMake(0, self.frame.size.width + 10, self.frame.size.width, 15);
    [self addSubview:_label];
}

-(void)setPsSelected:(BOOL)psSelected
{
    _psSelected = psSelected;
    
    _selectedImage.hidden = !psSelected;
    _label.textColor = psSelected ? [UIColor whiteColor] : [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
}

@end
