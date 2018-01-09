//
//  ViewController.m
//  MRLocationControl
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MRXIR Inc. All rights reserved.
//

#import "ViewController.h"

#import "MRLocationControl.h"

#import "MRLocationCityController.h"

#import <MRFramework/MRFoundation.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet MRLocationControl *locationControl;

@end

@implementation ViewController

#pragma mark - setter and getter

- (void)setSelectedCity:(NSString *)selectedCity
{
    _selectedCity = selectedCity;
    
    [self.locationControl.geocoder cancelGeocode];
    
    [self stop];
    
    [self.locationControl.titleButton setTitle:[selectedCity stringByReplacingOccurrencesOfString:@"市" withString:@""]
                                      forState:UIControlStateNormal];
    
}

- (void)showLocationController
{
    UINavigationController *city = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"location"];
    
    if ([city.viewControllers.firstObject respondsToSelector:@selector(setViewControllerDelegate:)]) {
        [city.viewControllers.firstObject performSelector:@selector(setViewControllerDelegate:) withObject:self];
    }
    
    [self presentViewController:city animated:YES completion:NULL];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.locationControl.titleButton addTarget:self action:@selector(showLocationController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.locationControl.titleButton setTitle:@"定位中..." forState:UIControlStateNormal];
    self.locationControl.alwaysDisplayAlertWhenLocationDisabled = YES;
    self.locationControl.alwaysUseLocation = YES;
    self.locationControl.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationControl.locationCompletion = ^(MRLocationControl *locationControl, CLPlacemark *placemark, NSError *error) {
        
        if (error) {
            NSLog(@"定位失败: %@", error);
        } else {
            NSLog(@"\n\n地标: %@\n", placemark);
            NSLog(@"\n定位成功: %@", placemark.addressDictionary.stringWithUTF8);
            
            [self stop];
            
            if (self.selectedCity) {
                
                [locationControl.titleButton setTitle:[self.selectedCity stringByReplacingOccurrencesOfString:@"市" withString:@""]
                                             forState:UIControlStateNormal];
                
            } else {

                [locationControl.titleButton setTitle:[placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""]
                                             forState:UIControlStateNormal];

            }
            
            
        }
        
    };
    
}

- (void)start
{
    if (!self.selectedCity) {
        
        [self.locationControl startLocate];
        
        [UIView animateWithDuration:1 delay:0.3 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.locationControl.leftImageView.transform = CGAffineTransformMakeTranslation(0, 4);
        } completion:NULL];
    }
}

- (void)stop
{
    [self.locationControl stopLoacte];
    
    self.locationControl.leftImageView.transform = CGAffineTransformIdentity;
    [self.locationControl.leftImageView.layer removeAllAnimations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
