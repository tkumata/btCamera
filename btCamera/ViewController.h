//
//  ViewController.h
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)startCameraButton:(id)sender;
- (IBAction)configButton:(id)sender;
- (IBAction)findShutterDevice:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *startCameraButtonUI;
@property (weak, nonatomic) IBOutlet UIButton *configButtonUI;
@property (weak, nonatomic) IBOutlet UIButton *findShutterDeviceButtonUI;

@property (weak, nonatomic) IBOutlet UILabel *connectionStatLabel;

@end

