# LoginAndRes - 登录注册系统

一个基于 Java Servlet + JSP 的用户登录注册系统，支持多种登录方式和后台管理功能。

## 功能特性

### 登录功能
- ✅ **密码登录**：用户名 + 密码 + 图形验证码
- ✅ **邮箱验证码登录**：输入邮箱获取验证码登录
- ✅ **微信扫码登录**：模拟微信扫码登录（演示模式）
- ✅ **QQ扫码登录**：模拟QQ扫码登录（演示模式）

### 用户管理
- ✅ 用户注册（支持头像上传、电话号码、邮箱）
- ✅ 密码MD5加密存储
- ✅ 用户信息管理（编辑、删除）

### 留言板功能
- ✅ 发布留言
- ✅ 查看留言列表
- ✅ 删除个人留言

### 后台管理系统
- ✅ 用户管理：查看、编辑、删除用户
- ✅ 留言管理：查看、编辑、删除留言
- ✅ 管理员管理：添加、删除管理员

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 25 | 编程语言 |
| Servlet | 5.0 | Web框架 |
| JSP | 3.1 | 视图层 |
| JSTL | 2.0 | JSP标签库 |
| MySQL | 8.0+ | 数据库 |
| Maven | 3.8+ | 构建工具 |

## 快速开始

### 环境要求
- JDK 25+
- MySQL 8.0+
- Maven 3.8+
- Tomcat 10+

### 1. 数据库配置

执行数据库初始化脚本：

```bash
mysql -u root -p < sql/init.sql
```

脚本会创建：
- `loginregister` 数据库
- `users` 用户表
- `messages` 留言表
- `admins` 管理员表（默认账号：admin/admin123）

### 2. 修改数据库连接

编辑 `src/main/java/cn/lntu/task01/loginandres/util/DBUtil.java`：

```java
private static final String URL = "jdbc:mysql://localhost:3306/loginregister?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
private static final String USER = "root";      // 你的数据库用户名
private static final String PASSWORD = "123456"; // 你的数据库密码
```

### 3. （可选）配置邮箱服务

如需使用邮箱验证码功能，编辑 `src/main/java/cn/lntu/task01/loginandres/util/EmailUtil.java`：

```java
private static final String FROM_EMAIL = "your_email@qq.com";  // 发送邮箱
private static final String AUTH_CODE = "your_auth_code";      // QQ邮箱授权码
```

### 4. 构建与运行

```bash
# 进入项目目录
cd LoginAndRes

# 编译打包
mvn clean package

# 部署到Tomcat
# 将 target/LoginAndRes.war 复制到 Tomcat 的 webapps 目录
```

### 5. 访问地址

| 功能 | URL |
|------|-----|
| 用户登录 | http://localhost:8080/LoginAndRes/login |
| 用户注册 | http://localhost:8080/LoginAndRes/register |
| 留言板 | http://localhost:8080/LoginAndRes/main |
| 管理员登录 | http://localhost:8080/LoginAndRes/admin-login |

## 项目结构

```
LoginAndRes/
├── sql/
│   └── init.sql                    # 数据库初始化脚本
├── src/main/
│   ├── java/cn/lntu/task01/loginandres/
│   │   ├── dao/                    # 数据访问层
│   │   │   ├── AdminDAO.java       # 管理员DAO
│   │   │   ├── MessageDAO.java     # 留言DAO
│   │   │   └── UserDAO.java        # 用户DAO
│   │   ├── entity/                 # 实体类
│   │   │   ├── Admin.java          # 管理员实体
│   │   │   ├── Message.java        # 留言实体
│   │   │   └── User.java           # 用户实体
│   │   ├── servlet/                # 控制器层
│   │   │   ├── AdminLoginServlet.java
│   │   │   ├── AdminServlet.java
│   │   │   ├── LoginServlet.java
│   │   │   ├── LogoutServlet.java
│   │   │   ├── MainServlet.java
│   │   │   └── RegisterServlet.java
│   │   └── util/                   # 工具类
│   │       ├── CaptchaUtil.java    # 验证码生成
│   │       ├── DBUtil.java         # 数据库连接
│   │       ├── EmailUtil.java      # 邮件发送
│   │       ├── MD5Util.java        # MD5加密
│   │       └── QRCodeUtil.java     # 二维码工具
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── jsp/
│       │   │   ├── admin/          # 后台页面
│       │   │   │   ├── adminLogin.jsp
│       │   │   │   ├── adminManage.jsp
│       │   │   │   ├── dashboard.jsp
│       │   │   │   ├── messageManage.jsp
│       │   │   │   └── userManage.jsp
│       │   │   ├── login.jsp       # 登录页面
│       │   │   ├── main.jsp        # 留言板页面
│       │   │   └── register.jsp    # 注册页面
│       │   └── web.xml
│       └── index.jsp
└── pom.xml
```

## 默认账号

| 类型 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | admin123 | 后台管理账号 |

## 使用说明

### 1. 用户注册
1. 访问注册页面
2. 填写用户名、昵称、密码、电话、邮箱
3. 上传头像图片
4. 点击注册

### 2. 用户登录
- **密码登录**：输入用户名、密码和验证码
- **邮箱登录**：输入邮箱，获取验证码后登录
- **扫码登录**：点击微信/QQ按钮，模拟扫码登录

### 3. 留言板
- 登录后访问主页即可发布和查看留言
- 可删除自己发布的留言

### 4. 后台管理
1. 访问管理员登录页面
2. 使用默认账号登录
3. 管理用户、留言和管理员

## 安全特性

- ✅ 密码使用MD5加密存储
- ✅ 登录验证码防暴力破解
- ✅ SQL注入防护（使用PreparedStatement）
- ✅ 表单验证（前端+后端双重验证）

## License

MIT License

## 作者

LNUT Task01 Team
