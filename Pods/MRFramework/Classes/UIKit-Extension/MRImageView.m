//
//  MRImageView.m
//  MRFramework
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MrXir. All rights reserved.
//

#import "MRImageView.h"

@implementation MRImageView

- (void)setImageRenderingColor:(UIColor *)imageRenderingColor
{
    _imageRenderingColor = imageRenderingColor;
    
    self.tintColor = _imageRenderingColor;
    
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
