package cn.lntu.task01.loginandres.util;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class QRCodeUtil {
    private static final Map<String, String> pendingLogins = new HashMap<>();

    public static String generateState() {
        return UUID.randomUUID().toString();
    }

    public static String getWeChatLoginUrl(String state) {
        pendingLogins.put(state, "wechat");
        return "https://open.weixin.qq.com/connect/qrconnect?appid=YOUR_APPID&redirect_uri=YOUR_REDIRECT_URI&response_type=code&scope=snsapi_login&state=" + state;
    }

    public static String getQQLoginUrl(String state) {
        pendingLogins.put(state, "qq");
        return "https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&state=" + state;
    }

    public static String generateMockQRCode() {
        String uuid = UUID.randomUUID().toString();
        pendingLogins.put(uuid, "mock");
        return uuid;
    }

    public static boolean isPendingLogin(String state) {
        return pendingLogins.containsKey(state);
    }

    public static String getLoginType(String state) {
        return pendingLogins.remove(state);
    }
}
