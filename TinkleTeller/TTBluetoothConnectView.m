//
//  TTBluetoothConnectView.m
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import "TTBluetoothConnectView.h"
#import "TTViewController.h"

@interface TTBluetoothConnectView ()


@property (strong, nonatomic) NSMutableArray * discoveredDevices;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TTBluetoothConnectView

- (CBCentralManager *) centralManager
{
    if(_centralManager== nil)
    {
#warning TODO run this on a different queue
        _centralManager=[[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

- (NSMutableArray *) discoveredDevices
{
    if(_discoveredDevices == nil)
    {
       _discoveredDevices=[[NSMutableArray alloc] init];
    }
    return _discoveredDevices;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancelButtonPressed:(id)sender {

   [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self.tableView ]
    
    //central manager stuff
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Connected to Peripheral" message:[NSString stringWithFormat:@"Connected to Device %@",peripheral.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
    TTViewController * ttview=(TTViewController *)self.parentViewController;

    ttview.connectedPeripheral=peripheral;
    
    [peripheral setDelegate: ttview];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"Peripheral Discovered Name:%@ ID: %@", peripheral.name, peripheral.identifier);
    
    [self.discoveredDevices addObject:peripheral];
    [self.tableView reloadData];
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


#pragma mark - UITableView Stuff

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.discoveredDevices count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *device=(CBPeripheral *)self.discoveredDevices[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    [cell.textLabel setText:[device.identifier UUIDString]];
    [cell.detailTextLabel setText:device.name];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *device=(CBPeripheral *)self.discoveredDevices[indexPath.row];

    [self.centralManager connectPeripheral:device options:nil];
    
}
#pragma mark - UITableViewDelegate

@end
