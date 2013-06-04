TinCanObjC
==========
[![Build Status](https://travis-ci.org/rusticisoftware/TinCanObjC.png)](https://travis-ci.org/rusticisoftware/TinCanObjC)

ObjC version of TinCan SDK

##Creating and Sending A Statement

    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lrs = [[NSMutableDictionary alloc] init];
    
    [lrs setValue:@"https://cloud.scorm.com/ScormEngineInterface/TCAPI/public/" forKey:@"endpoint"];
    [lrs setValue:@"Basic abcd1234abcd1234ETmM1bWFwYk5wckg5aE1KQmNaNTFabcdefghijklmnop123" forKey:@"auth"];

    // just add one LRS for now
    [options setValue:[NSArray arrayWithObject:lrs] forKey:@"recordStore"];
    
    RSTinCanConnector *tincan = [[RSTinCanConnector alloc]initWithOptions:options];
    
    // create a TCActor with the user's information
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Joe User" withMbox:@"mailto:user@tincanapi.com"];
    
    // create a very basic TCActivityDefinition that doesn't contain any extensions or interaction detail.
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValue alloc] initWithLanguageCode:@"en-US" withValue:@"http://tincanapi.com/testCourse"]
                                                              withDescription:[[TCLocalizedValue alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:@"http://adlnet.gov/expapi/activities/course"
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:@"http://tincanapi.com/test" withActivityDefinition:actDef];
    
    TCVerb *verb = [[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValue alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb];
    
    [tincan sendStatement:statementToSend withCompletionBlock:^(){
        // do your completion stuff here
    }withErrorBlock:^(TCError *error){
        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
    }];
