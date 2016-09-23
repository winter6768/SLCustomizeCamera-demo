//
//  SLPSTitleView.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/22.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLPSTitleView.h"

@interface SLPSTitleView ()
{
    UIButton *btn_select;
}
@end

@implementation SLPSTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
    }
    return self;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (btn_select)
    {
        return;
    }
    
    UIButton *button = [self viewWithTag:900 + selectedIndex];
    
    if (button)
    {
        button.selected = YES;
        btn_select = button;
    }
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    CGFloat frame_x = 0;
    for (int i = 0; i < titleArray.count; i ++)
    {
        NSString *title = titleArray[i];
        CGFloat width = [self calculateButtonWidth:title];
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(frame_x , 0, width, self.frame.size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        button.tag = 900 + i;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        if (i == self.selectedIndex)
        {
            button.selected = YES;
            btn_select = button;
        }
        
        frame_x += width;
    }
    
    self.contentSize = CGSizeMake(frame_x, self.frame.size.height);
}

-(void)buttonTap:(UIButton *)button
{
    if (button == btn_select)
    {
        return;
    }
    
    button.selected = YES;
    btn_select.selected = NO;
    btn_select = button;
    self.selectedIndex = button.tag;
    
    if (self.didSelectBlock)
    {
        self.didSelectBlock(button.currentTitle);
    }
}

-(CGFloat)calculateButtonWidth:(NSString *)title
{
    CGRect rect = [title boundingRectWithSize:CGSizeMake(50, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return rect.size.width + 30;
}

@end
