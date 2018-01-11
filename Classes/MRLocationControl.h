//
//  MRLocationControl.h
//  MRLocationControl
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MRXIR Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@class MRLocationControl;

typedef void(^MRLocationCompletion)(MRLocationControl *locationControl, CLPlacemark *placemark, NSError *error);

@interface MRLocationControl : UIControl

@property (nonatomic, strong) MRLocationCompletion locationCompletion;

@property (nonatomic, assign, getter=isAlwaysUseLocation) BOOL alwaysUseLocation;

@property (nonatomic, assign, getter=isAlwaysDisplayAlertWhenLocationDisabled) BOOL alwaysDisplayAlertWhenLocationDisabled;

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

@property (nonatomic, strong, readonly) CLGeocoder *geocoder;

@property (nonatomic, weak) IBOutlet UIButton *titleButton;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;

@property (nonatomic, weak) IBOutlet UIButton *rightButton;

- (BOOL)locateAuthorizationStatusDetection:(BOOL)showAlert;

- (void)startLocate;

- (void)stopLoacte;

@end
