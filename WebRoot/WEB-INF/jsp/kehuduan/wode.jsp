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
    <title>我的</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/wode.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>会员中心</title>
    <style>
        .user-login>a{
            color:#fff;
        }
        .wodeListDiv {
		    margin-bottom: 60px;
		}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<div class='weui-content'>
    <div class="wy-center-top">
        <div class="touxiang">
            <div>
            	<c:if test="${resultData.headImg!='' && not empty resultData.headImg}">
	                <img class="weui-media-box__thumb radius" src="${resultData.headImg }" alt="">
            	</c:if>
            	<c:if test="${resultData.headImg=='' || empty resultData.headImg}">
	                <img class="weui-media-box__thumb radius" src="static/images/wm/u132.png" alt="">
            	</c:if>
            </div>
            <div>
                <h4 class="weui-media-box__title user-name" style="display: none;">飞翔的小土豆</h4>
                <c:if test="${resultData.userName!=''}">
                	<h4 class="weui-media-box__title user-login" style="display: block;"><a href="javascript:void(0)">${resultData.userName}</a></h4>
                </c:if>
                 <c:if test="${resultData.userName==''}">
                	<h4 class="weui-media-box__title user-login" style="display: block;"><a href="api/kehu/toLogin.do">登录/注册</a></h4>
            	</c:if>
            </div>
        </div>
    </div>
    <div class="wodeListDiv">
        <div class="wodeList">
            <a href="api/kehu/huiyuanZiliao.do">
                <i class="iconfont icon-huiyuan" style="color:#fe6a7f;"></i>
                <span>会员资料</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <!-- <a href="api/kehu/youhuiQuan.do">
                <i class="iconfont icon-youhuiquan" style="color:#0084fd;"></i>
                <span>优惠券</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a> -->
            <a href="api/kehu/shouhuoDizhi.do?tag=2">
                <i class="iconfont icon-lipin" style="color:#fe8727;"></i>
                <span>收货地址</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <a href="api/kehu/wodePingjia.do?lat=${pd.lat}&lng=${pd.lng}">
                <i class="iconfont icon-pingjia" style="color:#4ddc9c;"></i>
                <span>我的评价</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <a href="api/kehu/wodeShoucang.do?lat=${pd.lat}&lng=${pd.lng}">
                <i class="iconfont icon-shoucang" style="color:#fdce56;"></i>
                <span>店铺收藏</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <a href="api/kehu/lianxiWomen.do">
                <i class="iconfont icon-erji" style="color:#29d0eb;"></i>
                <span>联系我们</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <a href="javascript:void(0)" class="shangjia">
                <i class="iconfont icon-msnui-shops" style="color:#fe7284;"></i>
                <span>商家入驻</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
            <a href="javascript:void(0)" class="qishou">
                <i class="iconfont icon-wentiqishouwenti" style="color:#59f28d;"></i>
                <span>骑手入驻</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
             <a href="api/kehu/tuichu.do" class="qishou1">
                <i class="iconfont icon-tuichudenglu" style="color:red;"></i>
                <span>退出登录</span>
                <i class="iconfont icon-jiantou-copy"></i>
            </a>
        </div>
    </div>
</div>
<!--底部导航-->
<!-- 底栏 -->
<%@include file="buttom.jsp" %>
<div class="mask"></div>
<div class="shanchuDiv shanchuDiv1">
    <p class="shifou">请先下载商家端APP</p>
    <p><a href="javascript:void(0)" class="cancel">取消</a><a href="javascript:void(0)" class="sure" style="color:#0284fe">立即下载</a></p>
</div>
<div class="shanchuDiv shanchuDiv2">
    <p class="shifou">请先下载骑手端APP</p>
    <p><a href="javascript:void(0)" class="cancel">取消</a><a href="javascript:void(0)" class="sure" style="color:#0284fe">立即下载</a></p>
</div>
<script>
    $(function () {
        FastClick.attach(document.body);
        $("#t4").addClass("weui-bar__item--on").siblings().removeClass("weui-bar__item--on");
    });
    $(function(){
        $(".shangjia").click(function(){
            $(".mask").fadeIn();
            $(".shanchuDiv1").fadeIn();
            $(".cancel").click(function(){
                $(".mask").fadeOut();
                $(".shanchuDiv1").fadeOut();
            })
        })
    });
    $(function(){
        $(".qishou").click(function(){
            $(".mask").fadeIn();
            $(".shanchuDiv2").fadeIn();
            $(".cancel").click(function(){
                $(".mask").fadeOut();
                $(".shanchuDiv2").fadeOut();
            })
        })
    })
</script>
</body>
</html>
