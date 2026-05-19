<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>留言板</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            font-size: 24px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid white;
            object-fit: cover;
        }
        .user-name {
            font-weight: 500;
        }
        .btn-logout {
            padding: 8px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid white;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }
        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .main-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .message-form {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }
        .message-form textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e1e1;
            border-radius: 8px;
            resize: none;
            font-size: 14px;
            font-family: inherit;
            min-height: 100px;
            transition: border-color 0.3s;
        }
        .message-form textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        .message-form button {
            margin-top: 15px;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .message-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .message-list {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        .message-item {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            gap: 15px;
        }
        .message-item:last-child {
            border-bottom: none;
        }
        .message-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            flex-shrink: 0;
        }
        .message-content {
            flex: 1;
        }
        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .message-nickname {
            font-weight: 600;
            color: #333;
        }
        .message-time {
            font-size: 12px;
            color: #999;
        }
        .message-text {
            color: #555;
            line-height: 1.6;
            word-wrap: break-word;
        }
        .message-actions {
            margin-top: 10px;
            text-align: right;
        }
        .btn-delete {
            padding: 5px 15px;
            background: #ff6b6b;
            color: white;
            border: none;
            border-radius: 3px;
            font-size: 12px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-delete:hover {
            background: #ee5a5a;
        }
        .empty-msg {
            text-align: center;
            padding: 50px;
            color: #999;
            font-size: 16px;
        }
        .default-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 20px;
            font-weight: bold;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>留言板</h1>
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" class="user-avatar" alt="头像">
                </c:when>
                <c:otherwise>
                    <div class="default-avatar">${sessionScope.user.nickname.charAt(0)}</div>
                </c:otherwise>
            </c:choose>
            <span class="user-name">${sessionScope.user.nickname}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出</a>
        </div>
    </div>

    <div class="main-container">
        <div class="message-form">
            <form action="${pageContext.request.contextPath}/main" method="post">
                <textarea name="content" placeholder="说点什么吧..." required></textarea>
                <button type="submit">发布留言</button>
            </form>
        </div>

        <div class="message-list">
            <c:choose>
                <c:when test="${not empty messages}">
                    <c:forEach var="msg" items="${messages}">
                        <div class="message-item">
                            <c:choose>
                                <c:when test="${not empty msg.avatar}">
                                    <img src="${pageContext.request.contextPath}/${msg.avatar}" class="message-avatar" alt="头像">
                                </c:when>
                                <c:otherwise>
                                    <div class="default-avatar">${msg.nickname.charAt(0)}</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="message-content">
                                <div class="message-header">
                                    <span class="message-nickname">${msg.nickname}</span>
                                    <span class="message-time">${msg.createTime}</span>
                                </div>
                                <p class="message-text">${msg.content}</p>
                                <c:if test="${sessionScope.user.id == msg.userId}">
                                    <div class="message-actions">
                                        <a href="${pageContext.request.contextPath}/main?action=delete&id=${msg.id}" class="btn-delete" onclick="return confirm('确定删除这条留言？')">删除</a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-msg">暂无留言，快来发表第一条留言吧！</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
