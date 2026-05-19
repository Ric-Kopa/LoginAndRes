package cn.lntu.task01.loginandres.servlet;

import cn.lntu.task01.loginandres.dao.UserDAO;
import cn.lntu.task01.loginandres.entity.User;
import cn.lntu.task01.loginandres.util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "registerServlet", value = "/register")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        Part avatarPart = request.getPart("avatar");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            nickname == null || nickname.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "所有字段都不能为空");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String phoneRegex = "^1[3-9]\\d{9}$";
        if (!phone.matches(phoneRegex)) {
            request.setAttribute("error", "请输入正确的手机号码");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        if (!email.matches(emailRegex)) {
            request.setAttribute("error", "请输入正确的邮箱地址");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        if (avatarPart == null || avatarPart.getInputStream().available() == 0) {
            request.setAttribute("error", "请上传头像图片");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String contentType = avatarPart.getContentType();
        if (!contentType.startsWith("image/")) {
            request.setAttribute("error", "只能上传图片文件");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String avatarPath = saveAvatar(avatarPart);
        if (avatarPath == null) {
            request.setAttribute("error", "头像上传失败");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String encryptedPassword = MD5Util.encrypt(password);
        User user = new User(username, encryptedPassword, nickname, phone, email, avatarPath);

        if (userDAO.register(user)) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "注册失败，请重试");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
        }
    }

    private String saveAvatar(Part part) {
        String fileName = UUID.randomUUID().toString() + getFileExtension(part);
        String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        try {
            part.write(uploadPath + File.separator + fileName);
            return UPLOAD_DIR + "/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                int dotIndex = fileName.lastIndexOf(".");
                if (dotIndex > 0) {
                    return fileName.substring(dotIndex);
                }
            }
        }
        return ".jpg";
    }
}
