//
//  SLButton.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/9.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    SLButtonImageAlignmentLeft,   // button 图片在文字左面
    SLButtonImageAlignmentRight,  // button 图片在文字右面
    SLButtonImageAlignmentTop,    // button 图片在文字上面
    SLButtonImageAlignmentBottom, // button 图片在文字下面
} SLButtonImageAlignment;

@interface SLButton : UIButton

/** 图片相对于文字位置显示方式  默认 SLButtonImageAlignmentLeft */
@property(nonatomic,assign)SLButtonImageAlignment imageAligment;

/** 文字和图片之间的间隔 默认 0 */
@property(nonatomic,assign)CGFloat spacing;

@end
