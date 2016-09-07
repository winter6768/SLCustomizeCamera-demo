//
//  SLFilterEffect.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLFilterEffect.h"

@implementation SLFilterEffect

+(NSArray *)allFilter
{
    NSMutableArray *array = [NSMutableArray new];
    
    NSDictionary *dict = @{@"原图" : @"",
                           @"单色" : @"CIPhotoEffectNoir",
                           @"色调" : @"CIPhotoEffectTonal",
                           @"黑白" : @"CIPhotoEffectMono",
                           @"褪色" : @"CIPhotoEffectFade",
                           @"铬黄" : @"CIPhotoEffectChrome",
                           @"冲印" : @"CIPhotoEffectProcess",
                           @"岁月" : @"CIPhotoEffectTransfer",
                           @"怀旧" : @"CIPhotoEffectInstant"
                           };
    
    NSArray *keys = @[@"原图",@"单色",@"色调",@"黑白",@"褪色",@"铬黄",@"冲印",@"岁月",@"怀旧"];
    for (int i = 0; i < keys.count; i ++)
    {
        NSString *key = keys[i];
        
        SLFilterEffect *filter = [[SLFilterEffect alloc]init];
        filter.title = key;
        filter.filterName = [dict valueForKey:key];
        [array addObject:filter];
    }
    
    return array;
}



@end
