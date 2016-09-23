//
//  SLImageViewerView.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/18.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLImageViewerView : UIScrollView

/** 默认显示图片 */
@property(nonatomic,strong)UIImage *placeholderImage;

/** 显示用图片 */
@property(nonatomic,strong)UIImage *contentImage;

/** 图片显示方向 0：正常  1：顺时针90度  2：顺时针180度  3：顺时针270度 */
@property(nonatomic,assign)NSInteger directionType;

/** 可见区域的图片 */
@property(nonatomic,readonly)UIImage *editedImage;

/** 选中时 红色边框 默认no */
@property(nonatomic,assign)BOOL selected;

@end
