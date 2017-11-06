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
<head lang="en">
<base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/iconfont.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/order.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>全部订单</title>
    <style>
        .comment{
            margin-bottom:60px;
        }
        .order_r_r1 a {
            float: left;
            width: 10%;
            color: #333;
            font-size: 15px;
            text-align: center;
        }
    </style>
</head>
<body ontouchstart>
<!--头部开始-->
<header>
    <div class="header">
        <h1>全部订单</h1>
    </div>
</header>
<div class="comment">
	<c:forEach items="${OrderList}" var="pds">
	    <div class="order">
	        <div class="order_t">
	            <div class="order_r_l">
	            	<c:if test="${ pds.logoImg != '' && pds.logoImg != null}">
	           			<img src="<%=basePath%>${pds.logoImg }" alt=""/>
		            </c:if>
	                 <c:if test="${ pds.logoImg == '' || pds.logoImg == null}">
		            	<img src="static/images/wm/mj10.jpg" alt=""/>
		            </c:if>
	            </div>
	            <div class="order_r_r" onclick="window.location.href='api/kehu/orderinfo.do?order_takeou_id=${pds.order_takeou_id }&lat=${pd.lat}&lng=${pd.lng}'">
	                <div class="order_r_r1">
	                     <h1>${pds.shopName }</h1>
	                    <h3>
	                    	<c:if test="${pds.orderStateKehu=='0' }">订单已取消</c:if>
							<c:if test="${pds.orderStateKehu=='1' }">待付款</c:if>
							<c:if test="${pds.orderStateKehu=='2' }">已付款,等待商家受理</c:if>
							<c:if test="${pds.orderStateKehu=='3' }">待发货</c:if>
							<c:if test="${pds.orderStateKehu=='4' }">待收货</c:if>
							<c:if test="${pds.orderStateKehu=='5' }">
								<c:if test="${pds.is_evaluate=='0' }">
									待评价
								</c:if>
								<c:if test="${pds.is_evaluate=='1' }">
									已完成
								</c:if>
							</c:if>
							<c:if test="${pds.orderStateKehu=='6' }">已结束</c:if>
	                    </h3>
	                    <!--<a href="api/kehu/orderinfo.do?order_takeou_id=${pds.order_takeou_id }">></a>-->
	                </div>
	                <div class="order_r_r2">
	                    ${fn:substring(pds.orderTime,0,19)}
	                </div>
	                <div class="order_r_r3">
	                    <span>${pds.goodsName }</span><span><c:if test="${pds.goodsNum==2 }">等</c:if>${pds.goodsNum }</span>件商品
	                </div>
	                <div class="order_r_r4">
	                                               ￥${pds.totalSum }
	               	<c:choose>
	               		<c:when test="${pds.deliveryMode==1 }">
	               			(生鲜专送)
	               		</c:when>
	               		<c:when test="${pds.deliveryMode==2 }">
	               			(商家自送)
	               		</c:when>
	               		<c:when test="${pds.deliveryMode==3 }">
	               			(客户自取)
	               		</c:when>
	               		<c:otherwise>
	               			(商家配送)
	               		</c:otherwise>
	               	</c:choose>
	                </div>
	            </div>
	        </div>
	        <div class="order_b">
	            <a href="api/kehu/toShopByInfo.do?user_shangjia_id=${pds.user_shangjia_fid }&mkID=${pds.mkID }&lat=${pd.lat}&lng=${pd.lng}" class="again_order">再来一单</a>
	           	<c:if test="${pds.orderStateKehu=='1' }"><a href="api/kehu/tozaixianZhifu?order_takeou_id=${pds.order_takeou_id }&total=${pds.paySum}" class="good">去付款</a></c:if>
				<c:if test="${pds.orderStateKehu=='2' || pds.orderStateKehu=='3' || pds.orderStateKehu=='4' }"><a href="javascript:void(0);" class="good">取消订单</a></c:if>
				<c:if test="${pds.orderStateKehu=='4' }"><a href="javascript:void(0);" class="good">确认收货</a></c:if>
			<%--<c:if test="${pds.orderStateKehu=='2' }"><a href="javascript:void(0);" class="good">已付款</a></c:if>
				<c:if test="${pds.orderStateKehu=='3' }"><a href="javascript:void(0);" class="good">待发货</a></c:if>
				<c:if test="${pds.orderStateKehu=='4' }"><a href="javascript:void(0);" class="good">待收货</a></c:if> --%>
				<c:if test="${pds.orderStateKehu=='5' }">
					<c:if test="${pds.is_evaluate=='0' }">
						<a href="api/kehu/myeval.do?order_takeou_id=${pds.order_takeou_id }" class="good">评价</a>
					</c:if>
				</c:if>
	        </div>
	    </div>
	</c:forEach>
	<!-- 当列表为空时，暂无数据 -->
	<c:if test="${empty OrderList}"><%@include file="common.jsp" %></c:if>
</div>
<!--底部导航-->
<!-- 底栏 -->
<%@include file="buttom.jsp" %>
<script>
    $(function() {
        FastClick.attach(document.body);
        $("#t3").addClass("weui-bar__item--on").siblings().removeClass("weui-bar__item--on");
    });

</script>
</body>
</html>