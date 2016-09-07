//
//  SLSingleViewController.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSingleViewController : UIViewController

/** 对比图拍照回调block */
@property(nonatomic,copy)void(^compareShootBlock)(UIImage *);

@end
