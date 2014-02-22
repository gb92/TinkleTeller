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


-(TTBluetoothSingleton *) ttBluetooth
{
    if(_ttBluetooth == nil)
    {
        _ttBluetooth=[TTBluetoothSingleton getInstance];
        _ttBluetooth.connectedDeviceDelegate=self;
    }
    return _ttBluetooth;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.currentStatusLabel setTextAlignment:NSTextAlignmentCenter];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if(self.ttBluetooth.connectedPeripheral == nil)
    {
        self.currentStatusLabel.text = @"Tinkler Not Connected";
    }
    else
    {
        [self.ttBluetooth.connectedPeripheral setDelegate:self];
        [self.ttBluetooth.connectedPeripheral discoverServices:nil];
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
    
    for(int i=0; i< [peripheral.services count]; i++)
    {
        [self.ttBluetooth.connectedPeripheral discoverCharacteristics:nil forService:peripheral.services[i]];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"Discovered characteristics for service %@ with characteristics %@", service.UUID, service.characteristics);
    
    for(int i=0; i< [service.characteristics count]; i++)
    {
        [peripheral setNotifyValue:YES forCharacteristic:service.characteristics[i]];
    }
    
    
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSLog(@"Updated Value for Characteristic: %@ with Description: %@", characteristic.UUID, characteristic.description);
    
    NSData *data=characteristic.value;
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [@"0x" stringByAppendingString:string];
    
    const uint8_t *byteArray = [data bytes]; // pointer to the bytes in data
    
    for(int i=0; i<[data length]; i++)
    {
        int byte=byteArray[i];
        NSLog(@"Byte %d = %d", i, byte);
    }
    
    NSLog(@"Data has %lu bytes", data.length);
    NSLog(@"The value is %@",data);
    
    int cleanOrDirty=byteArray[2];
    if(cleanOrDirty == 1)
    {
        self.currentStatusLabel.text=@"Soiled";
        [self.currentStatusLabel setBackgroundColor: [UIColor redColor]];
    }
    else{
        self.currentStatusLabel.text=@"Clean";
        [self.currentStatusLabel setBackgroundColor:[UIColor greenColor]];
        //[self.currentStatusLabel setTextColor: [UIColor greenColor]];
    }
    
    
}




@end
