//
//  ViewController.m
//  Bubble
//
//  Created by admin on 7/22/14.
//  Copyright (c) 2014 Jan Timar. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic,strong) BubbleView *myBubbleView;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;

@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorComponentSegment;

@property (weak, nonatomic) IBOutlet UITextField *bubbleTextField;

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = CGRectMake(20, 350, 280*2.5f, 145*2.5f);
    
    self.myBubbleView = [[BubbleView alloc] initWithText:@"Hello world :) these is my bubble, My name is Jhon" textColor:[UIColor blueColor] fillColor:[UIColor grayColor] strokeColor:[UIColor redColor] lineWidth:self.widthSlider.value angle:30 oppacity:1.0f type:kSpeech inFrame:frame];
    [self.myBubbleView setFontSize:26.0f];
    
    [self.view addSubview:self.myBubbleView];
}

- (IBAction)bubbleEditingChanged:(UITextField *)sender {
    self.myBubbleView.text = sender.text;
}

- (IBAction)bubbleTypeChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.myBubbleView.type = kSpeech;
            break;
        case 1:
            self.myBubbleView.type = kThink;
            break;
            
        default:
            break;
    }
}
- (IBAction)chooseComponentForChangeColor:(UISegmentedControl *)sender {
    //float red, green,blue,alpha;
    float red, green,blue,alpha;
    switch (sender.selectedSegmentIndex) {
        case 0:{ // text
            UIColor *color = [self.myBubbleView textColor];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
            break;
        case 1:{ // fill
            UIColor *color = [self.myBubbleView fillColor];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
            break;
        case 2:{ // stroke
            UIColor *color = [self.myBubbleView strokeColor];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
            break;
        default:
            break;
    }
    [self.redSlider setValue:red*10];
    [self.blueSlider setValue:blue*10];
    [self.greenSlider setValue:green*10];
}

- (IBAction)colorChange:(UISlider *)sender {
    float red = 1.0f/self.redSlider.value;
    float green = 1.0f/self.greenSlider.value;
    float blue = 1.0f/self.blueSlider.value;
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    switch (self.colorComponentSegment.selectedSegmentIndex) {
        case 0:{ // text
            [self.myBubbleView setTextColor:newColor];
        }
            break;
        case 1:{ // fill
            [self.myBubbleView setFillColor:newColor];
        }
            break;
        case 2:{ // stroke
            [self.myBubbleView setStrokeColor:newColor];
        }
            break;
        default:
            break;
    }
}

- (IBAction)alphaChange:(UISlider *)sender {
    [self.myBubbleView setOppacity:sender.value];
}

- (IBAction)angleChange:(UISlider *)sender {
    [self.myBubbleView setAngle:(int)sender.value];
}
- (IBAction)widthChange:(UISlider *)sender {
    [self.myBubbleView setBubbleLineWidth:sender.value];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.bubbleTextField resignFirstResponder];
}

// return key tap
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)contactDeveloperTouch:(id)sender {
    NSString *subject = [NSString stringWithFormat:@"BubbleView app"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"jantimar2@gmail.com"];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    [[UIApplication sharedApplication] openURL:url];
}

@end
