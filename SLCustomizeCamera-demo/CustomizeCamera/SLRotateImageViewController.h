//
//  SLRotateImageViewController.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/18.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLRotateImageViewController : UIViewController

@property(nonatomic,strong)UIImage *image;

/** 图片的本地地址 用于获取高清图 */
@property(nonatomic,strong)NSURL *imageUrl;

@end
