package cn.lntu.task01.loginandres.servlet;

import cn.lntu.task01.loginandres.dao.MessageDAO;
import cn.lntu.task01.loginandres.entity.Message;
import cn.lntu.task01.loginandres.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "mainServlet", value = "/main")
public class MainServlet extends HttpServlet {
    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                messageDAO.deleteMessage(id, user.getId());
            }
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        List<Message> messages = messageDAO.getAllMessages();
        request.setAttribute("messages", messages);
        request.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String content = request.getParameter("content");
        if (content != null && !content.trim().isEmpty()) {
            Message message = new Message(user.getId(), content);
            messageDAO.addMessage(message);
        }
        response.sendRedirect(request.getContextPath() + "/main");
    }
}