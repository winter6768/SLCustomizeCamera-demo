//
//  SLAlbumsViewController.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAlbumsResource.h"

@interface SLAlbumsViewController : UIViewController

@property(nonatomic,strong)SLAlbumsGroupModel *recentPhotosModel;

@property(nonatomic,copy)void(^compareDidSelectBlock)(UIImage *);

@end
