//
//  RootViewController.m
//  FGallery
//
//  Created by Grant Davis on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
    
	self.title = @"FGallery";
    
	localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
    
    networkCaptions = [[NSArray alloc] initWithObjects:@"Winter spider", @"Happy New Year!",nil];
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
    
    documentsCaptions = [[NSMutableArray alloc] init];
    documentsImages = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Camera

- (IBAction)loadCamera:(id)sender {
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        // Delegate is self
        imagePicker.delegate = self;
        
        // Allow editing of image ?
        imagePicker.allowsEditing = NO;
        
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera Available" 
                                                        message:@"Unable to start the camera." 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL success = NO;
    
    //get saving path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"latestPhoto.png"];
        
        //extract image from the picker and save it to imagePath
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];   
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
#warning TODO: make new thread here to save image, or may be for PNG conversion here above...
            NSData *PNGImageData = UIImagePNGRepresentation(originalImage);
            
            success = [[NSFileManager defaultManager] createFileAtPath:imagePath 
                                                              contents:PNGImageData 
                                                            attributes:nil];
            
            if (!success) {
                NSLog(@"error saving image");
            }
        } else {
            NSLog(@"Error, image is not public");
        }
    } else {
        NSLog(@"Error no document's directory");
    }
    
    if (success) {
        NSLog(@"photo saved");
        [documentsImages addObject:@"latestPhoto.png"];
        [documentsCaptions addObject:@"latestPhoto.png"];
    }
    
    // now, we can remove the picker
    [self dismissModalViewControllerAnimated:YES];
    
	[picker release];
}


#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	if( indexPath.row == 0 ) {
		cell.textLabel.text = @"Local Images";
	}
    else if( indexPath.row == 1 ) {
		cell.textLabel.text = @"Network Images";
	}
	else if( indexPath.row == 2 ) {
		cell.textLabel.text = @"Custom Controls";
	}
    else if( indexPath.row == 3 ) {
//        if (![documentsImages count]) {
//            [cell setUserInteractionEnabled:NO];
//            [cell.textLabel setTextColor:[UIColor grayColor]];
//            [cell.textLabel setText:@"Document Gallery is empty"];
//        }
//        else {
//            [cell setUserInteractionEnabled:YES];
//            [cell.textLabel setTextColor:[UIColor blackColor]];
//            [cell.textLabel setText:@"Document Gallery"];
//        }
        [cell.textLabel setText:@"Document Gallery"];
    }
    else if( indexPath.row == 4) {
        cell.textLabel.text = @"take a picture";
    }

    return cell;
}


#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == localGallery ) {
        num = [localImages count];
    }
    else if( gallery == networkGallery ) {
        num = [networkImages count];
    }
    else if (gallery == documentsGallery) {
        num = [documentsImages count];
    }
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else if (gallery == documentsGallery) {
        return FGalleryPhotoSourceTypeDocuments;
    } else {
        return FGalleryPhotoSourceTypeNetwork;
    }
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
    else if( gallery == networkGallery ) {
        caption = [networkCaptions objectAtIndex:index];
    } 
    else if( gallery == documentsGallery) {
        caption = [documentsCaptions objectAtIndex:index];
    }
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    if (gallery == localGallery) {
        return [localImages objectAtIndex:index];
    } else {
        return [documentsImages objectAtIndex:index];
    }
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if( indexPath.row == 0 ) {
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:localGallery animated:YES];
        
        [localGallery release];
        imageCount = [localImages count];
	}
    else if( indexPath.row == 1 ) {
		networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:networkGallery animated:YES];
        [networkGallery release];    
        imageCount = [networkImages count];
    }
	else if( indexPath.row == 2 ) {
		UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
		UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
		UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)] autorelease];
		UIBarButtonItem *editCaptionButton = [[[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)] autorelease];
		NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];
		
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
        [self.navigationController pushViewController:localGallery animated:YES];
        [localGallery release];
        imageCount = [localImages count];
	} else if (indexPath.row == 3) {
        documentsGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:documentsGallery animated:YES];
        [documentsGallery release];
        imageCount = [documentsImages count];
    }
    else if (indexPath.row == 4) {
        [self loadCamera:nil];
    }
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

