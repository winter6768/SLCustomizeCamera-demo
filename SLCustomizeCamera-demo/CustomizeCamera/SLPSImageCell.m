//
//  SLPSImageCell.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/22.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLPSImageCell.h"

@implementation SLPSImageCell
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
        _imageview = [[UIImageView alloc]init];
        _imageview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        _imageview.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageview];
        
        _selectedImage = [UIImageView new];
        _selectedImage.hidden = YES;
        _selectedImage.backgroundColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:96/255.0 alpha:1];
        _selectedImage.frame = CGRectMake(0, self.frame.size.width - 2, self.frame.size.width, 2);
        [self.contentView addSubview:_selectedImage];
        
        _label = [UILabel new];
        _label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.frame = CGRectMake(0, self.frame.size.width + 10, self.frame.size.width, 15);
        [self.contentView addSubview:_label];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    _selectedImage.hidden = !selected;
    _label.textColor = selected ? [UIColor whiteColor] : [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
}

-(void)setModel:(SLPSImageModel *)model
{
    _model = model;
    
    _imageview.image = model.image;
    _label.text = model.title;
}

@end
