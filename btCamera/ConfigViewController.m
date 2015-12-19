//
//  ConfigViewController.m
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "ConfigViewController.h"
#import "ViewController.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // MARK: Read settings and apply
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.watermarkTF.text = [userDefaults stringForKey:@"watermark"];
    self.locationSWUI.on = [userDefaults boolForKey:@"location"];
    self.fontsizeLabel.text = [userDefaults stringForKey:@"fontSize"];
    self.fontsizeVCUI.value = self.fontsizeLabel.text.integerValue;
    self.cameraCtrlSWUI.on = [userDefaults boolForKey:@"cameraCtrl"];
    
    // MARK: Attributes
    [[self.finishButtonUI layer] setBorderWidth:1.0f];
    [[self.finishButtonUI layer] setCornerRadius:10.0];
    [[self.finishButtonUI layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
    
    [[self.defaultButtonUI layer] setBorderWidth:1.0f];
    [[self.defaultButtonUI layer] setCornerRadius:10.0];
    [[self.defaultButtonUI layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Change font size stepper

- (IBAction)fontsizeVC:(id)sender {
    self.fontsizeLabel.text = [NSString stringWithFormat:@"%.f", self.fontsizeVCUI.value];
}

- (IBAction)locationSW:(id)sender {
}

- (IBAction)cameraCtrlSW:(id)sender {
}

#pragma mark - Save settings and back screen

- (IBAction)finishButton:(id)sender {
    // Save settings to UserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.watermarkTF.text forKey:@"watermark"];
    [userDefaults setBool:self.locationSWUI.on forKey:@"location"];
    [userDefaults setBool:self.cameraCtrlSWUI.on forKey:@"cameraCtrl"];
    [userDefaults setObject:self.fontsizeLabel.text forKey:@"fontSize"];
    [userDefaults synchronize];
    
    // Back
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Return to default setting

- (IBAction)defaultButton:(id)sender {
    // Save default settings to UserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"(c) watermark" forKey:@"watermark"];
    [userDefaults setBool:YES forKey:@"location"];
    [userDefaults setBool:NO forKey:@"cameraCtrl"];
    [userDefaults setObject:@"96" forKey:@"fontSize"];
    [userDefaults synchronize];
    
    // Back
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
