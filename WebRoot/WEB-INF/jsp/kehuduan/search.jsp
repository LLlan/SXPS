<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>搜索</title>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <link rel="stylesheet" href="static/css/wm/index.css"/>
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <style>
        body{
            background-color:#fff;
        }
        .header_search {
            overflow: hidden;
            z-index: 100;
            border-bottom: 1px solid #f4f4f4;
            padding: 8px 0;
        }
        .header_search div.go {
            height: 25px;
            padding: 0;
            width: 12%;
            float: left;
        }
        .header_search div.go a {
            background: url(static/images/wm/fanhui.png) no-repeat center 0;
            display: block;
            width: 100%;
            height: 100%;
            background-size: 22px;
            margin-top: 3px;
        }
        .header_search div.search {
            padding: 0;
            float: left;
            width: 88%;
        }
        .header_search div.search [type="search"] {
            height: 28px;
            border-radius: .25em;
            background-color: #f4f4f4;
            outline: none;
        }
        .header_search div.search [type="submit"] {
            background-color: #fff;
            border: none;
            line-height: 28px;
            height: 28px;
            font-size: 1.2em;
        }
    </style>
</head>
<body ontouchstart>
<div class="header_search">
    <div class="go">
        <a href="javascript:history.back()"></a>
    </div>
    <div class="search">
        <form action="" method="post">
            <input type="search" class="col-xs-10" name="keywords" id="keywords" autocomplete="off" placeholder="搜索您需要的商品"/>
            <input type="submit" class="col-xs-2" value="搜索"/>
        </form>
    </div>
</div>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
</body>
</html>