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
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/huiyuanZiliao.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/imgUp-2.js"></script>
    <title>会员资料</title>
    <style>
        .z_photo .z_file {
            position: relative;
        }
        .z_file .file {
            width: 100%;
            height: 100%;
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 100;
        }
        .add-img{
            width:44px;
            height:44px;
    		border-radius: 50%;
        }
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="api/kehu/wode.do" class="iconfont icon-toLeft-copy back"></a>
        <h1>会员资料</h1>
    </div>
</header>
<div class="contentDiv">
    <a href="javascript:void(0);" class="changePicA">
        <span class="spanLeft">头像</span>
        <i class="iconfont icon-jiantou-copy jiantou"></i>
        <!--<div class="touxiang"><img src="static/images/wm/u132.png" alt=""/></div>-->
       <form id="headImgForm">
	        <div class="img-box full touxiang">
	            <section class=" img-section">
	                <div class="z_photo upimg-div clear" style="border:none;">
	                    <section class="z_file fl"  style="margin:0;">
	                        <c:if test="${pds.headImg!='' && pds.headImg!=null }">
				          		<img src="${pds.headImg }" class="add-img" style="margin:0;">
				          	</c:if>
				           	<c:if test="${pds.headImg=='' || pds.headImg==null }">
				           		 <img src="static/images/wm/u132.png" class="add-img" style="margin:0;">
				           	</c:if>
	                        <input type="file" name="imgFile" id="imgFile" class="file" value="" accept="image/*" multiple style="margin:0;width:100%;"/>
	                    </section>
	                </div>
	            </section>
	        </div>
       </form>
    </a>
    <a href="api/kehu/changeUserName.do" class="userName">
        <span class="spanLeft">用户名</span>
        <i class="iconfont icon-jiantou-copy jiantou"></i>
        <span class="spanRight">
        	<c:if test="${pds.userName!='' && pds.userName!=null }">
	          	${pds.userName}
          	</c:if>
           	<c:if test="${pds.userName=='' || pds.userName==null }">
           		 未设置
           	</c:if>
        </span>
    </a>
    <p>账户绑定</p>
    <a href="api/kehu/changeTel.do" class="userName">
        <i class="iconfont icon-shouji tubiao1"></i>
        <span class="spanLeft">手机号</span>
        <i class="iconfont icon-jiantou-copy jiantou"></i>
        <span class="spanRight">${fn:substring(pds.phone,0,3)}****${fn:substring(pds.phone,7,11)}</span>
    </a>
   <!-- <p>安全设置</p>
    <a href="javascript:void(0)" class="userName">
        <i class="iconfont icon-mima tubiao1"></i>
        <span class="spanLeft">支付密码</span>
        <i class="iconfont icon-jiantou-copy jiantou"></i>
        <span style="color:#0283f8;font-size:16px;" class="spanRight">未设置</span>
    </a>
-->
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
</script>
</body>
</html>
