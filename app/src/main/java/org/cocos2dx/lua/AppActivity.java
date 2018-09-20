/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.app.Activity;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.widget.Toast;

import com.joy.numerouschain.R;

public class AppActivity extends Cocos2dxActivity{
    public static final String TAG = "Cocos2dxActivity";
    private static AppActivity mContext;
    private static double NavigationBarHeight = 0.0d;
    private long mLastBackTime = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

		mContext = this;
        if (hasNavigationBar(mContext)) {
            NavigationBarHeight = getNavigationBarHeight(mContext);
        }
	}

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mContext = null;
        System.exit(0);
    }

    public static boolean hasNavigationBar(Activity activity) {
        Resources rs = activity.getResources();
        int id = rs.getIdentifier("config_showNavigationBar", "bool", "android");
        boolean hasNavBarFun = false;
        if (id > 0) {
            hasNavBarFun = rs.getBoolean(id);
        }
        try {
            Class systemPropertiesClass = Class.forName("android.os.SystemProperties");
            String navBarOverride = (String) systemPropertiesClass.getMethod("get",
                    new Class[]{String.class}).invoke(systemPropertiesClass, new Object[]{"qemu.hw.mainkeys"});
            if ("1".equals(navBarOverride)) {
                hasNavBarFun = false;
            } else if ("0".equals(navBarOverride)) {
                hasNavBarFun = true;
            }
        } catch (Exception e) {
            hasNavBarFun = false;
        }
        Log.i(TAG, "hasNavigationBar: " + hasNavBarFun);
        return hasNavBarFun;
    }

    public static double getNavigationBarHeight(Activity activity) {
        DisplayMetrics dm = new DisplayMetrics();
        Display display = activity.getWindowManager().getDefaultDisplay();
        display.getMetrics(dm);
        int screenWidth = dm.widthPixels;
        int screenHeight = dm.heightPixels;
        float density = dm.density;
        Log.i(TAG, "getNavigationBarHeight, screenWidth screenHeight：" + screenWidth + "|" + screenHeight + "|" + density + "|" + dm.densityDpi);
        DisplayMetrics realDisplayMetrics = new DisplayMetrics();
        if (Build.VERSION.SDK_INT >= 17) {
            display.getRealMetrics(realDisplayMetrics);
        } else {
            try {
                Class.forName("android.view.Display").getMethod("getRealMetrics",
                        new Class[]{DisplayMetrics.class}).invoke(display, new Object[]{realDisplayMetrics});
            } catch (Exception e) {
                realDisplayMetrics.setToDefaults();
                e.printStackTrace();
            }
        }
        int screenRealWidth = realDisplayMetrics.widthPixels;
        Log.i(TAG, "getNavigationBarHeight: screenRealWidth screenRealHeight:" + screenRealWidth + "|" + realDisplayMetrics.heightPixels);
        return (double) (((float) ((screenRealWidth - screenWidth) * 2)) / density);
    }

	public static void getNarBarHeight(String content, final int luaFunc) {
        Log.i(TAG, "getNarBarHeight: param content:" + content);
        Log.i(TAG, "getNarBarHeight: param luaFunc:" + luaFunc);
        mContext.runOnGLThread(new Runnable() {
            public void run() {
                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, String.valueOf(AppActivity.NavigationBarHeight));
                Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
            }
        });
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
            if (event.getAction() == KeyEvent.ACTION_DOWN &&
                    event.getRepeatCount() == 0) {
                long uptimeMillis = SystemClock.uptimeMillis();
                if (uptimeMillis - mLastBackTime > 2000) {
                    mLastBackTime = uptimeMillis;
                    showToast(getString(R.string.tip_double_tap_to_exit));
                    return true;
                } else {
                    finish();
                }
            }
        }
        return super.dispatchKeyEvent(event);
    }

    private void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }
}
