//
//  MRImageView.h
//  MRFramework
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MrXir. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MRImageView : UIImageView

/** 渲染填充色 */
@property (nonatomic, strong) IBInspectable UIColor *imageRenderingColor;

@end
