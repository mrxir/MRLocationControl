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

@interface ViewController ()

@property (nonatomic, weak) IBOutlet MRLocationControl *locationControl;

@end

@implementation ViewController

- (void)showLocationController
{
    UINavigationController *city = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"location"];
    [self presentViewController:city animated:YES completion:NULL];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.locationControl addTarget:self action:@selector(showLocationController) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationControl.alwaysDisplayAlertWhenLocationDisabled = YES;
    self.locationControl.alwaysUseLocation = YES;
    self.locationControl.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationControl startLocate];
    self.locationControl.locationCompletion = ^(MRLocationControl *locationControl, CLPlacemark *placemark, NSError *error) {
        NSLog(@"城市: %@", placemark.locality);
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
