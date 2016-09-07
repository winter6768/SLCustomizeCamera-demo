//
//  UIImage+SLFilterEffect.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "UIImage+SLFilterEffect.h"

@implementation UIImage (SLFilterEffect)

-(UIImage *)SLFilterEffect:(SLFilterEffect *)filterEffect
{
    if (!filterEffect.filterName.length)
    {
        return self;
    }
    
    CIImage *ciImage = [[CIImage alloc]initWithImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:filterEffect.filterName keysAndValues:kCIInputImageKey,ciImage,nil];
    [filter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *showImage = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgImage);
    
    return showImage;
}

@end
