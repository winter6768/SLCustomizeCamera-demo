//
//  SLAlbumsListView.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/9.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAlbumsGroupModel.h"

@interface SLAlbumsListView : UIView

//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                  backgroundColor:(UIColor *)color;


@property(nonatomic,copy)void(^didSelectedBlock)(SLAlbumsGroupModel *);

-(void)show;

@end
