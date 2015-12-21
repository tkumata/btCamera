//
//  CameraViewController.m
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "CameraViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CameraViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate> {
    
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // MARK: MCSession initialize
    AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Setup peer ID
    AD.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    // Setup session
    AD.mySession = [[MCSession alloc] initWithPeer:AD.myPeerID];
    // Setup BrowserViewController
    AD.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"btCamera" session:AD.mySession];
    // Setup Advertiser
    AD.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"btCamera" discoveryInfo:nil session:AD.mySession];
    // Start Adv
    AD.browserVC.delegate = self;
    AD.mySession.delegate = self;
//    [self.advertiser start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCSession methods

- (void) showBrowserVC {
}

- (void) dismissBrowserVC {
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

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
    } else {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
