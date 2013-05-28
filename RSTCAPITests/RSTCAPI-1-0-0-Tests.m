//
//  RSTCAPI-1-0-0-Tests.m
//  RSTCAPI
//
//  Created by Brian Rogers on 4/26/13.
//  Copyright (c) 2013 Rustici Software. All rights reserved.
//

#import "RSTCAPI-1-0-0-Tests.h"

@interface RSTCAPI_1_0_0_Tests()
{
    RSTinCanConnector *tincan;
}

@end

@implementation RSTCAPI_1_0_0_Tests

- (void)setUp
{
    [super setUp];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lrs = [[NSMutableDictionary alloc] init];
    [lrs setValue:@"http://localhost:8080/ScormEngineInterface/TCAPI/" forKey:@"endpoint"];
    [lrs setValue:@"Basic c3VwZXJ1c2VyOnN1cGVydXNlcg==" forKey:@"auth"];
    [lrs setValue:@"1.0.0" forKey:@"version"];
    //http://192.168.2.196/ScormEngineNG/TCAPI/
    // just add one LRS for now
    [options setValue:[NSArray arrayWithObject:lrs] forKey:@"recordStore"];
    [options setValue:@"1.0.0" forKey:@"version"];
    tincan = [[RSTinCanConnector alloc]initWithOptions:options];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testSaveStatementWithAttachment
{
    // some image data (base64)
    NSString *imageString = @"data:image/png;base64,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";
    
    // sha2 hash the data
    NSString *sha2 = [TCUtil computeSHA256DigestForString:imageString];
    
    // create the attachment object
    TCAttachment *attachment = [[TCAttachment alloc] initWithSha2:sha2 withDataString:imageString withUsageType:@"http://tincanapi.com/image" withContentType:@"image/png" withContentTransferEncoding:@"base64" withDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"blue-book.png"] withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"a blue book image"] withLength:[NSNumber numberWithInt:imageString.length] withFileUrl:nil];
    
    //NSLog(@"%@",[attachment JSONString]);
    
    TCAttachmentCollection *attachments = [[TCAttachmentCollection alloc] init];
    [attachments addAttachment:attachment];
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statementOptions setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];

    
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Brian Rogers" withMbox:@"mailto:brian@tincanapi.com"];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"http://tincanapi.com/test"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[statementOptions valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[statementOptions valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [statementOptions valueForKey:@"verb"];
    
    TCStatement *statementToPost = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withBoundary:@"abc123" withAttachments:attachments];
    
    NSLog(@"%@", [statementToPost JSONString]);
    
    [tincan sendStatement:statementToPost withCompletionBlock:^(){
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }withErrorBlock:^(TCError *error){
        
        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"saveStatement"];
    
}
- (void)testSaveStatement
{
    
    STAssertNotNil(tincan, @"tincan is not nill");
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statementOptions setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createTestStatementWithOptions:statementOptions];
    
    [tincan sendStatement:statementToSend withCompletionBlock:^(){
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }withErrorBlock:^(TCError *error){
        
        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"saveStatement"];
}

- (void)testSaveStatements
{
    
    STAssertNotNil(tincan, @"tincan is not nill");
    
    TCStatementCollection *statementArray = [[TCStatementCollection alloc] init];
    
    NSMutableDictionary *statement1Options = [[NSMutableDictionary alloc] init];
    [statement1Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement1Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement1Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement1 = [self createTestStatementWithOptions:statement1Options];
    [statementArray addStatement:statement1];
    
    NSMutableDictionary *statement2Options = [[NSMutableDictionary alloc] init];
    [statement2Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement2Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement2Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement2 = [self createTestStatementWithOptions:statement2Options];
    [statementArray addStatement:statement2];
    
    NSMutableDictionary *statement3Options = [[NSMutableDictionary alloc] init];
    [statement3Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement3Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement3Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement3 = [self createTestStatementWithOptions:statement3Options];
    [statementArray addStatement:statement3];
    
    NSMutableDictionary *statement4Options = [[NSMutableDictionary alloc] init];
    [statement4Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement4Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement4Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement4 = [self createTestStatementWithOptions:statement4Options];
    [statementArray addStatement:statement4];
    
    [tincan sendStatements:statementArray withCompletionBlock:^(){
        [[TestSemaphor sharedInstance] lift:@"saveStatements"];
    }withErrorBlock:^(TCError *error){
        
        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
        [[TestSemaphor sharedInstance] lift:@"saveStatements"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"saveStatement"];
}

- (void)testGetStatement
{
    
    STAssertNotNil(tincan, @"tincan is not nill");
    
    [tincan getStatementWithId:@"4d44e635-b8c5-4eed-9695-eb7cc95e7c1a" withOptions:nil
           withCompletionBlock:^(TCStatement *statement){
               NSLog(@"statement %@", statement);
               [[TestSemaphor sharedInstance] lift:@"getStatement"];
           }withErrorBlock:^(TCError *error){
               NSLog(@"ERROR: %@", error.localizedDescription);
               [[TestSemaphor sharedInstance] lift:@"getStatement"];
           }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"getStatement"];
}

- (void)testGetStatements
{
    
    STAssertNotNil(tincan, @"tincan is not nill");
    
    TCVerb *verb = [[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]];
    
    TCQueryOptions *queryOptions = [[TCQueryOptions alloc] initWithActor:[[TCAgent alloc] initWithName:nil withMbox:@"mailto:brian@tincanapi.com"] withVerb:verb withTarget:nil withInstructor:nil withRegistration:nil withContext:YES withSince:@"2013-03-07" withUntil:nil withLimit:[NSNumber numberWithInt:2] withAuthoritative:NO withSparse:NO withAscending:NO];
    
    [tincan getStatementsWithOptions:queryOptions withCompletionBlock:^(NSArray *statementArray){
        NSLog(@"statementArray %@", statementArray);
        NSLog(@"found %d statements", statementArray.count);
        STAssertNotNil(statementArray, @"statements were returned");
        [[TestSemaphor sharedInstance] lift:@"getStatements"];
    }withErrorBlock:^(TCError *error){
        STAssertNil(error, @"There was no error with the request");
        NSLog(@"ERROR: %@", error.localizedDescription);
        [[TestSemaphor sharedInstance] lift:@"getStatements"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"getStatements"];
}

- (TCStatement *)createTestStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Brian Rogers" withMbox:@"mailto:brian@tincanapi.com"];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"http://tincanapi.com/test"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb];
    
    return statementToSend;
}


- (void) testQueryOptions
{
    TCQueryOptions *options = [[TCQueryOptions alloc] initWithActor:[[TCAgent alloc] initWithName:@"Test User" withMbox:@"mailto:test@tincanapi.com"] withVerb:[[TCVerb alloc] initWithId:@"http://adlnet.gov/exapi/verbs/attempted" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"attempted"]] withTarget:nil withInstructor:nil withRegistration:nil withContext:YES withSince:nil withUntil:nil withLimit:[NSNumber numberWithInt:25] withAuthoritative:NO withSparse:NO withAscending:NO];
    NSLog(@"%@", [options querystring]);
}

- (void) testState
{
    
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Brian Rogers" withMbox:@"mailto:brian@tincanapi.com"];
    
    NSMutableDictionary *stateContents = [[NSMutableDictionary alloc] init];
    [stateContents setValue:@"page 1" forKey:@"bookmark"];
    
    NSString *stateId = [TCUtil GetUUID];
    
    // put some state
    [tincan setStateWithValue:stateContents withStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil withCompletionBlock:^{
        [[TestSemaphor sharedInstance] lift:@"saveState"];
    }withErrorBlock:^(NSError *error){
        [[TestSemaphor sharedInstance] lift:@"saveState"];
    }];
    [[TestSemaphor sharedInstance] waitForKey:@"saveState"];
    
    // get the state
    [tincan getStateWithStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil
            withCompletionBlock:^(NSDictionary *state){
                NSLog(@"state : %@", state);
                [[TestSemaphor sharedInstance] lift:@"getState"];
            }
                 withErrorBlock:^(TCError *error){
                     [[TestSemaphor sharedInstance] lift:@"getState"];
                 }];
    [[TestSemaphor sharedInstance] waitForKey:@"getState"];
    
    // delete the state
    [tincan deleteStateWithStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil
               withCompletionBlock:^(){
                   [[TestSemaphor sharedInstance] lift:@"deleteState"];
               }
                    withErrorBlock:^(TCError *error){
                        [[TestSemaphor sharedInstance] lift:@"deleteState"];
                    }];
    [[TestSemaphor sharedInstance] waitForKey:@"deleteState"];
}


@end
