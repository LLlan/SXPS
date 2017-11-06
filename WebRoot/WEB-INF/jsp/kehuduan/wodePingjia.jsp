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
    <link rel="stylesheet" href="static/css/wm/wodePingjia.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>

    <title>我的评价</title>
    <style>
		.line1>div>img{
		    width:14px;
		    height:14px;
		    margin-left:2px;
		}
		.shangjiaP{
        	display: block;
        }
        .shangjiaP>li {
	        color: #8a8a8a;
    		float: right;
		}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="api/kehu/wode.do" class="iconfont icon-toLeft-copy back"></a>
        <h1>我的评价</h1>
    </div>
</header>
<div class="contentDiv">
    <p class="numPinglun">共${count.count }条评论</p>
  <!-- 商家的评论列表 -->
 <c:forEach items="${wodePingjiaList }" var="wodePingjiaList" varStatus="va">
 	<c:if test="${wodePingjiaList.type=='1' }">
	    <div class="pingjiaDiv">
	        <a href="api/kehu/toShopByInfo.do?user_shangjia_id=${wodePingjiaList.user_shangjia_fid }&mkID=${wodePingjiaList.mkID}&lat=${pd.lat}&lng=${pd.lng}" class="shangjiaP">
	            <i class="iconfont icon-msnui-shops"></i>
	            <span>${wodePingjiaList.shopName }</span>
	            <li class="iconfont icon-jiantou-copy"></li>
	        </a>
	        <div class="pingjiaBox">
	            <div class="line1">
	                <span>商家 : </span>
	                <div>
		                <c:if test="${wodePingjiaList.score == '0.5' }">
			                <img src="static/images/wm/banxing.png" alt=""/>
	                	</c:if>
		                <c:if test="${wodePingjiaList.score == '1' }">
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
		                <c:if test="${wodePingjiaList.score == '1.5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/banxing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '2' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '2.5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/banxing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '3' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '3.5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/banxing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '4' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '4.5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/banxing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                </div>
	                <span style="margin-left:20px;float: left">${wodePingjiaList.min }分钟送达</span>
	                <span style="margin-left:10px;float: left">配送:${wodePingjiaList.score }星</span>
	            </div>
	            <p class="line2"><i class="iconfont icon-biaoqian"></i><span>${wodePingjiaList.label }</span></p>
	            <div class="line3">
	                <span>评论:</span>
	                <p>${wodePingjiaList.content }</p>
	            </div>
	        </div>
	        <p class="shijianP">
	        	<span>${wodePingjiaList.time }</span>
		        <a href="javascript:void(0)" class="shanchu"><i class="iconfont icon-shanchu"></i>删除</a>
		        <c:forEach items="${zuijialist }" var="list" begin="${va.index }" end="${va.index }">
		        	<c:if test="${empty list}">
			       	 	<a href="api/kehu/zhuijia.do?evaluate_id=${wodePingjiaList.evaluate_id }">
			       	 		<i class="iconfont icon-pingjia"></i>追评
			       	 	</a>
		        	</c:if>
		        </c:forEach>
            </p>
	    </div>
 	</c:if>
 		 <!-- 骑手的评价列表 -->
 	<%-- <c:if test="${wodePingjiaList.type=='2' }">
	    <div class="pingjiaDiv">
	        <p class="shangjiaP">
	            <i class="iconfont icon-msnui-shops"></i>
	            <span>${wodePingjiaList.shopName }</span>
	            <a href="javascript:void(0)" class="iconfont icon-jiantou-copy"></a>
	        </p>
	        <div class="pingjiaBox">
	            <div class="line1">
	                <span>骑手 : </span>
	                <div>
	                	<c:if test="${wodePingjiaList.score == '1' }">
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '2' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '3' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '4' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                	<c:if test="${wodePingjiaList.score == '5' }">
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
			                <img src="static/images/wm/xing.png" alt=""/>
	                	</c:if>
	                </div>
	                <span style="margin-left:20px;float: left">35分钟送达</span>
	                <span style="margin-left:10px;float: left">配送:${wodePingjiaList.score }星</span>
	            </div>
	            <p class="line2"><i class="iconfont icon-biaoqian"></i><span>${wodePingjiaList.label }</span></p>
	            <div class="line3">
	                <span>评论: </span>
	                <p>${wodePingjiaList.content }</p>
	            </div>
	        </div>
	        <p class="shijianP"><span>${wodePingjiaList.time }</span><a
	                href="javascript:void(0)" class="shanchu"><i class="iconfont icon-shanchu"></i>删除</a><a href="api/kehu/zhuijia.do?evaluate_id=${wodePingjiaList.evaluate_id }"><i class="iconfont icon-pingjia"></i>追评</a></p>
	    </div>
 	</c:if> --%>
 </c:forEach>
 <!-- 当列表为空时，暂无数据 -->
 <c:if test="${empty wodePingjiaList}"><%@include file="common.jsp" %></c:if>
</div>
<div class="mask"></div>
<div class="shanchuDiv">
    <p class="shifou">确认删除此评价？</p>
    <p><a href="javascript:void(0)" class="cancel">取消</a><a href="javascript:void(0)" class="sure">确认</a></p>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    $(function(){
        var n;
        $(".shanchu").click(function(){
            n=$(this);
            $(".mask").fadeIn();
            $(".shanchuDiv").fadeIn();
            $(".sure").click(function(){
                n.parent().parent().remove();
                $(".mask").fadeOut();
                $(".shanchuDiv").fadeOut();
            });
            $(".cancel").click(function(){
                $(".mask").fadeOut();
                $(".shanchuDiv").fadeOut();
            })
        })
    })
</script>
</body>
</html>
