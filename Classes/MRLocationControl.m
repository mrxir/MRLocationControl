//
//  MRLocationControl.m
//  MRLocationControl
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MRXIR Inc. All rights reserved.
//

#import "MRLocationControl.h"

@interface MRLocationControl ()<UIAlertViewDelegate, CLLocationManagerDelegate>

/** 定位服务是否更新中 */
@property (nonatomic, assign, getter=isLocationServiceUpdating) BOOL locationServiceUpdating;

/** 是否启用应用变为活跃时的监听，默认为不启用 */
@property (nonatomic, assign, getter=isObserverEnabled) BOOL observerEnabled;

/** 正在显示中的警告窗 */
@property (nonatomic, strong) UIAlertView *displayingAlert;

/** 正在显示中的警告窗状态 */
@property (nonatomic, copy) NSString *displayingAlertStatus;

@end

@implementation MRLocationControl

#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MRLocationControl" owner:self options:nil].lastObject;
        [self setFrame:frame];
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeApplicationStateHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - setter and getter

@synthesize locationManager = _locationManager;

- (CLLocationManager *)locationManager
{
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    
    return _locationManager;
}

@synthesize geocoder = _geocoder;

- (CLGeocoder *)geocoder
{
    if (_geocoder != nil) {
        return _geocoder;
    }
    
    _geocoder = [[CLGeocoder alloc] init];
    return _geocoder;
}

#pragma mark - api

- (void)startLocate
{
    if ([self locateAuthorizationStatusDetection]) {
        [self requestUserLocation];
    }
    
    self.observerEnabled = YES;
}

- (void)stopLoacte
{
    [self.locationManager stopUpdatingLocation];
    
    self.observerEnabled = NO;
}


#pragma mark - pvivate metod

- (void)observeApplicationStateHandler:(NSNotification *)notification
{
    if (self.isObserverEnabled) [self startLocate];
}

- (BOOL)locateAuthorizationStatusDetection
{
    BOOL locationServicesEnabled = NO;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    NSString *alwaysAndWhenInUse = [NSString stringWithFormat:@"%@", infoDictionary[@"NSLocationAlwaysAndWhenInUseUsageDescription"]];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        locationServicesEnabled = NO;
        
        NSLog(@"定位服务未开启");

        if (![@"locationServicesEnabled" isEqualToString:self.displayingAlertStatus]) {
            
            self.displayingAlert.delegate = nil;
            [self.displayingAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            NSString *alertTitle = [NSString stringWithFormat:@"定位服务未开启"];
            NSString *message = [NSString stringWithFormat:@"\n请前往\n\n⚙️设置 → ✋隐私 → 📍定位服务\n\n开启 [定位服务] 后\n\n返回 \"%@\"", appName];
            
            NSString *cancelTitle = self.isAlwaysDisplayAlertWhenLocationDisabled ? nil : @"关闭";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:@"前往设置", nil];
            [alert show];
            self.displayingAlert = alert;
            self.displayingAlertStatus = @"locationServicesEnabled";
            
        }

    } else {
    
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusNotDetermined) {
            
            locationServicesEnabled = NO;
            
            self.locationServiceUpdating = NO;

            [self requestUserLocation];
            
            NSLog(@"未定义");
            
        } else if (status == kCLAuthorizationStatusRestricted) {
            
            locationServicesEnabled = NO;
            
            NSLog(@"系统定位服务未开启，用户无法改变");
            
            if (![@"kCLAuthorizationStatusRestricted" isEqualToString:self.displayingAlertStatus]) {
                
                self.displayingAlert.delegate = nil;
                [self.displayingAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                NSString *alertTitle = [NSString stringWithFormat:@"位置信息访问受限"];
                NSString *alertMessage = [NSString stringWithFormat:@"\n当前无法访问该设备的位置信息，并且您没有权限改变此状态。\n\n\"%@\"很可能处于\"访问限制\"中，并且关闭了\"定位服务\"功能，您可以前往\n\n⚙️设置 → ⚙️通用 → 访问限制\n\n找到\"隐私\"：进入 \"定位服务\"\n允许\"%@\"访问位置信息后返回\n\n如果这依然解决不了您的问题，建议您致电\"苹果中国\"以寻求帮助\n", appName, appName];
                
                NSString *cancelTitle = self.isAlwaysDisplayAlertWhenLocationDisabled ? nil : @"关闭";

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:alertMessage
                                                               delegate:self
                                                      cancelButtonTitle:cancelTitle
                                                      otherButtonTitles:@"前往设置", nil];
                [alert show];
                self.displayingAlert = alert;
                self.displayingAlertStatus = @"kCLAuthorizationStatusRestricted";

            }
            
        } else if (status == kCLAuthorizationStatusDenied) {
            
            locationServicesEnabled = NO;
            
            NSLog(@"用户已拒绝");
            
            if (![@"kCLAuthorizationStatusDenied" isEqualToString:self.displayingAlertStatus]) {
                
                self.displayingAlert.delegate = nil;
                [self.displayingAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                NSString *alertTitle = [NSString stringWithFormat:@"请允许\"%@\"访问您的位置信息", appName];
                NSString *alertMessage = [NSString stringWithFormat:@"\n请前往\n\n⚙️设置 → ✋隐私 → 📍定位服务\n\n允许 \"%@\" 访问您的位置信息。\n\n%@\n", appName, alwaysAndWhenInUse];
                
                NSString *cancelTitle = self.isAlwaysDisplayAlertWhenLocationDisabled ? nil : @"关闭";

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:alertMessage
                                                               delegate:self
                                                      cancelButtonTitle:cancelTitle
                                                      otherButtonTitles:@"前往更改", nil];
                [alert show];
                self.displayingAlert = alert;
                self.displayingAlertStatus = @"kCLAuthorizationStatusDenied";
                
            }
            
        } else {
            
            locationServicesEnabled = YES;
            
            NSLog(@"定位服务可用");
            
            if (self.displayingAlert) {
                self.displayingAlert.delegate = nil;
                [self.displayingAlert dismissWithClickedButtonIndex:0 animated:YES];
                self.displayingAlert = nil;
            }
            if (self.displayingAlertStatus) self.displayingAlertStatus = nil;
            
        }
        
    }
    
    return locationServicesEnabled;
}

#pragma mark - private method

- (void)requestUserLocation
{
    if (!self.isLocationServiceUpdating) {
        
        if (self.alwaysUseLocation) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
        
        self.locationServiceUpdating = YES;
        
    }
    
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.isAlwaysDisplayAlertWhenLocationDisabled) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertView.title
                                                        message:alertView.message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];
        self.displayingAlert = alert;
        self.displayingAlertStatus = nil;
        
    } else {
        
        self.displayingAlert = nil;
        self.displayingAlertStatus = nil;
        
    }
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        
    if ([buttonTitle isEqualToString:@"前往设置"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root"] options:@{} completionHandler:NULL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root"]];
        }
        
    }
    
    if ([buttonTitle isEqualToString:@"前往更改"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:NULL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }

    }
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (!self.geocoder.isGeocoding) {
        [self.geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (self.locationCompletion != NULL) self.locationCompletion(self, placemarks.lastObject, error);
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.locationCompletion != NULL) self.locationCompletion(self, nil, error);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
