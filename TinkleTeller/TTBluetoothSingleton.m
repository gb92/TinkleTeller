//
//  TTBluetoothSingleton.m
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import "TTBluetoothSingleton.h"

@interface TTBluetoothSingleton ()

@end

static TTBluetoothSingleton *singletonInstance;


@implementation TTBluetoothSingleton

/*
-(id) init
{
    if(self = [super init])
    {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        [self.centralManager scanForPeripheralsWithServices:nil options:options];
    }
    return self;
}
 */

- (NSMutableArray *) discoveredDevices
{
    if(_discoveredDevices == nil)
    {
        _discoveredDevices=[[NSMutableArray alloc] init];
    }
    return _discoveredDevices;
}

+(TTBluetoothSingleton *) getInstance
{
    if(singletonInstance == nil)
    {
        singletonInstance=[[super alloc] init];
    }
    return singletonInstance;
}

- (CBCentralManager *) centralManager
{
    if(_centralManager == nil)
    {
        _centralManager=[[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Connected to Peripheral" message:[NSString stringWithFormat:@"Connected to Device %@",peripheral.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
    self.connectedPeripheral=peripheral;
    self.connectedPeripheral.delegate=self.connectedDeviceDelegate;
    
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"Peripheral Discovered Name:%@ ID: %@", peripheral.name, peripheral.identifier);
    
    [self.discoveredDevices addObject:peripheral];
    
    if( self.deviceListDelegate != nil && [self.deviceListDelegate respondsToSelector:@selector(deviceListUpdated:)])
    {
        [self.deviceListDelegate deviceListUpdated:self.discoveredDevices];
    }
    
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

-(void) connectToPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager connectPeripheral:peripheral options:nil];
    
    self.connectedPeripheral=peripheral;
}

-(void) scanForDevices
{
    self.discoveredDevices=[[NSMutableArray alloc] init];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, NO, nil];
    //@[[CBUUID UUIDWithString:@"ffe1"]]
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

@end
