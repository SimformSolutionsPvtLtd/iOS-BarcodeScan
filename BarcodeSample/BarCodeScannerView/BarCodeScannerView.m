//
//  BarCodeScannerView.m
//  MissionRabiesApp
//
//  Created by Sunil Chauhan on 06/11/14.
//  Copyright (c) 2014 Shah.Hardik. All rights reserved.
//

#import "BarCodeScannerView.h"

@interface BarCodeScannerView ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation BarCodeScannerView

#pragma mark -

+ (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(UIWindow *) mainWindow{
    static dispatch_once_t onceToken;
    static UIWindow *win;
    dispatch_once(&onceToken, ^{
        for (UIWindow *w in [[UIApplication sharedApplication] windows]) {
            if (w.windowLevel == UIWindowLevelNormal) {
                win = w;
                break;
            }
        }
    });
    return win;
}

+(void) showScannerWithCompletionBlock:(BarCodeScanCompletionBlock)completionBlock{
    BarCodeScannerView *scanner = [[BarCodeScannerView alloc] initWithNibName:@"BarCodeScannerView" bundle:nil];
    scanner.completionBlock = completionBlock;
    
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:scanner];
    
    [[self topMostController] presentViewController:navCont animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:56/255.0f green:126/255.0f blue:213/255.0f alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    viewResultCenterYAlignConstraint.constant = [[self mainWindow] frame].size.height / 2 + 111;
    [viewResultMain layoutIfNeeded];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped:)];
    cancel.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    [self startReading];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

-(void) cancelTapped:(id)sender{
    [[BarCodeScannerView topMostController] dismissViewControllerAnimated:YES completion:nil];
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
}

-(IBAction) doneTapped:(id)sender{
    [[BarCodeScannerView topMostController] dismissViewControllerAnimated:YES completion:nil];
    [self dismissResultviewWithCompletionBlock:nil];
    if (self.completionBlock) {
        self.completionBlock(resultString);
    }
}

-(IBAction) retryTapped:(id)sender{
    [self dismissResultviewWithCompletionBlock:^(NSString *result) {
        [self startReading];
    }];;
}

#pragma mark -

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:
                                                   AVMetadataObjectTypeAztecCode,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeCode39Code,
                                                   AVMetadataObjectTypeCode39Mod43Code,
                                                   AVMetadataObjectTypeCode93Code,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypePDF417Code,
                                                   AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeUPCECode, nil]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void) presentResultView{
    viewResultMain.backgroundColor = [UIColor clearColor];
    [[self mainWindow] addSubview:viewResultMain];
    
    viewResultCenterYAlignConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        viewResultMain.backgroundColor = [UIColor colorWithWhite:0.67 alpha:1.0];
        [viewResultMain layoutIfNeeded];
    }];
}

-(void) dismissResultviewWithCompletionBlock:(BarCodeScanCompletionBlock)block{
    viewResultCenterYAlignConstraint.constant = [[self mainWindow] frame].size.height / 2 + 111;
    [UIView animateWithDuration:0.5 animations:^{
        viewResultMain.backgroundColor = [UIColor clearColor];
        [viewResultMain layoutIfNeeded];
    } completion:^(BOOL finished) {
        [viewResultMain removeFromSuperview];
        if (block) {
            block(nil);
        }
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        // If the found metadata is equal to the QR code metadata then update the status label's text,
        // stop reading and change the bar button item's title and the flag's value.
        resultString = [metadataObj stringValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            txtResult.text = resultString;
            [self stopReading];
            [self presentResultView];
        });
        
        _isReading = NO;
    }
}

@end
