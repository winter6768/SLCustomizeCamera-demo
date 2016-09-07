//
//  SLPSImageView.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPSImageView : UIImageView

/** 图片 */
@property(nonatomic,strong)UIImage *psImage;

/** 标题 */
@property(nonatomic,strong)NSString *psTitle;

/** 选中状态 默认 no */
@property(nonatomic,assign)BOOL psSelected;

@end
