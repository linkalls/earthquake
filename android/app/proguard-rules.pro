# Keep all classes that might be used in XML layouts.
-keep public class * extends android.view.View {
   *** get*();
   void set*(***);
   public <init>(android.content.Context, android.util.AttributeSet);
   public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Keep all classes that are referenced in your manifest.
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService

# Keep all classes that are referenced by native methods.
-keepclasseswithmembernames class * {
   native <methods>;
}

# Keep all classes that are referenced by reflection.
-keepclasseswithmembers class * {
   public <init>(android.content.Context, android.util.AttributeSet);
}

# Keep all classes that extend Context.
-keep public class * extends android.content.Context

# Keep all classes that are referenced by your app.
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService

# Keep all classes that are referenced by your app.
-keep public class * extends android.support.v4.app.Fragment
-keep public class * extends android.support.v4.app.DialogFragment
-keep public class * extends android.app.Fragment
-keep public class * extends android.app.DialogFragment
-keep public class * extends android.support.v4.app.FragmentActivity
-keep public class * extends android.support.v4.app.ListFragment
-keep public class * extends android.support.v4.app.LoaderManager
-keep public class * extends android.support.v4.app.NavUtils
-keep public class * extends android.support.v4.app.TaskStackBuilder
-keep public class * extends android.support.v4.app.FragmentPagerAdapter
-keep public class * extends android.support.v4.app.FragmentStatePagerAdapter
-keep public class * extends android.support.v4.app.FragmentTabHost
-keep public class * extends android.support.v4.app.FragmentTransaction
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$Delegate
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$DelegateProvider
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$SlidingPaneLayoutImpl
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$SlidingPaneLayoutImplBase
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegate
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateBase
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImpl
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$1
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$2
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$3
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$4
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$5
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$6
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$7
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$8
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$9
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$10
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$11
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$12
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$13
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$14
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$15
-keep public class * extends android.support.v4.app.ActionBarDrawerToggle$ToolbarCompatDelegateImplBase$16