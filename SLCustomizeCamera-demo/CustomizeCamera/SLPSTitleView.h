//
//  SLPSTitleView.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/22.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPSTitleView : UIScrollView

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,copy)void(^didSelectBlock)(NSString *);

@end
