package cn.lntu.task01.loginandres.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {
    private static final String SMTP_HOST = "smtp.qq.com";
    private static final String SMTP_PORT = "587";
    private static final String FROM_EMAIL = "your_email@qq.com";
    private static final String AUTH_CODE = "your_auth_code";

    private static final Properties props = new Properties();

    static {
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
    }

    public static String generateCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }

    public static boolean sendVerificationCode(String toEmail, String code) {
        try {
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, AUTH_CODE);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("登录验证码");
            message.setText("您的登录验证码是：" + code + "，5分钟内有效。");

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
