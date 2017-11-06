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
    <link rel="stylesheet" href="static/css/wm/liMarquee.css">
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/index.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/swiper.js"></script>
    <script src="static/js/wm/jquery.liMarquee.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=f2C9QaeY2zU9joj3Z34DG2gThH70Pwzl"></script>
    <title>首页</title>
    <style type="text/css">
       .myscroll{
            width: 90%;
            height:20px;
            float: left;
            font-size: 15px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-top: 12px;
        }
        .myscroll li{
        	 overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
    	/*.headLeft {
		    margin-left: -14px;
		}*/
		.fright {
			    margin-top: -23px;
		}
		.str_vertical .str_move, .str_down .str_move{
            overflow: visible;
        }
        .header {
    	 text-align: left; 
		}
		.location {
		    font-size: 15px;
		    color: #fff;
		    width: 45%;
		    height: 50px;
		    line-height: 50px;
		    text-overflow: ellipsis;
		    overflow: hidden;
		    white-space: nowrap;
		}
		.headLeft {
		    width: 45%;
		    height: 50px;
		    line-height: 50px;
		   
		    text-overflow: ellipsis;
		    overflow: hidden;
		    white-space: nowrap;
		}
    </style>
</head>
<body onload="onloadss()">
<div class="content">
<div id="allmap"></div>
    <!--头部-->
    <header>
        <div class="header">
            <div class="headLeft">
                <i class="iconfont icon-dingwei locationIcon"></i><span class="location">北京</span><!-- <a href="javascript:void(0)" class="iconfont icon-icon arrowDown"></a> -->
            </div>
            <!-- <div class="headRight">
                <a href="search.html" class="searchA">搜索商品和商家</a>
            </div> -->
        </div>
    </header>
    <!--导航-->
    <div class="navDiv">
        <div class="nav">
        	<c:forEach items="${mkList }" var="list" end="3">
        		<a href="api/kehu/businessList.do?mkID=${list.mokuai_id }" class="smNav">
	                <!--<p style="background-color:#31d3ec;"><i class="iconfont icon-shucai"></i></p>-->
	                <p><img alt="" src="${list.headImg }"></p>
	                <p>${list.title }</p>
	            </a>
        	</c:forEach>
        	<!--  
            <a href="api/kehu/businessList.do?mkID=ae5d2c4aba824dd0a9d57abf8694a6ed" class="smNav">
                <p style="background-color:#31d3ec;"><i class="iconfont icon-shucai"></i></p>
                <p>蔬菜水果</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=2dc2d5d166b444bc9a6d122669327770" class="smNav">
                <p style="background-color:#4fdb9e;"><i class="iconfont icon-qindan"></i></p>
                <p>鲜肉禽蛋</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=7183d9de1ad545618aacd86836af7cd1" class="smNav">
                <p style="background-color:#ff46b3;"><i class="iconfont icon-haixian"></i></p>
                <p>水产冻货</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=6a5954998ae84aea9838863252ffc686" class="smNav">
                <p style="background-color:#f5b54e;"><i class="iconfont icon-zonghe"></i></p>
                <p>综合食材</p>
            </a>
            -->
        </div>
        <div class="nav" style="margin-top:-1px;">
        	<c:forEach items="${mkList }" var="list" begin="4" end="7">
        		<a href="api/kehu/businessList.do?mkID=${list.mokuai_id }" class="smNav">
	                <!--<p style="background-color:#31d3ec;"><i class="iconfont icon-shucai"></i></p>-->
	                <p><img alt="" src="${list.headImg }"></p>
	                <p>${list.title }</p>
	            </a>
        	</c:forEach>
        	<!--
            <a href="api/kehu/businessList.do?mkID=8dea7fb671294b00ae3d833127e0aa11" class="smNav">
                <p style="background-color:#f377d7;"><i class="iconfont icon-tubiao-"></i></p>
                <p>超市便利</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=e0f3e5211cde48ee91d3b2a807e2f442" class="smNav">
                <p style="background-color:#ffce58;"><i class="iconfont icon-nongzi"></i></p>
                <p>农贸市场</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=3adb065398ed49798267838cf4bf7628" class="smNav">
                <p style="background-color:#41f882;"><i class="iconfont icon-xiannai"></i></p>
                <p>水站鲜奶</p>
            </a>
            <a href="api/kehu/businessList.do?mkID=19be537ce97b4cd783d47ef821aa365b" class="smNav">
                <p style="background-color:#0284fe;"><i class="iconfont icon-shangmen"></i></p>
                <p>上门服务</p>
            </a>
            -->
        </div>
    </div>
    <!--公告-->
      <div class="gonggaoDiv" onclick="window.location.href='api/kehu/toNoticeList.do'">
        <div class="gonggao">
            <i class="iconfont icon-gonggao"></i>
            <div class="weui-flex__item myscroll">
                <ul>
                	<c:forEach items="${noticeList }" var="list">
                		<li><a href="javascript:void(0);" style="color: #333;">${list.title }</a></li>
                	</c:forEach>
                	<!--  api/kehu/toNoticeDetaile.do?notice_id=${list.notice_id }
                    <li><a href="#" style="color: #333;">公告1：店铺的一些促销优惠活动afafafafdafssssssdfdfdfdfdfdfdfdfdfdfdf... </a></li>
                    <li><a href="#" style="color: #333;">公告2：店铺的一些促销优惠活动... </a></li>
                    <li><a href="#" style="color: #333;">公告3：店铺的一些促销优惠活动...</a></li>
                    -->
                </ul>
            </div>
     <!--        <a href="javascript:void(0)">留言</a> -->
        </div>
    </div>
    <!--轮播图-->
    <div class="swiper-container">
        <!-- Additional required wrapper -->
        <div class="swiper-wrapper">
        	<c:forEach items="${varList }" var="list">
        		<div class="swiper-slide"><img src="${list.PATH }"/></div>
        	</c:forEach>
            <!-- Slides -->
            <!--
            <div class="swiper-slide"><img src="static/images/wm/pic1.jpg"/></div>
            <div class="swiper-slide"><img src="static/images/wm/pic2.jpg"/></div>
            <div class="swiper-slide"><img src="static/images/wm/pic3.jpg"/></div>
            -->
        </div>
        <!-- If we need pagination -->
        <div class="swiper-pagination"></div>
    </div>
    <div class="contentDiv">
        <p class="fujinP"><span class="leftx"> </span><span>附近商家</span><span class="rightx"> </span></p>
        <ul class="paixuUl">
            <li tid="1"><a href="javascript:void(0)" class="paixuOn">综合排序</a></li>
            <li tid="2"><a href="javascript:void(0)">距离最近</a></li>
            <li tid="3"><a href="javascript:void(0)">销量最高</a></li>
        </ul>
        <div class="shopDiv">
            <div class="shop">
               <!--  <a href="shop.html" class="smShop">
                    <img src="static/images/wm/u132.png" alt=""/>
                    <div class="smshopRight">
                        <h3 class="dianMing">首尔炸酱面</h3>
                        <p class="pingjiaP"><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/xing.png" alt=""/><img src="static/images/wm/banxing.png" alt=""/> <span>月售2456</span><span class="fright">2.1km</span><span class="fright shuSpan">&nbsp;|&nbsp;</span><span class="fright">30分钟</span></p>
                        <p><span>起送￥20</span><span class="shuSpan">&nbsp;|&nbsp;</span><span>配送￥3</span><span class="shuSpan">&nbsp;|&nbsp;</span></p>
                        <p style="margin-top:5px;"><span class="jianSpan">减</span><span class="jianData">满2减2;满40减4;满60减6;满80减8;满100减10;满200减20;</span></p>
                        <p><span class="jianSpan xinSpan">新</span><span class="jianData">本店新用户立减1元;首次下单用户立减15元;银行卡支付优惠更多哦！</span></p>
                    </div>
                </a> -->
            </div>
        </div>
    </div>
<!-- 底栏 -->
<%@include file="buttom.jsp" %>
</div>
<iframe id="mapPage" width="100%"  frameborder=0 style="display: none;"
        src="http://apis.map.qq.com/tools/locpicker?search=1&type=1&policy=1&coordtype=5&backurl=http://3gimg.qq.com/lightmap/components/locationPicker2/back.html&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp">
</iframe>
<script type="text/javascript" src="http://api.map.baidu.com/getscript?v=2.0&ak=f2C9QaeY2zU9joj3Z34DG2gThH70Pwzl&services=&t=20170823191629"></script>
<script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/getscript?type=quick&file=feature&ak=o9B4Ol99j9NcBXSu5nFTR7uI&t=20140109092002"></script>      

<script type="text/javascript">
       var latitude,longitude,tag;
        $(function () {
            FastClick.attach(document.body);
             /*文字滚动*/
	        $('.myscroll').liMarquee({
	            direction: 'up',
	            loop:222
	
	        });
	        
        });
        
    $(function(){
        $("#mapPage").height($(window).height());
    });
    function bodyScroll(event){  
    	event.preventDefault();  
	}  
    $(".headLeft").click(function(){
        $(".content").hide();
        $("#mapPage").show();
        window.addEventListener('message', function(event){
            // 接收位置信息，用户选择确认位置点后选点组件会触发该事件，回传用户的位置信息
            var loc = event.data;
            if (loc.module == 'locationPicker'){//防止其他应用也会向该页面post信息，需判断module是否为'locationPicker'
                if(loc.poiname=="我的位置"){
               		loc.poiname=loc.poiaddress;
                }
                $(".location").text(loc.poiname);//poiname
                console.log(loc);
				console.log(loc.latlng.lat)
				console.log(loc.latlng.lng)
                $("#mapPage").hide();
                $(".content").show();
            }
          	  $.ajax({	
                    url:'api/kehu/getLocations',
                    type:'post',
                    data:{lat:loc.latlng.lat,lng:loc.latlng.lng},
                    dataType:'json',
                    success:function(data){
                        console.log(data);
                        latitude = data.lat;
                        longitude = data.lng;
                        //调附近商家渲染数据
                        getShangJiaList(1);
                    }
                }); 
        }, true);
       // document.body.removeEventListener('message',bodyScroll,false); 
    });
       
</script>
<!--轮播图-->
<script>
    $(".swiper-container").swiper({
        loop: true,
        autoplay: 3000
    });
</script>   
<script type="text/javascript">
	//百度地图获取坐标
	/*var map = new BMap.Map("allmap");  
	var longitude, latitude; 
	function myFun(result){
		console.log(result);
		var cityName = result.name;
		map.setCenter(cityName);
		$(".location").text(cityName); 
		latitude = result.center.lat;//经度
		longitude = result.center.lng;//纬度
				 
		$(".nav>a").each(function(){
           	$(this).attr("href",$(this).attr("href")+"&lat="+latitude+"&lng="+longitude);
       	 });
		
		//给底栏订单的href的地址后面拼接上经纬度
		$("#t3").attr("href",$("#t3").attr("href")+"?lat="+latitude+"&lng="+longitude);
		$("#t4").attr("href",$("#t4").attr("href")+"?lat="+latitude+"&lng="+longitude);
		
 		//首页底部的附件商家
 	 	getShangJiaList(1);
	}
	  
 	var myCity = new BMap.LocalCity();*/
	//myCity.get(myFun);
	
	   
	//---------------下面的方法在手机上可以准确获取定位的经纬度,在浏览器中调试先用上边的方法---------//	
	
	function onloadss(){
		//定位
		 	var geolocation  = new BMap.Geolocation;
			geolocation.getCurrentPosition(function(position) {
			//geolocation.getCurrentPosition(function(position) {
				latitude = position.latitude;//经度
				longitude = position.longitude;//纬度
				console.log("latitude:"+latitude); 
				console.log("longitude:"+longitude); 
				getShangJiaList(1);
			    $(".nav>a").each(function(){
		               $(this).attr("href",$(this).attr("href")+"&lat="+latitude+"&lng="+longitude);
		        });
			    
			    //给底栏订单的href的地址后面拼接上经纬度
				$("#t3").attr("href",$("#t3").attr("href")+"?lat="+latitude+"&lng="+longitude);
				$("#t4").attr("href",$("#t4").attr("href")+"?lat="+latitude+"&lng="+longitude);
			    
			    var gpsPoint = new BMap.Point(longitude, latitude);
			    //转换坐标  
			    BMap.Convertor.translate(gpsPoint, 0, function (point){  
				    var geoc = new BMap.Geocoder();  
				    geoc.getLocation(point, function (rs){ 
				   	 console.log(rs); 
				         var addComp = rs.addressComponents; 
				         if(addComp.city==""){
				            $(".location").text("北京"); 
				         }else{
				           	$(".location").text(addComp.city); 
				         }
				         console.log("地址是："+addComp.province + ", " + addComp.city + ", " + addComp.district + ", " + addComp.street + ", " + addComp.streetNumber);  
				    });  
				});  
				
				//首页底部的附件商家
			   // getShangJiaList(1);
			} ); 
		
	}	
	  
	/*function translatePoint(position) {
		console.log(position); 
		var latitude = position.coords.latitude;//经度
		var longitude = position.coords.longitude;//纬度
	    $(".nav>a").each(function(){
               $(this).attr("href",$(this).attr("href")+"&lat="+latitude+"&lng="+longitude);
        });
		
	  	//给底栏订单的href的地址后面拼接上经纬度
		$("#t3").attr("href",$("#t3").attr("href")+"?lat="+latitude+"&lng="+longitude);
		$("#t4").attr("href",$("#t4").attr("href")+"?lat="+latitude+"&lng="+longitude);
	  	
	    var gpsPoint = new BMap.Point(longitude, latitude);
	    //转换坐标  
	    BMap.Convertor.translate(gpsPoint, 0, function (point){  
		    var geoc = new BMap.Geocoder();  
		    geoc.getLocation(point, function (rs){  
		         var addComp = rs.addressComponents; 
		         if(addComp.city==""){
		            $(".location").text("北京"); 
		         }else{
		           	$(".location").text(addComp.city); 
		         }
		         console.log("地址是："+addComp.province + ", " + addComp.city + ", " + addComp.district + ", " + addComp.street + ", " + addComp.streetNumber);  
		    });  
		});  
		
		//首页底部的附件商家
	    getShangJiaList(1);
	} */
	
	
	//1.综合排序。2.距离最近。3.销量最高
    $(function(){
        $(".paixuUl>li").click(function(){
            $(this).find("a").addClass("paixuOn");
            $(this).siblings().find("a").removeClass("paixuOn");
            var type=$(this).attr("tid");
            getShangJiaList(type);
        });
    });
    
    //根据条件获取对应的商家列表
    //type:1.综合排序。2.距离最近。3.销量最高
    function getShangJiaList(type){
    	$.post('api/kehu/nearDistanceShangjia.do',
  	         {
 	         	lat:latitude,
 	         	lng:longitude,
 	         	mkID:"",
 	         	type:type
  	         },function(data){
  	        	var appendHtml="";
  	         	for(var i=0;i<data.businessList.length;i++){
  	         		appendHtml+= '<a href="api/kehu/shop.do?flag=1&user_shangjia_id='+data.businessList[i].user_shangjia_id+'&mkID='+data.businessList[i].mkID+'" class="smShop">';
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
  	          		
  	          		appendHtml+='<p><span>起送￥'+data.businessList[i].deliveryAmount+'</span><span class="shuSpan">&nbsp;|&nbsp;</span><span>配送￥'+data.businessList[i].psCost+'起</span><span class="shuSpan">&nbsp;|&nbsp;</span></p>';
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
  			}); 
    }
</script>
</body>
</html>