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
    <link rel="stylesheet" href="static/css/wm/index.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/starScore.js"></script>
    <script src="static/js/wm/starScore1.js"></script>
    <title>商家列表</title>
    <style>
        .headRight {
            position: absolute;
		    width: 75%;
		    top: 0;
		    left: 9.5%;
		    height: 40px;
		    padding-top: 10px;
        }
        .contentDiv{
            padding-bottom:0;
            padding-top: 50px;
        }
        .fright {
		    margin-top: -23px;
		}
		.searchA {
		    display: block;
		    width: 100%;
		    height: 30px;
		    line-height: 30px;
		    background: #fff url(static/images/wm/sousuo.png) 3% center no-repeat;
		    background-size: 15px 15px;
		    border-radius: 25px;
		    text-align:left;
		    padding-left:27px;
		    color: #999;
		    font-size: 14px;
		}
		.search{
			height: 30px;
		    line-height: 30px;
		    color: #fff;
		    font-size: 16px;
		    top: 9px;
		    right: 17px;
		    position: fixed;
		    background-color: #0284fe;
		}
    </style>
</head>
<body ontouchstart>
<!--头部-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <div class="headRight">
            <!--<a href="javascript:void(0);" class="searchA">输入关键字搜索商家</a>-->
            <input type="text" class="searchA" placeholder="输入关键字搜索商家"> 
            <button class="search">搜索</button>
        </div>
    </div>
</header>
<!--商家列表-->
<div class="contentDiv">
    <!-- <p class="fujinP"><span class="leftx"> </span><span>附近商家</span><span class="rightx"> </span></p> -->
    <ul class="paixuUl" style="display: none;">
        <li tid="1"><a href="javascript:void(0)" class="paixuOn">综合排序</a></li>
        <li tid="2"><a href="javascript:void(0)">距离最近</a></li>
        <li tid="3"><a href="javascript:void(0)">销量最高</a></li>
    </ul>
    <div class="shopDiv">
        <div class="shop">
        	<!--  
            <c:forEach items="${businessList }" var="bu">
            <a href="api/kehu/shop.do?user_shangjia_id=${bu.user_shangjia_id}&mkID=${mkID}&lat=${lat}&lng=${lng}" class="smShop">
                <img src="${bu.logoImg}" alt=""/>
                <div class="smshopRight">
                    <h3 class="dianMing">${bu.shopName }</h3><span class="fright">${bu.distance}km</span>
                   <!--  <p class="pingjiaP"><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/banxing.png" alt=""/> <span>月售2456</span><span class="fright">2.1km</span><span class="fright shuSpan">&nbsp;|&nbsp;</span><span class="fright">30分钟</span></p> -->
                    <!--<p><span>起送￥${bu.deliveryAmount }</span><span class="shuSpan">&nbsp;|&nbsp;</span><span>配送￥3</span><span class="shuSpan">&nbsp;|&nbsp;</span></p>
                    <c:if test="${not empty bu.mjString }">
                    	<p style="margin-top:5px;"><span class="jianSpan">减</span><span class="jianData">${bu.mjString }</span></p>
                    </c:if>
                    <c:if test="${not empty bu.xyhli }">
                    	<p><span class="jianSpan xinSpan">新</span><span class="jianData">${bu.xyhli }</span></p>
                    </c:if>
                </div>
            </a>
            </c:forEach>
            -->
        </div>
    </div>
</div>

<!--排序-->
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    $(function(){
        $(".paixuUl>li").click(function(){
            $(this).find("a").addClass("paixuOn");
            $(this).siblings().find("a").removeClass("paixuOn");
            var type=$(this).attr("tid");
            getShangJiaList(type);
        });
    });
    //点击搜索
    $(".search").click(function(){
    	getShangJiaList(1);
    });
    
    
    
  	//根据条件获取对应的商家列表
    //type:1.综合排序。2.距离最近。3.销量最高${mkID}&lat=${lat}&lng=${lng}
    function getShangJiaList(type){
    	$.post('api/kehu/nearDistanceShangjia.do',
  	         {
 	         	lat:"${pd.lat}",
 	         	lng:"${pd.lng}",
 	         	type:type,
 	         	mkID:"",
 	         	searchName:$(".searchA").val()
  	         },function(data){
  	        	var appendHtml="";
  	        	if(data.businessList.length>0){
	  	         	for(var i=0;i<data.businessList.length;i++){
	  	         		appendHtml+= '<a href="api/kehu/shop.do?user_shangjia_id='+data.businessList[i].user_shangjia_id+'&mkID='+data.mkID+'&lat='+${pd.lat}+'&lng='+${pd.lng}+'" class="smShop">';
	  	          		appendHtml+=' <img src="'+data.businessList[i].logoImg+'" alt=""/>';
	  	          		appendHtml+='<div class="smshopRight">';
	  	          		appendHtml+='<h3 class="dianMing">'+data.businessList[i].shopName+'</h3><span class="fright">'+data.businessList[i].distance+'km</span>';
	  	          		
	  	          		appendHtml+='<p class="pingjiaP">';
	  	          		if(data.businessList[i].xsNum=="0"){
	  	          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="0.5"){
	  	          			appendHtml+='<img src="static/images/wm/banxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="1"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="1.5"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/banxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="2"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="2.5"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/banxing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="3"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="3.5"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/banxing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="4"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/huixingxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="4.5"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		        			appendHtml+='<img src="static/images/wm/banxing.png" alt=""/>';
	  	          		}else if(data.businessList[i].xsNum=="5"){
	  	          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
		          			appendHtml+='<img src="static/images/wm/xing.png" alt=""/>';
	  	          		}
	  	          		appendHtml+='<span style="margin-left: 10px;">月售'+data.businessList[i].xsNum+'</span></p>';
	  	          		
	  	          		appendHtml+='<p><span>起送￥'+data.businessList[i].deliveryAmount+'</span><span class="shuSpan">&nbsp;|&nbsp;</span><span>配送￥'+data.businessList[i].psCost+'</span><span class="shuSpan">&nbsp;|&nbsp;</span></p>';
	  	          		if(data.businessList[i].mjString!=undefined){
	  	          			appendHtml+='<p style="margin-top:5px;"><span class="jianSpan">减</span><span class="jianData">'+data.businessList[i].mjString+'</span></p>';
	  	          		}
	  	          		if(data.businessList[i].xyhli!=undefined){
	  	          			appendHtml+=' <p><span class="jianSpan xinSpan">新</span><span class="jianData">新用户立减'+data.businessList[i].xyhli+'元</span></p>';
	  	          		}
	  	          		appendHtml+='</div>';
	  	          		appendHtml+='</a>';
	  	         	}
	  	         	$(".shop").html(appendHtml);
	  	         	$(".paixuUl").css("display","block");
  	        	}else{
  	        		$(".paixuUl").css("display","none");
  	        		
  	        		appendHtml+='<div style="text-align: center;">';
  	        		appendHtml+='<img style="width: 100px;margin-top: 33%;" src="static/images/wm/yihan.png">';
  	        		appendHtml+='<p style="font-size: 15px;margin-top: 10px;">很遗憾,没有找到相关商家</p>';
  	        		appendHtml+='</div>';
  	        		$(".shop").html(appendHtml);
  	        		
  	        		$(".shopDiv").css("background-color","#f4f4f4");
  	        	};
  			});
    };
</script>
</body>
</html>