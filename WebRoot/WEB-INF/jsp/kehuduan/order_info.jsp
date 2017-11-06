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
    <link rel="stylesheet" href="static/css/wm/demos.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/querenDingdan.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>

    <title>订单详情</title>
    <style>
        #mobile{
            width:65px;
            color:#0283fb;
            font-size:16px;;
        }
        .toolbar .toolbar-inner{
            height:40px;
        }
        .toolbar .picker-button{
            height:40px;
            line-height: 40px;;
        }
        .toolbar .title{
            height:40px;
            line-height: 40px;;
        }
        .weui-picker-modal{
            height:350px;
        }
        .weui-picker-modal .picker-modal-inner{
            height:300px;
        }
        .touxDiv{
            width:100%;
            height:144px;
            background-color: #fff;
            text-align: center;
        }
        .touxDiv>img{
            width:60px;
            height:60px;
            margin:20px auto 0;
        }
        .zhuangt1{
            font-size: 16px;
            color:#666;
            height: 16px;
            line-height: 16px;
            margin-top:16px;
        }
        .zhuangt2{
            font-size: 12px;
            color:#ccc;
            height: 12px;
            line-height: 12px;
            margin-top:8px;
        }
        .yixuanDiv{
            margin-top:10px;
        }
        .yixuanHead{
            overflow: hidden;
            height:40px;
            line-height: 40px;;
        }
        .yixuanHead>span{
            float: left;
            border:none;
            padding:0;
        }
        .yixuanHead>img{
            float: left;
            width:20px;
            height:20px;
            margin-top:10px;
            margin-right:10px;
        }
        .yixuanHead>a{
            float: right;
            font-size: 20px;
            padding-right:3%;
        }
        .lianxiBox{
            width:100%;
            height:92px;
            text-align: center;
            border-top:1px solid #f4f4f4;
            background-color: #fff;
        }
        .lianxi{
            display: block;
            width:120px;
            height:32px;
            line-height: 32px;
            text-align: center;
            border:1px solid #e5e5e5;
            margin:40px auto auto;
            font-size:16px;
            color:#333;
            border-radius: 5px;;
        }
        .lianxi i{
            color:#0283fb;
            font-size: 20px;
            margin-right:5px;
        }
        .peisongXinxi{
            width:100%;
            margin-top:10px;
            padding-left:3%;
            background-color: #fff;
            padding-bottom:10px;
        }
        .peisongXinxi>div{
            width:100%;
            padding-right:3%;
            border-bottom:1px solid #e5e5e5;
        }
        .peisHead{
            height:44px;
            line-height: 44px;
            color:#000;
            font-size:16px;
        }
        .peisTime{
            height:44px;
            line-height: 44px;
            font-size: 14px;;
            color:#333;
        }
        .peisDizhi{
            height:84px;
            overflow: hidden;
        }
        .left1{
            width:23%;
            height:14px;
            line-height: 14px;
            font-size: 14px;
            color:#333;
            margin-top:12px;
            float: left;
        }
        .right1{
            width:77%;
            height:72px;
            line-height: 14px;
            font-size: 14px;
            color:#333;
            margin-top:12px;
            float: right;
        }
        .right1>p{
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-top:8px;
        }
        .right1>p:nth-child(1){
            margin-top:0;
        }
        .yixuanHead{
        	display: block;
        }
        .yixuanHead>i {
		    float: right;
		    font-size: 20px;
		    padding-right: 3%;
		}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>订单详情</h1>
    </div>
</header>
<div class="contentDiv">
    <div class="touxDiv">
        <c:if test="${ pd.logoImg != '' && pd.logoImg != null}">
			<img src="<%=basePath%>${pd.logoImg }" alt=""/>
        </c:if>
        <c:if test="${ pd.logoImg == '' || pd.logoImg == null}">
        	<img src="static/images/wm/u132.png" alt=""/>
        </c:if>
        <p class="zhuangt1"> 
        	<c:if test="${pd.orderStateKehu=='0' }">订单已取消</c:if>
			<c:if test="${pd.orderStateKehu=='1' }">待付款</c:if>
			<c:if test="${pd.orderStateKehu=='2' }">已付款,等待商家受理</c:if>
			<c:if test="${pd.orderStateKehu=='3' || pd.orderStateKehu=='4' }">商家已受理,等待收货</c:if>
			<!--<c:if test="${pd.orderStateKehu=='4' }">待收货</c:if>-->
			<c:if test="${pd.orderStateKehu=='5' }">订单已完成</c:if>
			<c:if test="${pd.orderStateKehu=='6' }">订单已结束</c:if>
        </p>
        <!-- <p class="zhuangt2">正在等待商家接单，请耐心等待</p> -->
    </div>
    <div class="yixuanDiv">
        <a href="api/kehu/toShopByInfo.do?user_shangjia_id=${pd.user_shangjia_fid }&mkID=${pd.mkID}&lat=${pds.lat}&lng=${pds.lng}" class="yixuanHead">
        	<img src="<%=basePath%>${pd.logoImg }" alt=""/>
	        <span>${pd.shopName }</span>
	        <i class="iconfont icon-jiantou-copy"></i>
        </a>
       <c:forEach items="${goodsList}" var="pds">
	        <p class="luroufan">
	            <span class="ciaming">${pds.goodsName }</span>
	            <span class="shuliang">x${pds.goodsNum }</span>
	            <span class="jiage">¥${pds.presentPrice }</span>
	        </p>
       </c:forEach>
       		<!--  
	        <p class="peisongfei">
	            <span class="ciaming">包装费</span>
	            <span class="jiage">￥${pd.canhefei }</span>
	        </p>
	        -->
	        <c:if test="${pd.peisongfei!='0.00' && pd.peisongfei!='0.0' && pd.peisongfei!='0' }">
	        <p class="luroufan">
	            <span class="ciaming">配送费</span>
	            <span class="heji">¥${pd.peisongfei }</span>
	        </p>
	        </c:if>
	        <c:if test="${(pd.mjyh!='0' && pd.mjyh!='0.0' && pd.mjyh!='0.00') || (pd.xyhli!='0' && pd.xyhli!='0.0' && pd.xyhli!='0.00') || (pd.mjpsf!='0' && pd.mjpsf!='0.0' && pd.mjpsf!='0.00') }">
	        	<p style="margin-top: 15px;"></p>
	        </c:if>
	        <!-- 满减优惠 -->
	        <c:if test="${pd.mjyh!='0' && pd.mjyh!='0.0' && pd.mjyh!='0.00' }">
	        	<p class="luroufan">
		            <span class="ciaming"><img alt="" src="static/images/wm/jian.png" style="height: 17px;width: 17px;vertical-align: middle;margin-right: 10px;">满减优惠</span>
		            <span class="heji">-￥${pd.mjyh }</span>
		        </p>
	        </c:if>
	        <!-- 本店新用户立减 -->
	        <c:if test="${pd.xyhli!='0' && pd.xyhli!='0.0' && pd.xyhli!='0.00' }">
	        	<p class="luroufan">
		            <span class="ciaming"><img alt="" src="static/images/wm/xin.png" style="height: 17px;width: 17px;vertical-align: middle;margin-right: 10px;">本店新用户立减</span>
		            <span class="heji">-￥${pd.xyhli }</span>
		        </p>
	        </c:if>
	        <!-- 满减配送费 -->
	        <c:if test="${pd.mjpsf!='0' && pd.mjpsf!='0.0' && pd.mjpsf!='0.00'}">
	        	<p class="luroufan">
		            <span class="ciaming"><img alt="" src="static/images/wm/hui.png" style="height: 17px;width: 17px;vertical-align: middle;margin-right: 10px;">满减配送费</span>
		            <span class="heji">-￥${pd.mjpsf }</span>
		        </p>
	        </c:if>
	        <c:if test="${(pd.mjyh!='0' && pd.mjyh!='0.0' && pd.mjyh!='0.00') || (pd.xyhli!='0' && pd.xyhli!='0.0' && pd.xyhli!='0.00') || (pd.mjpsf!='0' && pd.mjpsf!='0.0' && pd.mjpsf!='0.00') }">
	        	<p style="margin-bottom: 15px;"></p>
	        </c:if>
	        
	        <p class="luroufan">
	            <span class="ciaming">合计 : </span>
	            <span class="heji">￥${pd.paySum }</span>
	        </p>
    </div>
    <div class="lianxiBox"><a href="javascript:void(0)" class="lianxi"><i class="iconfont icon-dianhua"></i>联系商家</a></div>
    <div class="peisongXinxi">
        <div class="peisHead">配送信息
        <c:choose>
       		<c:when test="${pd.deliveryMode==1 }">
       			(生鲜专送)
       		</c:when>
       		<c:when test="${pd.deliveryMode==2 }">
       			(商家自送)
       		</c:when>
       		<c:when test="${pd.deliveryMode==3 }">
       			(客户自取)
       		</c:when>
       		<c:otherwise>
       			(商家配送)
       		</c:otherwise>
       	</c:choose>
        </div>
        	 <c:if test="${not empty pd.qurysdTime and pd.qurysdTime!='' }">
		        <div class="peisTime">
	            	<li  class="listitem">
	                    <span >送达时间：</span>
	                   	 ${fn:substring(pd.qurysdTime,0,16)}
	                 </li>
		        </div>
            </c:if>
        <div class="peisDizhi">
            <div class="left1">收货地址 : </div>
            <div class="right1">
                <p>${pd.linkmanName } <span>${pd.identity }</span></p>
                <p>${pd.phone }</p>
                <p>${pd.detailAddress }</p>
            </div>
        </div>
        <div class="peisHead">订单信息</div>
        <div class="peisTime">订单号 : ${pd.orderNumber }</div>
        <div class="peisTime">支付方式 : ${pd.payMethod }</div>
        <div class="peisTime">下单时间 : ${fn:substring(pd.orderTime,0,16)} </div>
    </div>
</div>
<div class="mask"></div>
<div class="shanchuDiv">
    <p class="shifou">${pd.tel_phone}</p>
    <p><a href="javascript:void(0)" class="cancel" style="color:#0284fe;">取消</a><a href="javascript:void(0)" class="sure" style="color:#0284fe">呼叫</a></p>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    $(function(){
        $(".lianxi").click(function(){
            console.log("111");
           // $(".shifou").text($(".call").text());
            $(".sure").attr("href","tel:"+$(".shifou").text());
            $(".mask").fadeIn();
            $(".shanchuDiv").fadeIn();
            $(".cancel").click(function(){
                $(".mask").fadeOut();
                $(".shanchuDiv").fadeOut();
            });
        });
    });
</script>
</body>
</html>
