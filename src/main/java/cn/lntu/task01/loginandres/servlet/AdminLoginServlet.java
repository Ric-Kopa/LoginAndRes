package cn.lntu.task01.loginandres.servlet;

import cn.lntu.task01.loginandres.dao.AdminDAO;
import cn.lntu.task01.loginandres.entity.Admin;
import cn.lntu.task01.loginandres.util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "adminLoginServlet", value = "/admin-login")
public class AdminLoginServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/admin/adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 调试信息
        System.out.println("=== 管理员登录调试 ===");
        System.out.println("用户名: " + username);
        System.out.println("密码: " + password);
        System.out.println("加密后的密码: " + MD5Util.encrypt(password));
        System.out.println("预期密码(admin123的MD5): e10adc3949ba59abbe56e057f20f883e");

        Admin admin = adminDAO.login(username, password);
        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/WEB-INF/jsp/admin/adminLogin.jsp").forward(request, response);
        }
    }
}