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
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>

@interface CameraViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate> {
    int screenWidth, screenHeight;
    UIImagePickerController *imagePickerController;
    UIImage *originalImage;
    UIButton *backButton;
}
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // MARK: Initial vars
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;

    // MARK: Part of back button
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.tag = 101;
    backButton.frame = CGRectMake(0, screenHeight-40, 60, 40);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backButton];
    
    // Ready for GPS
    if (nil == self.locationManager) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // MARK: MCSession initialize from appdelegate
    AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (AD.isConnected == YES) {
        // Setup peer ID
        self.myPeerID = AD.myPeerID;
        
        // Setup session
        self.mySession = [[MCSession alloc] initWithPeer:AD.myPeerID];
        AD.mySession.delegate = self;
        
        // Setup BrowserViewController
        self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"btCamera" session:AD.mySession];
        
        // Setup Advertiser
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"btCamera" discoveryInfo:nil session:AD.mySession];
        
        // show camera with delay
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.4];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCSession methods

// MARK: Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
}

// MARK: Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
}

// MARK: When receive data from peer device
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self->imagePickerController takePicture];
}

// MARK: When remote peer state change
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// MARK: Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

// MARK: Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

#pragma mark - Location update

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}

#pragma mark - Show camera if connection

- (void)showcamera {
    // MARK: Enable camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Create instance UIImagePickerController
        imagePickerController = [[UIImagePickerController alloc] init];
        
        // Setting delegate
        imagePickerController.delegate = self;
        
        // Setting camera source
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Edit after picking image
        imagePickerController.allowsEditing = NO;
        
        // Camera control
        imagePickerController.showsCameraControls = NO;
        
        // Device's screen size (ignoring rotation intentionally):
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // iOS is going to calculate a size which constrains the 4:3 aspect ratio
        // to the screen size. We're basically mimicking that here to determine
        // what size the system will likely display the image at on screen.
        // NOTE: screenSize.width may seem odd in this calculation - but, remember,
        // the devices only take 4:3 images when they are oriented *sideways*.
        float cameraAspectRatio = 4.0 / 3.0;
        float imageWidth = floorf(screenSize.width * cameraAspectRatio);
        float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
        
        imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
        
        // Start camera
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        return;
    }
}

#pragma mark - Finish picking image

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Stop Camera.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Send image to peer device and back to start screen.
    [self sendImage:originalImage peerID:self.myPeerID];
    
    // Back to home screen.
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Cancel camera screen

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Send image to peer device

- (void)sendImage:(UIImage *)image peerID:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.locationManager startUpdatingLocation];
        
        // Convert UIImage to NSData.
        NSData *jpegData = UIImageJPEGRepresentation(image, 1.0f);
        
        // Get location.
        CLLocation *location = self.locationManager.location;
        // Convert location to serialize.
        NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:location];
        
        // Create NSMutableArray and add to each NSData.
        NSMutableArray *concatenatedData = [NSMutableArray array];
        [concatenatedData insertObject:jpegData atIndex:0];
        [concatenatedData insertObject:locationData atIndex:1];

        // Convert NSMutableData to serialize.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:concatenatedData];
        
        // Send serialized data to peer devices.
        AppDelegate *AD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSError *error;
        [AD.mySession sendData:data
                       toPeers:[AD.mySession connectedPeers]
                      withMode:MCSessionSendDataUnreliable
                         error:&error];
        if (error) {
            NSLog(@"Sending Failed %@", error);
        }
        
        [self.locationManager stopUpdatingLocation];
    });
}

#pragma mark - Back

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
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
