//  FISAppDelegate.m

#import "FISAppDelegate.h"

@interface FISAppDelegate()
{
}

@end

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

/*

Write your method here

*/

/**
 This method solves the following trivia question:
 What is the only state whose capital contains none of the characters as the state name?
 Example: Alaska isn't the answer because Juneau and Alaska both contain an A.
 
 So the two strings can't share any letters
 
 */
- (NSString *)solveTrivia
{
    NSDictionary *statesAndCapitals = [self _loadDictionary];

    for (NSString *state in statesAndCapitals) {
        NSString *capital = statesAndCapitals[state];
        if (![self _again_string:state sharesLettersWithString:capital]) {
            return state;
        }
        
    }
    return nil;
}

/**
 First Attempt. Naive approach using double for loop to iterate through each letter of each string.
 If we find a letter that is contained in both strings we bail and return NO
 */
- (BOOL)_string:(NSString *)firstString sharesLettersWithString:(NSString *)secondString
{
    // Convert both strings to lowercase for case insensitivity
    NSString *firstLowercase = [firstString lowercaseString];
    NSString *secondLowerCase = [secondString lowercaseString];
    
    // Remove spaces
    NSString *firstNoSpace = [firstLowercase stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *secondNoSpace = [secondLowerCase stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    for (NSUInteger firstIndex = 0; firstIndex < firstNoSpace.length; firstIndex++) {
        NSString *firstStringLetter = [firstNoSpace substringWithRange:NSMakeRange(firstIndex, 1)];
        for (NSUInteger secondIndex = 0; secondIndex < secondNoSpace.length; secondIndex++) {
            NSString *secondStringLetter = [secondNoSpace substringWithRange:NSMakeRange(secondIndex, 1)];
            if ([firstStringLetter isEqualToString:secondStringLetter]) {
                return YES;
            }
        }
        
    }
    return NO;
}

- (BOOL)_again_string:(NSString *)firstString sharesLettersWithString:(NSString *)secondString
{
    // Convert both strings to lowercase for case insensitivity
    NSString *firstLowercase = [firstString lowercaseString];
    NSString *secondLowerCase = [secondString lowercaseString];
    
    // Remove spaces
    NSString *firstNoSpace = [firstLowercase stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *secondNoSpace = [secondLowerCase stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Create a character set with the characters that should not be duplicated
    NSCharacterSet *badCharacters = [NSCharacterSet characterSetWithCharactersInString:firstNoSpace];
    
    // Remove these characters from the second string. If it remains unchanged, then they contain no shared characters
    NSString *secondCopy = [secondNoSpace copy];
    NSString *result = [[secondCopy componentsSeparatedByCharactersInSet:badCharacters] componentsJoinedByString:@""];
    
    if ([result isEqualToString:secondNoSpace]) {
        // No Change, so they do NOT share any letters
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)_loadDictionary
{
    // Get the file via file path
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"StatesAndCapitals"
                                                                      ofType:@"txt"];
    // Encode to string
    NSString *text = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    
    // Enumerate the text string and separate each component into key/value, then store them in a dictionary
    NSMutableDictionary *statesAndCapitalsDict = [[NSMutableDictionary alloc] init];
    [text enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        NSArray *keyAndValue = [line componentsSeparatedByString:@":"];
        NSString *key = keyAndValue.firstObject;
        NSString *value = keyAndValue.lastObject;
        statesAndCapitalsDict[key] = value;
    }];
    return statesAndCapitalsDict;
}

@end
