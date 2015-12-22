//
//  ViewController.m
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ConfigViewController.h"
#import "CameraViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate>
{
    int screenWidth, screenHeight;
    UIButton *shutterButtonUI;
}
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // MARK: Initial vars
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    self.connectionStatLabel.text = @"Disconnected";

    // MARK: Parts of shutter button
    shutterButtonUI = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shutterButtonUI.tag = 101;
    shutterButtonUI.frame = CGRectMake(screenWidth/2-screenWidth/4, screenHeight-80, screenWidth/2, 40);
    [[shutterButtonUI layer] setBorderWidth:1.0];
    [[shutterButtonUI layer] setCornerRadius:10.0];
    [[shutterButtonUI layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [[shutterButtonUI layer] setBackgroundColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [shutterButtonUI setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shutterButtonUI setTitle:@"SHUTTER" forState:UIControlStateNormal];
    [shutterButtonUI addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchDown];
    
    // MARK: Attribute of each buttons
    [[self.startCameraButtonUI layer] setBorderWidth:1.0f];
    [[self.startCameraButtonUI layer] setCornerRadius:10.0];
    [[self.startCameraButtonUI layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
    
    [[self.configButtonUI layer] setBorderWidth:1.0f];
    [[self.configButtonUI layer] setCornerRadius:10.0];
    [[self.configButtonUI layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
    
    [[self.findShutterDeviceButtonUI layer] setBorderWidth:1.0f];
    [[self.findShutterDeviceButtonUI layer] setCornerRadius:10.0];
    [[self.findShutterDeviceButtonUI layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
    
    // MARK: user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *udDict = [NSMutableDictionary dictionary];
    [udDict setObject:@"(c) watermark" forKey:@"watermark"];
    [udDict setObject:@"YES" forKeyedSubscript:@"location"];
    [udDict setObject:@"NO" forKey:@"cameraCtrl"];
    [udDict setObject:@"96" forKey:@"fontSize"];
    [userDefaults registerDefaults:udDict];

    // MARK: MCSession initialize
    // Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    // Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    // Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"btCamera" session:self.mySession];
    // Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"btCamera" discoveryInfo:nil session:self.mySession];
    // Start Adv
    self.browserVC.delegate = self;
    self.mySession.delegate = self;
    [self.advertiser start];
    
    AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AD.myPeerID = self.myPeerID;
    AD.mySession = self.mySession;
    AD.browserVC = self.browserVC;
    AD.advertiser = self.advertiser;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bluetooth peering button

- (void) showBrowserVC {
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC {
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
}

// MARK: Send shuttering
- (void)sendData:(id)sender {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"aData"];
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
}

// MARK: Peer status
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        dispatch_async(dispatch_get_main_queue(),^{
            AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AD.isConnected = YES;
            self.connectionStatLabel.text = @"Connected";
            [self.view addSubview:shutterButtonUI];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AD.isConnected = NO;
            self.connectionStatLabel.text = @"Disconnected";
            [[self.view viewWithTag:101] removeFromSuperview];
        });
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

#pragma mark - Move to Camera VC

- (IBAction)startCameraButton:(id)sender {
    // Blank, OK. Beacuse using segue.
}

#pragma mark - Move to Config VC

- (IBAction)configButton:(id)sender {
    // Blank, OK. Beacuse using segue.
}

#pragma mark - Move to BLE device browse VC

- (IBAction)findShutterDevice:(id)sender {
    [self showBrowserVC];
}

@end
