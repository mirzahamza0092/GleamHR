package com.glowlogix.gleamhr;

import android.content.Context;
import android.util.Log;

import com.onesignal.OSNotification;
import com.onesignal.OSNotificationReceivedEvent;
import com.onesignal.OneSignal;

public class NotificationService implements OneSignal.OSRemoteNotificationReceivedHandler {
    private static final String TAG="NotificationService";
    @Override
    public void remoteNotificationReceived(Context context, OSNotificationReceivedEvent osNotificationReceivedEvent) {
        OSNotification notification = osNotificationReceivedEvent.getNotification();
        osNotificationReceivedEvent.complete(notification);
        Log.e(TAG, "remoteNotificationReceived: "+notification.getTitle());
        Log.e(TAG, "remoteNotificationReceived: "+notification.getBody());
    }
}
