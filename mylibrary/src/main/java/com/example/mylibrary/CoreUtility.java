package com.example.mylibrary;

import android.content.Context;
import android.content.pm.PackageManager;

public class CoreUtility {

    public static class Version {
        /**
         * Get current version code
         *
         * @param context required context
         * @return version number
         */
        public static String getVersion(Context context) {
            String versionNo = null;
            if(context == null){
                return versionNo;
            }
            try {
                versionNo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionName;
            } catch (PackageManager.NameNotFoundException e) {
                System.out.println("Version Name Not Found");
            }
            return versionNo;
        }

        public static String getAppType() { return "P"; }
    }

}
