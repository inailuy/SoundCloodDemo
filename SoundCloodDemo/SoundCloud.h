//
//  SoundCloud.h
//  Stofkat.org
//
// First basic version of my custom SoundCloud library
// The one from SoundCloud has 5 dependancy projects just
// for some very basic funtionality. This project only uses
// JSONKit as an aditional library and should be much easier
// to implement in your own projects
// if you have any questions you can mail me at stofkat@gmail.com
//  Created by Stofkat on 08-05-14.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundCloud : NSObject

//Change these to your own apps values
#define CLIENT_ID @"7bc951b0417a018ebcbdb97e40e7e886"
#define CLIENT_SECRET @"cf2630dfddfd203251a95707a5629e89"
#define REDIRECT_URI @"demo://oauth"//don't forget to change this in Info.plist as well

#define SC_API_URL @"https://api.soundcloud.com"
#define SC_TOKEN @"SC_TOKEN"
#define SC_CODE @"SC_CODE"

#define TRACKS_LOADED_NOTIFIACTION @"loaded_liked_track_array_notification"

@property (strong, nonatomic)  NSMutableArray *scTrackResultList;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;

@property (nonatomic, strong) NSMutableArray *tracksFavorited;


-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query;
-(NSData *) downloadTrackData :(NSString *)songURL;
-(NSMutableArray *) getUserTracks;
-(NSMutableArray *) getUserFavorites;
-(void) loadLikedTrackArray;
-(BOOL) login;

-(void) favoriteTrack:(NSNumber *)idValue;
-(void) deleteTrack:(NSNumber *)idValue;

@end
