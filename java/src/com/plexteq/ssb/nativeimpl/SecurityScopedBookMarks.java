package com.plexteq.ssb.nativeimpl;

public class SecurityScopedBookmarks
{
        public static native String createBookmarkImpl(String location);
        public static native void removeBookmarkImpl(String location);
        public static native String startResourceAccessingImpl(String bookmark);
        public static native void stopResourceAccessingImpl(String bookmark);
}
