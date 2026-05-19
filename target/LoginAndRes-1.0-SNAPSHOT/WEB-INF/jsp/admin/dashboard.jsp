<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台管理</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5f6fa; min-height: 100vh; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 { font-size: 24px; }
        .admin-info { display: flex; align-items: center; gap: 15px; }
        .admin-name { font-weight: 500; }
        .btn-logout {
            padding: 8px 20px; background: rgba(255,255,255,0.2);
            color: white; border: 1px solid white; border-radius: 5px;
            cursor: pointer; text-decoration: none; transition: background 0.3s;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.3); }
        .main-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card {
            background: white; border-radius: 10px; padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); text-align: center;
            cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.12); }
        .card-icon { font-size: 48px; margin-bottom: 15px; }
        .card-title { font-size: 20px; font-weight: 600; color: #333; margin-bottom: 10px; }
        .card-desc { font-size: 14px; color: #888; }
    </style>
</head>
<body>
    <div class="header">
        <h1>后台管理系统</h1>
        <div class="admin-info">
            <span class="admin-name">${sessionScope.admin.nickname}</span>
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="btn-logout">退出</a>
        </div>
    </div>
    <div class="main-container">
        <div class="cards">
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin?action=user'">
                <div class="card-icon">&#x1F465;</div>
                <div class="card-title">用户管理</div>
                <div class="card-desc">查看、编辑、删除用户信息</div>
            </div>
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin?action=message'">
                <div class="card-icon">&#x1F4AC;</div>
                <div class="card-title">留言管理</div>
                <div class="card-desc">查看、编辑、删除留言内容</div>
            </div>
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin?action=admin'">
                <div class="card-icon">&#x1F510;</div>
                <div class="card-title">管理员管理</div>
                <div class="card-desc">添加、删除管理员账号</div>
            </div>
        </div>
    </div>
</body>
</html>
