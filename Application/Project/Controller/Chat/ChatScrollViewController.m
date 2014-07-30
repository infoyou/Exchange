//
//  ChatScrollViewController.m
//  Project
//
//  Created by XXX on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChatScrollViewController.h"
#import "MRZoomScrollView.h"


@interface ChatScrollViewController () <UIScrollViewDelegate>


@property (nonatomic, retain) UIScrollView      *scrollView;
@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;
@end

@implementation ChatScrollViewController {
    NSArray *_imageArray;
    
    IBOutlet UIImageView * imageView;
	
	CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;
}

@synthesize scrollView = _scrollView;
@synthesize zoomScrollView = _zoomScrollView;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
       withImages:(NSArray *)imageArray
{
    self = [super initWithMOC:MOC];
    if (self) {
        _imageArray = [imageArray retain];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
	
	lastDistance=0;
	return [super initWithCoder:aDecoder];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	CGPoint p1;
	CGPoint p2;
	CGFloat sub_x;
	CGFloat sub_y;
	CGFloat currentDistance;
	CGRect imgFrame;
	
	NSArray * touchesArr=[[event allTouches] allObjects];
	
	if ([touchesArr count]>=2) {
		p1=[[touchesArr objectAtIndex:0] locationInView:self.view];
		p2=[[touchesArr objectAtIndex:1] locationInView:self.view];
		
		sub_x=p1.x-p2.x;
		sub_y=p1.y-p2.y;
		
		currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
		
		if (lastDistance>0) {
			
			imgFrame=imageView.frame;
			
			if (currentDistance>lastDistance+2) {
				
				imgFrame.size.width+=10;
				if (imgFrame.size.width>1000) {
					imgFrame.size.width=1000;
				}
				
				lastDistance=currentDistance;
			}
			if (currentDistance<lastDistance-2) {
				
				imgFrame.size.width-=10;
				
				if (imgFrame.size.width<50) {
					imgFrame.size.width=50;
				}
				
				lastDistance=currentDistance;
			}
			
			if (lastDistance==currentDistance) {
				imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                
                float addwidth=imgFrame.size.width-imageView.frame.size.width;
                float addheight=imgFrame.size.height-imageView.frame.size.height;
                
				imageView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
			}
			
		}else {
			lastDistance=currentDistance;
		}
        
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	lastDistance=0;
}

- (void)initImageView:(NSArray *)imageArray
{
    if (imageArray.count ) {
        
        imageView = [[UIImageView alloc]init];
        
        // The imageView can be zoomed largest size
        
        UIImage *image = [imageArray objectAtIndex:0];
        
        int height = image.size.height;
        int width = image.size.width;
        
        int h=0;
        int w=0;
        
        float viewScare = self.view.frame.size.height / self.view.frame.size.width;
        float imageScare = height / width;
       
        if (viewScare > imageScare) {
            w = self.view.frame.size.width;
            h = w*imageScare;
        }else{
            h=self.view.frame.size.height;
            w= h / imageScare;
        }
        
        int startX = (_screenSize.width - w) / 2.0f;
        int startY = (_screenSize.height - SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - h) / 2.0f;
        imageView.frame = CGRectMake(startX, startY, w , h );
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = image;
        [self.view addSubview:imageView];
        [imageView release];
        
        imgStartWidth=imageView.frame.size.width;
        imgStartHeight=imageView.frame.size.height;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImageView:_imageArray];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    RELEASE_OBJ(_scrollView);
    RELEASE_OBJ(_zoomScrollView);
    RELEASE_OBJ(_imageArray);
    [super dealloc];
}

@end
