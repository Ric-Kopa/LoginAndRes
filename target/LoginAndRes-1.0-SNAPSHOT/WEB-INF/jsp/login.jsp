<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            width: 420px;
        }
        .login-container h2 { text-align: center; color: #333; margin-bottom: 30px; font-size: 28px; }
        .tab-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .tab-btn {
            flex: 1;
            padding: 12px;
            background: #f0f0f0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .tab-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .login-panel { display: none; }
        .login-panel.active { display: block; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .captcha-group { display: flex; gap: 10px; }
        .captcha-group input { flex: 1; }
        .captcha-group img {
            width: 120px; height: 40px; border-radius: 5px;
            cursor: pointer; border: 2px solid #e1e1e1;
        }
        .btn-code {
            padding: 10px 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            white-space: nowrap;
        }
        .btn-code:disabled { background: #ccc; cursor: not-allowed; }
        .btn-login {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 5px;
            font-size: 16px; font-weight: 600; cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .register-link { text-align: center; margin-top: 20px; color: #666; }
        .register-link a { color: #667eea; text-decoration: none; font-weight: 600; }
        .register-link a:hover { text-decoration: underline; }
        .error-msg { color: #e74c3c; text-align: center; margin-bottom: 15px; font-size: 14px; }
        .qr-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
            padding: 20px 0;
        }
        .qr-box {
            width: 200px; height: 200px;
            border: 2px dashed #ddd;
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 14px;
            color: #999;
            position: relative;
        }
        .qr-box.scanned { border-color: #4cd964; background: #f0fff0; }
        .qr-box.success { border-color: #667eea; background: #f0f0ff; }
        .qr-status { font-size: 14px; color: #666; text-align: center; }
        .qr-buttons { display: flex; gap: 10px; }
        .qr-btn {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }
        .admin-link {
            text-align: center;
            margin-top: 15px;
            font-size: 12px;
        }
        .admin-link a { color: #999; text-decoration: none; }
        .admin-link a:hover { color: #667eea; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>用户登录</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-msg"><%= request.getAttribute("error") %></p>
        <% } %>
        <div class="tab-buttons">
            <button class="tab-btn active" onclick="showPanel('password')">密码登录</button>
            <button class="tab-btn" onclick="showPanel('email')">邮箱登录</button>
            <button class="tab-btn" onclick="showPanel('qr')">扫码登录</button>
        </div>

        <div id="passwordPanel" class="login-panel active">
            <form action="<%=request.getContextPath()%>/login" method="post">
                <input type="hidden" name="loginType" value="password">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" required placeholder="请输入用户名">
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" id="password" name="password" required placeholder="请输入密码">
                </div>
                <div class="form-group captcha-group">
                    <input type="text" id="captcha" name="captcha" required placeholder="验证码" maxlength="4">
                    <img id="captchaImage" src="<%=request.getContextPath()%>/login?action=captcha" alt="验证码" onclick="refreshCaptcha()">
                </div>
                <button type="submit" class="btn-login">登 录</button>
            </form>
        </div>

        <div id="emailPanel" class="login-panel">
            <form action="<%=request.getContextPath()%>/login" method="post">
                <input type="hidden" name="loginType" value="email">
                <div class="form-group">
                    <label for="email">邮箱地址</label>
                    <input type="email" id="email" name="email" required placeholder="请输入注册时的邮箱">
                </div>
                <div class="form-group">
                    <label for="emailCode">验证码</label>
                    <div class="captcha-group">
                        <input type="text" id="emailCode" name="emailCode" required placeholder="输入6位验证码" maxlength="6">
                        <button type="button" id="sendCodeBtn" class="btn-code" onclick="sendEmailCode()">发送验证码</button>
                    </div>
                </div>
                <button type="submit" class="btn-login">邮箱登录</button>
            </form>
        </div>

        <div id="qrPanel" class="login-panel">
            <div class="qr-container">
                <div class="qr-box" id="qrBox">
                    <span id="qrText">点击下方按钮生成二维码</span>
                </div>
                <div class="qr-buttons">
                    <button class="qr-btn" onclick="generateQR('wechat')">微信扫码</button>
                    <button class="qr-btn" onclick="generateQR('qq')">QQ扫码</button>
                </div>
                <div class="qr-status" id="qrStatus"></div>
            </div>
        </div>

        <p class="register-link">还没有账号？<a href="<%=request.getContextPath()%>/register">立即注册</a></p>
        <p class="admin-link"><a href="<%=request.getContextPath()%>/admin-login">管理员登录</a></p>
    </div>

    <script>
        function showPanel(panel) {
            document.querySelectorAll('.login-panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(panel + 'Panel').classList.add('active');
            event.target.classList.add('active');
        }

        function refreshCaptcha() {
            document.getElementById('captchaImage').src = '<%=request.getContextPath()%>/login?action=captcha&t=' + new Date().getTime();
        }

        function sendEmailCode() {
            var email = document.getElementById('email').value;
            if (!email) {
                alert('请先输入邮箱地址');
                return;
            }
            var btn = document.getElementById('sendCodeBtn');
            btn.disabled = true;
            var seconds = 60;
            btn.textContent = seconds + '秒后重发';
            var timer = setInterval(function() {
                seconds--;
                if (seconds <= 0) {
                    clearInterval(timer);
                    btn.disabled = false;
                    btn.textContent = '发送验证码';
                } else {
                    btn.textContent = seconds + '秒后重发';
                }
            }, 1000);

            fetch('<%=request.getContextPath()%>/login?action=sendEmailCode&email=' + encodeURIComponent(email))
                .then(r => r.json())
                .then(d => {
                    if (d.success) {
                        alert('验证码已发送（演示模式显示：' + d.code + '）');
                    } else {
                        alert('发送失败，请检查邮箱地址');
                        clearInterval(timer);
                        btn.disabled = false;
                        btn.textContent = '发送验证码';
                    }
                });
        }

        function generateQR(type) {
            fetch('<%=request.getContextPath()%>/login?action=getQRCode&type=' + type)
                .then(r => r.json())
                .then(d => {
                    var qrBox = document.getElementById('qrBox');
                    var qrText = document.getElementById('qrText');
                    qrBox.className = 'qr-box';
                    qrText.textContent = type === 'wechat' ? '微信扫码登录\n(模拟)' : 'QQ扫码登录\n(模拟)';
                    qrBox.innerHTML = '<div style="text-align:center;"><div style="font-size:48px;">' +
                        (type === 'wechat' ? '&#x1F1E7;&#x1F1FA;' : '&#x1F1E6;&#x1F1F9;') +
                        '</div><div style="margin-top:10px;font-size:12px;color:#666;">' +
                        (type === 'wechat' ? '微信' : 'QQ') + '扫码登录（演示模式）</div></div>';
                    document.getElementById('qrStatus').textContent = '请使用' + (type === 'wechat' ? '微信' : 'QQ') + '扫码';
                    checkQRLogin();
                });
        }

        function checkQRLogin() {
            fetch('<%=request.getContextPath()%>/login?action=checkQRLogin')
                .then(r => r.json())
                .then(d => {
                    if (d.success) {
                        window.location.href = '<%=request.getContextPath()%>/main';
                    } else {
                        setTimeout(checkQRLogin, 2000);
                    }
                });
        }
    </script>
</body>
</html>
