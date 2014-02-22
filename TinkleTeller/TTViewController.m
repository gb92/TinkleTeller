//
//  TTViewController.m
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/21/14.
//
//

#import "TTViewController.h"


@interface TTViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;

@end

@implementation TTViewController




- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.currentStatusLabel setTextAlignment:NSTextAlignmentCenter];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if(self.connectedPeripheral == nil)
    {
        self.currentStatusLabel.text = @"Tinkler Not Connected";
    }
    else
    {
        self.currentStatusLabel.text = @"Clean";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"Services Discovered %@", peripheral.services);
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
}




@end
