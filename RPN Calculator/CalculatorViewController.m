#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsTypingFloatingPointNumber;
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableArray *history;

@end

@implementation CalculatorViewController

@synthesize display;
@synthesize auxillaryDisplay;
@synthesize userIsInTheMiddleOfTypingANumber;
@synthesize userIsTypingFloatingPointNumber;
@synthesize brain = _brain;
@synthesize history = _history;

#define kHistoryCapacity 10 // We're only allowing a limited number of histoy 
                            // items to be remembered.

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
        
    return _brain;    
}

- (NSMutableArray *)history
{
    if (!_history)
        _history = [[NSMutableArray alloc] initWithCapacity:kHistoryCapacity];
    
    return _history;
        
}

- (IBAction)dotPressed 
{
    if (userIsTypingFloatingPointNumber)
        return; // Early bailout - returning if dot was already pressed when
                // typing the number.
    
    self.userIsInTheMiddleOfTypingANumber = YES;
    
    self.userIsTypingFloatingPointNumber = YES;
    self.display.text = [self.display.text stringByAppendingString:@"."];
        
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfTypingANumber)
        self.display.text = [self.display.text stringByAppendingString:digit];
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)enterPressed 
{   
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    self.userIsInTheMiddleOfTypingANumber = NO;
    self.userIsTypingFloatingPointNumber = NO;
    
    // TODO: NSAssert - history masyve *negali* buti *daugiau* elementu nei 
    // nurodyta konstantoje.
    
    if (self.history.count == kHistoryCapacity)
        [self.history removeObjectAtIndex:0];
    
    [self.history addObject: self.display.text];
    
    self.auxillaryDisplay.text = [self.history componentsJoinedByString:@" "];
}

- (IBAction)clearPressed 
{
    [self.brain restart];

    self.history = nil;
    
    self.auxillaryDisplay.text = @"";
    self.display.text = @"0";
    
    self.userIsTypingFloatingPointNumber = NO;
    self.userIsInTheMiddleOfTypingANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTypingANumber)
        [self enterPressed];
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    // TODO: NSAssert - history masyve *negali* buti *daugiau* elementu nei 
    // nurodyta konstantoje.
    
    if (self.history.count == kHistoryCapacity)
        [self.history removeObjectAtIndex:0];
    
    [self.history addObject: sender.currentTitle];
    
    self.auxillaryDisplay.text = [self.history componentsJoinedByString:@" "];
}

- (void)viewDidUnload 
{
    [self setAuxillaryDisplay:nil];
    [super viewDidUnload];
}

@end
