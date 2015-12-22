//
//  AppDelegate.h
//  btCamera
//
//  Created by KUMATA Tomokatsu on 12/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property BOOL isConnected;

@end

