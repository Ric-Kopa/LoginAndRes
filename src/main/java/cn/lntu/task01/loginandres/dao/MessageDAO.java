package cn.lntu.task01.loginandres.dao;

import cn.lntu.task01.loginandres.entity.Message;
import cn.lntu.task01.loginandres.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    public boolean addMessage(Message message) {
        String sql = "INSERT INTO messages (user_id, content) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, message.getUserId());
            pstmt.setString(2, message.getContent());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getAllMessages() {
        String sql = "SELECT m.*, u.username, u.nickname, u.avatar FROM messages m " +
                     "LEFT JOIN users u ON m.user_id = u.id ORDER BY m.create_time DESC";
        List<Message> messages = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Message message = new Message();
                message.setId(rs.getInt("id"));
                message.setUserId(rs.getInt("user_id"));
                message.setContent(rs.getString("content"));
                message.setCreateTime(rs.getString("create_time"));
                message.setUsername(rs.getString("username"));
                message.setNickname(rs.getString("nickname"));
                message.setAvatar(rs.getString("avatar"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public boolean deleteMessage(int id, int userId) {
        String sql = "DELETE FROM messages WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteMessageById(int id) {
        String sql = "DELETE FROM messages WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Message getMessageById(int id) {
        String sql = "SELECT m.*, u.username, u.nickname, u.avatar FROM messages m " +
                     "LEFT JOIN users u ON m.user_id = u.id WHERE m.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Message message = new Message();
                message.setId(rs.getInt("id"));
                message.setUserId(rs.getInt("user_id"));
                message.setContent(rs.getString("content"));
                message.setCreateTime(rs.getString("create_time"));
                message.setUsername(rs.getString("username"));
                message.setNickname(rs.getString("nickname"));
                message.setAvatar(rs.getString("avatar"));
                return message;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateMessage(int id, String content) {
        String sql = "UPDATE messages SET content = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, content);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
