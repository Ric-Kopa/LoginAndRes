package cn.lntu.task01.loginandres.servlet;

import cn.lntu.task01.loginandres.dao.UserDAO;
import cn.lntu.task01.loginandres.entity.User;
import cn.lntu.task01.loginandres.util.CaptchaUtil;
import cn.lntu.task01.loginandres.util.EmailUtil;
import cn.lntu.task01.loginandres.util.MD5Util;
import cn.lntu.task01.loginandres.util.QRCodeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final Map<String, Long> emailCodes = new ConcurrentHashMap<>();
    private static final Map<String, String> qrCodes = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("captcha".equals(action)) {
            String code = CaptchaUtil.generateCode();
            session.setAttribute("captcha", code);
            String image = CaptchaUtil.generateImage(code);
            String base64Image = image.substring("data:image/png;base64,".length());
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);
            response.setContentType("image/png");
            response.setContentLength(imageBytes.length);
            response.getOutputStream().write(imageBytes);
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } else if ("sendEmailCode".equals(action)) {
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "邮箱不能为空");
                return;
            }
            String code = EmailUtil.generateCode();
            emailCodes.put(email, System.currentTimeMillis());
            session.setAttribute("emailCode", code);
            session.setAttribute("emailCodeTime", System.currentTimeMillis());
            boolean sent = EmailUtil.sendVerificationCode(email, code);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":" + sent + ",\"code\":\"" + (sent ? code : "发送失败") + "\"}");
        } else if ("getQRCode".equals(action)) {
            String type = request.getParameter("type");
            String state = QRCodeUtil.generateState();
            qrCodes.put(state, type);
            session.setAttribute("qrState", state);
            session.setAttribute("qrType", type);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"state\":\"" + state + "\"}");
        } else if ("checkQRLogin".equals(action)) {
            String state = (String) session.getAttribute("qrState");
            String type = (String) session.getAttribute("qrType");
            if (state != null && qrCodes.containsKey(state)) {
                qrCodes.remove(state);
                session.removeAttribute("qrState");
                session.removeAttribute("qrType");
                User mockUser = new User();
                mockUser.setId(999);
                mockUser.setUsername(type + "_user");
                mockUser.setNickname(type.equals("wechat") ? "微信用户" : "QQ用户");
                mockUser.setAvatar("");
                session.setAttribute("user", mockUser);
                session.setAttribute("isThirdPartyLogin", true);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":true}");
            } else {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":false}");
            }
        } else if ("mockQRScan".equals(action)) {
            String state = (String) session.getAttribute("qrState");
            if (state != null) {
                qrCodes.put(state + "_scanned", "scanned");
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":true}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的二维码");
            }
        } else {
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String loginType = request.getParameter("loginType");
        HttpSession session = request.getSession();

        if ("email".equals(loginType)) {
            handleEmailLogin(request, response, session);
        } else {
            handlePasswordLogin(request, response, session);
        }
    }

    private void handlePasswordLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String captcha = request.getParameter("captcha");

        String sessionCaptcha = (String) session.getAttribute("captcha");
        if (sessionCaptcha == null || !sessionCaptcha.equalsIgnoreCase(captcha)) {
            request.setAttribute("error", "验证码错误");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        String encryptedPassword = MD5Util.encrypt(password);
        User user = userDAO.login(username, encryptedPassword);

        if (user != null) {
            session.setAttribute("user", user);
            session.removeAttribute("captcha");
            response.sendRedirect(request.getContextPath() + "/main");
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }

    private void handleEmailLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String code = request.getParameter("emailCode");

        String sessionCode = (String) session.getAttribute("emailCode");
        Long codeTime = (Long) session.getAttribute("emailCodeTime");

        if (sessionCode == null || codeTime == null) {
            request.setAttribute("error", "请先获取验证码");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() - codeTime > 5 * 60 * 1000) {
            request.setAttribute("error", "验证码已过期，请重新获取");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        if (!sessionCode.equals(code)) {
            request.setAttribute("error", "验证码错误");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        session.removeAttribute("emailCode");
        session.removeAttribute("emailCodeTime");
        session.setAttribute("user", new User("0", "", email, "", "", ""));
        response.sendRedirect(request.getContextPath() + "/main");
    }
}