//
//  SLFilterEffect.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFilterEffect : NSObject

/** 滤镜名称 */
@property(nonatomic,strong)NSString *filterName;

/** 滤镜标题 */
@property(nonatomic,strong)NSString *title;

+(NSArray *)allFilter;

@end
