package cn.lntu.task01.loginandres.servlet;

import cn.lntu.task01.loginandres.dao.AdminDAO;
import cn.lntu.task01.loginandres.dao.MessageDAO;
import cn.lntu.task01.loginandres.dao.UserDAO;
import cn.lntu.task01.loginandres.entity.Admin;
import cn.lntu.task01.loginandres.entity.Message;
import cn.lntu.task01.loginandres.entity.User;
import cn.lntu.task01.loginandres.util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "adminServlet", value = "/admin")
public class AdminServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        if ("user".equals(action)) {
            List<User> users = getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/userManage.jsp").forward(request, response);
        } else if ("message".equals(action)) {
            List<Message> messages = messageDAO.getAllMessages();
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/messageManage.jsp").forward(request, response);
        } else if ("admin".equals(action)) {
            List<Admin> admins = adminDAO.getAllAdmins();
            request.setAttribute("admins", admins);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/adminManage.jsp").forward(request, response);
        } else if ("deleteUser".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                deleteUser(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=user");
        } else if ("deleteMessage".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                messageDAO.deleteMessageById(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=message");
        } else if ("editUser".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User user = userDAO.getUserById(id);
                request.setAttribute("editUser", user);
            }
            List<User> users = getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/userManage.jsp").forward(request, response);
        } else if ("editMessage".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Message message = messageDAO.getMessageById(id);
                request.setAttribute("editMessage", message);
            }
            List<Message> messages = messageDAO.getAllMessages();
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/messageManage.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateUser".equals(action)) {
            String idStr = request.getParameter("id");
            String nickname = request.getParameter("nickname");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            if (idStr != null && nickname != null) {
                int id = Integer.parseInt(idStr);
                updateUser(id, nickname, phone, email);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=user");
        } else if ("updateMessage".equals(action)) {
            String idStr = request.getParameter("id");
            String content = request.getParameter("content");
            if (idStr != null && content != null) {
                int id = Integer.parseInt(idStr);
                updateMessage(id, content);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=message");
        } else if ("addAdmin".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nickname = request.getParameter("nickname");
            if (username != null && password != null && nickname != null) {
                Admin newAdmin = new Admin(username, password, nickname);
                adminDAO.addAdmin(newAdmin);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=admin");
        } else if ("deleteAdmin".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                adminDAO.deleteAdmin(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin?action=admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    private List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    private void deleteUser(int id) {
        userDAO.deleteUser(id);
    }

    private void updateUser(int id, String nickname, String phone, String email) {
        userDAO.updateUser(id, nickname, phone, email);
    }

    private void updateMessage(int id, String content) {
        messageDAO.updateMessage(id, content);
    }
}
