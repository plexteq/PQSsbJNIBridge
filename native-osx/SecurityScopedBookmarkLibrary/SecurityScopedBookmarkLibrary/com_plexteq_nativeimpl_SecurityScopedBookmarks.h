#import <Foundation/Foundation.h>
#import <jni.h>

#ifndef _Included_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
#define _Included_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
#ifdef __cplusplus
extern "C" {
#endif
    
    /*
     * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
     * Method:    createBookmark
     * Signature: (Ljava/lang/String;)V
     */
    JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_createBookmarkImpl
    (JNIEnv *, jclass, jstring);
        
    /*
     * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
     * Method:    startResourceAccessing
     * Signature: (Ljava/lang/String;)V
     */
    JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_startResourceAccessingImpl
    (JNIEnv *, jclass, jstring);
    
    /*
     * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
     * Method:    stopResourceAccessing
     * Signature: (Ljava/lang/String;)V
     */
    JNIEXPORT void JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_stopResourceAccessingImpl
    (JNIEnv *, jclass, jstring);
    
#ifdef __cplusplus
}
#endif
#endif
