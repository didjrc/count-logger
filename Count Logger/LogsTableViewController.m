//
//  LogsTableViewController.m
//  Count Logger
//
//  Created by Jonathan Reid Chinen on 6/7/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//

#import "LogsTableViewController.h"
#import "Eczemama.h"
#import "Data.h"

@implementation LogsTableViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:EczemamaDataUpdatedNotification object:[Eczemama sharedEczemama] queue:nil
												  usingBlock:^(NSNotification *note) {
													  [self.tableView reloadData];
												  }];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EczemamaDataUpdatedNotification object:[Eczemama sharedEczemama]];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return Eczemama.sharedEczemama.numberOfLogs;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"LogsTableCell";
	
	//initialize cell --> Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	//Added
	//Alternates colors of rows
	if (indexPath.row % 2 == 0)
		cell.backgroundColor = [UIColor colorWithRed:234.0/255.0 green: 120.0/255.0 blue: 69.0/255.0 alpha: 1.0];
	else
		cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green: 128.0/255.0 blue: 74.0/255.0 alpha: 1.0];
	//endAdded
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//assign Tricorder.sharedTricorder.recordedData[indexPath.row] to TricorderData pointer *data
	Data *data = Eczemama.sharedEczemama.recordedData[indexPath.row];
	
	//format the timestamp with *dateFormatter
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, h:mm:ss:SSS"];
	
	//takes the timestamp property declared in *data and outputs it to the cell.textLabel.text
	cell.textLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000]];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Packet %u", data.packetId];
	
	return cell;
}

@end
