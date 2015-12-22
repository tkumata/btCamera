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

@interface CameraViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    int screenWidth, screenHeight;
    UIImagePickerController *imagePickerController;
    UIImage *originalImage;
    UIButton *backButton;
}
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

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
    backButton.frame = CGRectMake(10, 28, screenWidth/3, 40);
    [[backButton layer] setBorderWidth:1.0];
    [[backButton layer] setCornerRadius:10.0];
    [[backButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    //[[backButton layer] setBackgroundColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    //[backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backButton];
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
        // Setup BrowserViewController
        self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"btCamera" session:AD.mySession];
        // Setup Advertiser
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"btCamera" discoveryInfo:nil session:AD.mySession];
        
        AD.browserVC.delegate = self;
        AD.mySession.delegate = self;
        
        // show camera with delay
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
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
    
    // Preview picked image
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.image = originalImage;
    [self.view addSubview:iv];
    
    // Stop Camera
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Save to Photos
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save"
                                                                             message:@"Do you save this picture?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self saveBUttonPushed];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self cancelButtonPushed];
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Cancel picking image

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Save or cancel picking image

// Save OK
- (void)saveBUttonPushed {
    UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(addDidFinished:didFinishSavingWithError:contentextInfo:), nil); // normal save
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Save Cancel
- (void)cancelButtonPushed {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
- (void)addDidFinished:(UIImage *)image didFinishSavingWithError:(NSError *)error contentextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    }
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
