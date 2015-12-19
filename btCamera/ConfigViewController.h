//
//  ConfigViewController.h
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *watermarkTF;
@property (weak, nonatomic) IBOutlet UISwitch *locationSWUI;
@property (weak, nonatomic) IBOutlet UISwitch *cameraCtrlSWUI;
@property (weak, nonatomic) IBOutlet UILabel *fontsizeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *fontsizeVCUI;
@property (weak, nonatomic) IBOutlet UIButton *finishButtonUI;
@property (weak, nonatomic) IBOutlet UIButton *defaultButtonUI;

- (IBAction)fontsizeVC:(id)sender;
- (IBAction)locationSW:(id)sender;
- (IBAction)cameraCtrlSW:(id)sender;
- (IBAction)finishButton:(id)sender;
- (IBAction)defaultButton:(id)sender;

@end
