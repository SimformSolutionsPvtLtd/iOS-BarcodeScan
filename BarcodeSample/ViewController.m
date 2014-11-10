#import "ViewController.h"
#import "BarCodeScannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)StartBarcodeScanning:(id)sender
{
    [BarCodeScannerView showScannerWithCompletionBlock:^(NSString *result) {
        if (result != nil && ![result isEqualToString:@""]) {
            //some text has been scanned and text will return.
            NSLog(@"%@",result);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
