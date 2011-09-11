//
//  RootViewController.h
//  FGallery
//
//  Created by Grant Davis on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface RootViewController : UITableViewController <FGalleryViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	NSArray *localCaptions;
    NSArray *localImages;
    NSArray *networkCaptions;
    NSArray *networkImages;
    NSMutableArray *documentsCaptions;
    NSMutableArray *documentsImages;
    NSUInteger imageCount;
	FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
    FGalleryViewController *documentsGallery;
    
}

- (void)loadCamera:(id)sender;

@end
