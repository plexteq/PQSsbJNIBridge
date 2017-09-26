

#import "com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks.h"

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    createBookmark
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_createBookmarkImpl
(JNIEnv *env, jclass class, jstring location)
{
    const char *nativeLocation = (*env)->GetStringUTFChars(env, location, 0);
    
    NSString *nsLocation = [NSString stringWithCString:nativeLocation encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file:///%@", nsLocation]];
    
    NSError* error;
    NSData* bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                               includingResourceValuesForKeys:nil
                                                relativeToURL:nil
                                                        error:&error];
    
    (*env)->ReleaseStringUTFChars(env, location, nativeLocation);
    
    // Returning base64 bookmark representation to the caller
    const char* stringifiedBookmark = [[bookmark base64EncodedStringWithOptions:0]
                                       cStringUsingEncoding:NSUTF8StringEncoding];
    
    return (*env)->NewStringUTF(env, stringifiedBookmark);
}

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    startResourceAccessing
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_startResourceAccessingImpl
(JNIEnv *env, jclass class, jstring bookmark)
{
    BOOL isStale;
    NSError* error;
    
    const char *nativeBookmark = (*env)->GetStringUTFChars(env, bookmark, 0);
    NSString *nsBookmark = [NSString stringWithCString:nativeBookmark encoding:NSUTF8StringEncoding];
    NSData *rawBookmark = [[NSData alloc] initWithBase64EncodedString:nsBookmark options:0];
    
    NSURL* accessResource = [NSURL URLByResolvingBookmarkData:rawBookmark
                                                  options:NSURLBookmarkResolutionWithSecurityScope
                                            relativeToURL:nil
                                      bookmarkDataIsStale:&isStale
                                                    error:&error];
    
    //TODO: handle bool of startAccessingSecurityScopedResource
    // and return that to the calling side
    [accessResource startAccessingSecurityScopedResource];
    
    (*env)->ReleaseStringUTFChars(env, bookmark, nativeBookmark);
    
    const char* securityScopedUrl = [[accessResource absoluteString] cStringUsingEncoding:NSUTF8StringEncoding];
    return (*env)->NewStringUTF(env, securityScopedUrl);
}

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    stopResourceAccessing
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_stopResourceAccessingImpl
(JNIEnv *env, jclass class, jstring bookmark)
{
    BOOL isStale;
    NSError* error;
    
    const char *nativeBookmark = (*env)->GetStringUTFChars(env, bookmark, 0);
    NSString *nsBookmark = [NSString stringWithCString:nativeBookmark encoding:NSUTF8StringEncoding];
    NSData *rawBookmark = [[NSData alloc] initWithBase64EncodedString:nsBookmark options:0];
    
    NSURL* accessResource = [NSURL URLByResolvingBookmarkData:rawBookmark
                                                      options:NSURLBookmarkResolutionWithSecurityScope
                                                relativeToURL:nil
                                          bookmarkDataIsStale:&isStale
                                                        error:&error];
    [accessResource stopAccessingSecurityScopedResource];
    
    (*env)->ReleaseStringUTFChars(env, bookmark, nativeBookmark);
}
