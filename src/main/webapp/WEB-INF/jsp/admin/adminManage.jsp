<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员管理</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5f6fa; min-height: 100vh; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header h1 { font-size: 24px; }
        .admin-info { display: flex; align-items: center; gap: 15px; }
        .btn-back, .btn-logout {
            padding: 8px 20px; background: rgba(255,255,255,0.2);
            color: white; border: 1px solid white; border-radius: 5px;
            cursor: pointer; text-decoration: none; transition: background 0.3s;
        }
        .btn-logout:hover, .btn-back:hover { background: rgba(255,255,255,0.3); }
        .main-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .top-bar h2 { color: #333; }
        .btn-add { padding: 10px 20px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .table-container { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px 20px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; color: #333; }
        tr:hover { background: #f8f9fa; }
        .btn-delete { padding: 5px 15px; background: #ff6b6b; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 12px; }
        .modal {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 1000;
        }
        .modal.show { display: flex; }
        .modal-content { background: white; padding: 30px; border-radius: 10px; width: 400px; }
        .modal-content h3 { margin-bottom: 20px; color: #333; }
        .modal-content .form-group { margin-bottom: 15px; }
        .modal-content label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        .modal-content input {
            width: 100%; padding: 10px; border: 2px solid #e1e1e1; border-radius: 5px;
        }
        .modal-buttons { display: flex; gap: 10px; margin-top: 20px; }
        .modal-buttons button {
            flex: 1; padding: 10px; border-radius: 5px; cursor: pointer; border: none; font-size: 14px;
        }
        .btn-save { background: #667eea; color: white; }
        .btn-cancel { background: #ccc; color: #333; }
    </style>
</head>
<body>
    <div class="header">
        <h1>管理员管理</h1>
        <div class="admin-info">
            <a href="${pageContext.request.contextPath}/admin" class="btn-back">返回主页</a>
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="btn-logout">退出</a>
        </div>
    </div>
    <div class="main-container">
        <div class="top-bar">
            <h2>管理员列表</h2>
            <button class="btn-add" onclick="showAddModal()">添加管理员</button>
        </div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>昵称</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="admin" items="${admins}">
                        <tr>
                            <td>${admin.id}</td>
                            <td>${admin.username}</td>
                            <td>${admin.nickname}</td>
                            <td>${admin.createTime}</td>
                            <td>
                                <button class="btn-delete" onclick="deleteAdmin('${admin.id}')">删除</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal" id="addModal">
        <div class="modal-content">
            <h3>添加管理员</h3>
            <form action="${pageContext.request.contextPath}/admin" method="post">
                <input type="hidden" name="action" value="addAdmin">
                <div class="form-group">
                    <label>用户名</label>
                    <input type="text" name="username" required placeholder="请输入用户名">
                </div>
                <div class="form-group">
                    <label>密码</label>
                    <input type="password" name="password" required placeholder="请输入密码">
                </div>
                <div class="form-group">
                    <label>昵称</label>
                    <input type="text" name="nickname" required placeholder="请输入昵称">
                </div>
                <div class="modal-buttons">
                    <button type="submit" class="btn-save">添加</button>
                    <button type="button" class="btn-cancel" onclick="closeModal()">取消</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('addModal').classList.add('show');
        }
        function closeModal() {
            document.getElementById('addModal').classList.remove('show');
        }
        function deleteAdmin(id) {
            if (confirm('确定删除该管理员？')) {
                location.href = '${pageContext.request.contextPath}/admin?action=deleteAdmin&id=' + id;
            }
        }
    </script>
</body>
</html>
