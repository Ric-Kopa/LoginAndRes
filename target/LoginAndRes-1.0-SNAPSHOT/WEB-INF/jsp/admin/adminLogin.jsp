<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            width: 400px;
        }
        .login-container h2 { text-align: center; color: #333; margin-bottom: 30px; font-size: 28px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        .form-group input {
            width: 100%; padding: 12px 15px;
            border: 2px solid #e1e1e1; border-radius: 5px;
            font-size: 14px; transition: border-color 0.3s;
        }
        .form-group input:focus { outline: none; border-color: #11998e; }
        .btn-login {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white; border: none; border-radius: 5px;
            font-size: 16px; font-weight: 600; cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.4);
        }
        .back-link { text-align: center; margin-top: 20px; color: #666; }
        .back-link a { color: #11998e; text-decoration: none; font-weight: 600; }
        .error-msg { color: #e74c3c; text-align: center; margin-bottom: 15px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>管理员登录</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-msg"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="<%=request.getContextPath()%>/admin-login" method="post">
            <div class="form-group">
                <label for="username">管理员账号</label>
                <input type="text" id="username" name="username" required placeholder="请输入管理员账号">
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required placeholder="请输入密码">
            </div>
            <button type="submit" class="btn-login">登 录</button>
        </form>
        <p class="back-link"><a href="<%=request.getContextPath()%>/login">返回用户登录</a></p>
    </div>
</body>
</html>
