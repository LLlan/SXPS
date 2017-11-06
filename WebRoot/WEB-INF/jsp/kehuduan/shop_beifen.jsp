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
    <link rel="stylesheet" href="static/css/wm/shop1.css">
    <link rel="stylesheet" href="static/css/wm/shop.css">
    <link rel="stylesheet" href="static/css/wm/demo.css">
    <link rel="stylesheet" href="static/css/wm/liMarquee.css">
    <link rel="stylesheet" href="static/css/wm/index1.css">
    <link rel="stylesheet" href="static/css/wm/layer.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/jquery.liMarquee.js"></script>
    <script src="static/js/wm/layer.js"></script>

    <title>商家详情</title>
    <style>
     	.mask{
            position:fixed;z-index:600;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.3);display: none;;
        }
        .gouwuche{
            width:100%;position: fixed;left:0;bottom:50px;z-index:700;font-size: 16px;color:#000;display: none;
        }
        .first1{
            padding:10px 3%;background-color: #ededed;border-bottom:1px solid #cfcfcf;
        }
        .first1>span:nth-child(1){
            padding-left:3px;border-left:3px solid #0080ff;
        }
        .clearB{
            float:right;padding-right:18px;background: url(static/images/wm/lajitong.png) right no-repeat;background-size:16px 16px;
        }
        .gouwuche>div:not(.first1){
            padding:12px 3%;background-color: #fff;border-bottom:1px solid #cfcfcf;
        }
        .jian1{
            display:inline-block;width:27px;height: 27px;line-height: 27px;border:1px solid #dbdbdb;border-radius: 50%;text-align: center;
        }
        .jia1{
            display:inline-block;width:27px;height: 27px;line-height: 27px;border:1px solid #dbdbdb;border-radius: 50%;text-align: center;background-color: #0284fe;color:#fff;
        }
        .d-stock>span{
            display: inline-block;
            width: 32%;
        }
        .d-stock>span:first-child{
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .d-stock>span:nth-child(2){
            text-align: center;
        }
        .d-stock>span:nth-child(3){
            text-align: center;
        }
        .pop1{
            position:fixed;
            z-index:101;
            width: 100%;
            top:0;left:0;
            overflow:auto;
            padding:0;           
            background: #f4f4f4;
            box-sizing:border-box;
        }
        .guanbi1 {
            background: url(static/images/wm/quxiao.png) no-repeat  ;
            width: 18px;
            height: 18px;
            z-index:1000;
            display: block;
            position: absolute;
            top: 15px;
            left: 15px;
            cursor: pointer;
            background-size:cover;
        }
         .guanbi2 {
            background: url(static/images/wm/error2.png) no-repeat  ;
            width: 25px;
            height: 25px;
            z-index:1000;
            display: block;
            position: absolute;
            top: 15px;
            left: 15px;
            cursor: pointer;
            background-size:cover;
        }
        .weui-navbar__item{
            line-height: 30px;
        }
        .weui-navbar + .weui-tab__bd {
            padding-top: 39px;
        }
        body,html{
            background-color: #f4f4f4;
        }
        .weui-cells{
            background-color: #fff;
        }
        .hover{
            background-color: #EA2000;
            color: #fff!important;
        }
        .str_wrap {
            overflow: hidden;
            width: 100%;
            font-size: 12px;
            height: 16px;
            line-height: 16px;
            position: relative;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .myscroll {
            height: 20px;
            float: left;
            /* margin: 0 auto; */
            line-height: 20px;
            font-size: 12px;
            overflow: hidden;
            margin-left: 26px;
            margin-top: -19px;
        }
        .weui-flex__item {
            -webkit-box-flex: 1;
            -webkit-flex: 1;
            flex: 1
        }
        .myscroll li {
            height: 20px;
            margin-left: 3px;
        }
        .pop1{
            z-index: 999;
        }


        .line1{
            width:94%;
            height:30px;
            line-height: 30px;
            margin:10px auto;
            overflow: hidden;
        }
        .icon1{
            font-size: 20px;
            float: left;
        }
        .headRight {
            width:85%;
            height: 30px;
            margin-left: 7%;
            padding-top:0;
            float: left;
        }
        .appmsg {
            width:94%;
            height:60px;
            overflow: hidden;
            display:block;
            margin:0 auto 10px;
            padding:0;
        }
        .appmsg .weui-media-box__hd{
            width:60px;
            height:60px;
            float: left;
            margin-right:12px;;
        }
        .appmsg_m{
            width: 60%;
            height:60px;
            overflow: hidden;
            float: left;
        }
        .info1{
            height:20px;
            line-height: 20px;;
        }
        .collection{
            float:right;
            width:15%;
            height:60px;
            text-align: center;
            margin-left:0;
        }
        .collection p{
            margin-top:-5px;
        }
        .weui-navbar {
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            height: 40px;
            line-height: 40px;
            position: fixed;
            z-index: 500;
            top:154px;
            width: 100%;
            background: #FFFFFF;
        }
        .weui-tab {
            position: relative;
            height: 100%;
            width: 100%;
            top:154px;
        }
        .eval_rt_top{
            margin-bottom:0;
        }
        .eval_lf>img{
            width:100%;
            height:100%
        }
        .eval_rt_img{
            width:31.5%;
            margin-right:5px;
        }
        .eval_rt_img>img{
            width:100%;
            height:100%;
        }
        .eval_rt_Img>.eval_rt_img:nth-child(3){
            margin-right:0;
        }
        .eval_rt_Img>.eval_rt_img:nth-child(6){
            margin-right:0;
        }
        .eval_rt_Img>.eval_rt_img:nth-child(9){
            margin-right:0;
        }
        .ovh{
            position:fixed;
            width:100%;
            top:160px;
            left:0;
        }
        .bgf4{
            width:25%;
            float:left;
        }
        .comment {
            position: relative;
            width: 53%;
            top: -1px;
            height: 21px;
        }
        .comment img{
            width:16px;
            height:16px;
        }
        .copies{
            color:#999;
        }
        .cart{
            background: url(static/images/wm/gouwuche22.png) no-repeat;
            background-size:30px 30px;
        }
        .tqfooter .ft-lt{
            width:70%;
            float:left;
        }
        .tqfooter{
            background-color: #303030;
            z-index: 700;
        }
        .tqfooter .ft{
            float: right;
        }
        
        .foodlist_label {
		    font-size: 12px;
		}
		.icon-xing2{
			color:#FFCE44;
		}
		.youhui{
			width: 87%;
			margin: 0 auto;
			border-top: 1px solid rgba(255, 255, 255, 0.39);
		}
		.foodlist_label {
		 
		    background-color: #fff;
		}
		.shop-cart .d-stock .text_box{
			width:20px;
			float:none;
		}
		.shop-cart{
			width:40%;
		}
		.redprice{
			width:60%;
		}
		.shop-cart .d-stock{
			width:100%;
		}
		.food_img_name{
			font-size: 13px;
    		font-weight: 400;
		}
		.tgf1-1 a {
		    font-size: 15px;
		}
		.line1>h1{
			font-size: 18px;
		    text-align: center;
		    font-weight: 400;
		    color: #fff;
		    font-family:Verdana, Arial, Helvetica, sans-serif;
		}
		.youhui{
			width:100%;
			padding:0;
			margin:0;
			border-top:none;
			height:30px;
			line-height:30px;
		}
		.weui-navbar{
			top:120px;
		}
		.back {
		    display: block;
		    width: 20px;
		    height: 30px;
		    line-height: 30px;
		    color: #fff;
		    float: left;
		    font-size: 20px;
		}
    </style>
</head>
<!-- #tab2,#tab3{
			margin-top: 40px;
		} -->
<body>
<div style="background: url('static/images/wm/beijing.png') no-repeat; position: fixed;top:0;left:0;z-index:100;width:100%;">
    <div class="line1">
        <!--<a class="icon1 iconfont icon-toLeft-copy" href="api/kehu/businessList.do?mkID=${mkID}&lat=${lat}&lng=${lng}&flag=${flag}"></a>-->
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <!-- <div class="headRight">
            <a href="javascript:void(0)" class="searchA">搜索商品</a>
        </div> -->
        <h1>${shangjiaData.shopName }</h1>
    </div>
    <%-- <div class="appmsg">
        <div class="weui-media-box__hd shop-top">
            <a href="javascript:void(0)"><img style="" class="weui-media-box__thumb" src="${shangjiaData.logoImg}" alt=""></a>
        </div>
        <div class="appmsg_m">
            <!-- <div class=" tgf1-1"><h5 style="font-weight: 500;"><a href="javascript:void(0)"></a></h5></div> -->
            <div class="info1 tgf1-1" ><a href="javascript:void(0)" style="font-size:11px;color:#ccc;display:block;height:16px;line-height:16px;"><i class="iconfont icon-shengyin" style="font-size:16px;float:left;"></i>${shangjiaData.shopNotice}</a></div>
             <c:if test="${shangjiaData.xyhliState=='1' && not empty shangjiaData.xyhli}">
           	<div style="color:#fff;padding-bottom: 0;height:20px;line-height:20px;">
                 <p style="font-size:12px;"><img alt="" src="static/images/wm/xin.png" style="height: 13px;width: 13px;">
                 	新用户立减${shangjiaData.xyhli}元
                 </p>
             </div>
             </c:if>
             <c:if test="${mjyhList.size()>0}">
      		<div class="youhui">
		        <i class="iconfont icon-lipin" style="float:left;font-size:16px;margin-left:-3px;"></i>
		        <div class="weui-flex__item myscroll" style="width:70%;margin:0;margin-top:5px;">
		            <ul>
		            	<c:forEach items="${mjyhList }" var="list">
		            		<li><a href="javascript:void(0);" style="color: #fff;">优惠活动满${list.man_num }减${list.jian_num } </a></li>
		            	</c:forEach>
		            </ul>
		        </div>
		    </div>
		    </c:if>
        </div>
        <div class="collection">
        	<c:if test="${shoucangs=='02'}">
        		<i style="color:#FFCE44;" onclick="shoucang('${shangjiaData.user_shangjia_id}')" class="icon-xing2 iconfont"></i>
        	</c:if>
        	<c:if test="${shoucangs=='01'}">
        		<i onclick="shoucang('${shangjiaData.user_shangjia_id}')" class="icon-xing iconfont"></i>
        	</c:if>
        	<c:if test="${empty shoucangs}">
        		<i onclick="shoucang('${shangjiaData.user_shangjia_id}')" class="icon-xing iconfont"></i>
        	</c:if>
            
            <p>收藏</p>
        </div>
    </div> --%>
    <%-- <div class="youhui">
        <i class="iconfont icon-lipin" style="margin-right: 10px;"></i>
        <div class="weui-flex__item myscroll">
            <ul>
            	<c:forEach items="${mjyhList }" var="list">
            		<li><a href="javascript:void(0);" style="color: #fff;">优惠活动${list.man_num }减${list.jian_num } </a></li>
            	</c:forEach>
            </ul>
        </div>

    </div> --%>
</div>
 		<!-- 点击照片显示店铺详情页-->
            <div id="food_img1" style="left: 20.7px;">
                <div id="fullbg1" class="fullbg" style="display: none;"></div>
                <div class="food_img_box pop1" style="display: none;height:100%;background: url('static/images/wm/beijing.png') no-repeat;background-size:cover;">
                    <i class="guanbi1"></i>
                    <div class="food_img_see " style="line-height:20px;border-bottom:1px solid #999;text-align: center;padding: 30px 10px;">
                        <img src="${shangjiaData.logoImg}" id="food_img_path" style="width: 60px; height: 60px;">
                        <p style="color: #fff;">${shangjiaData.shopName}</p><!--  | <span style="color: #fff;">39分钟</span> -->
                        <p><span style="color: #fff;">起送￥${shangjiaData.deliveryAmount}</span> | <span style="color: #fff;">配送 ￥${not empty freightList[0].cost?freightList[0].cost:0}起</span></p>
                        <p style="color: #fff;">配送时间：${shangjiaData.psTime}</p>
                    </div>
                    <c:if test="${mjyhList.size()>0}">
	                    <div style="color:#fff;padding: 10px;">
	                        <p><img alt="" src="static/images/wm/jian.png" style="height: 15px;width: 15px;">
	                        <c:forEach items="${mjyhList}" var="mj">
	                        		满${mj.man_num}减${mj.jian_num};
	                        </c:forEach>
	                        </p>
	                    </div>
                    </c:if>
                    <!-- 新用户优惠 -->
                    <c:if test="${shangjiaData.xyhliState=='1' && not empty shangjiaData.xyhli}">
                    <div style="color:#fff;padding:0 10px 10px;">
                        <p><img alt="" src="static/images/wm/xin.png" style="height: 15px;width: 15px;">
                        	新用户立减${shangjiaData.xyhli}元
                        </p>
                    </div>
					</c:if>
					<!-- 运费信息 -->
					<c:if test="${freightList.size()>0 }">
						<div style="color:#fff;padding:0 10px 10px;">
	                        <p style="height: 20px;font-size: 12px;">运费信息：</p>
	                        <c:forEach items="${freightList }" var="list" varStatus="va">
	                        	<c:if test="${freightList.size()!=va.index+1 }">
	                        		<p style="height: 20px;font-size: 12px;">配送距离为${list.distance1 }~${list.distance2 }米时, 运费${list.cost }元</p>
	                        	</c:if>
	                        	<c:if test="${freightList.size()==va.index+1 }">
	                        		<p style="height: 20px;font-size: 12px;">当配送距离大于${list.distance1 }米时,每增加${list.distance2 }千米,增加${list.cost }元运费</p>
	                        	</c:if>
	                        </c:forEach>
	                        <p style="height: 20px;font-size: 12px;">当货物总重量超过${weightBeyondPd.weight }kg时,每增加${weightBeyondPd.unit }kg,增加${weightBeyondPd.cost }元运费</p>
	                    </div>
                    </c:if>
					<!-- 商家公告 -->
                    <div id="food_detail" style="color: #fff;border-top:1px solid #999;padding: 10px;overflow-y: auto;line-height: 25px;"><p style="text-align: center;">商家公告</p>
                   	 ${shangjiaData.shopNotice }
                    </div>
                </div>
            </div>
<div class="weui-tab">
    <div class="weui-navbar">
	    <a tid="tab1" class="weui-navbar__item weui-bar__item--on" href="javascript:void(0);"> 购买</a>
	    <a tid="tab2" class="weui-navbar__item" href="javascript:void(0);">评价</a>
	    <a tid="tab3" class="weui-navbar__item" href="javascript:void(0);">店铺信息</a>
	    
    	<!--  
        <a class="weui-navbar__item weui-bar__item--on" href="#tab1">
            购买
        </a>
        <a class="weui-navbar__item" href="#tab2">
           评价
        </a>
        <a class="weui-navbar__item" href="#tab3">
            店铺信息
        </a>
        -->
    </div>
    <div class="weui-tab__bd">
    	<input type="hidden" value="${user_shangjia_id}"  id="user_shangjia_id" name="user_shangjia_id"/>
        <!-- 购买-->
        <div id="tab1"  class="weui-tab__bd-item weui-tab__bd-item--active">
            <div class="ovh" >
                <div  class="bgf4" style="overflow: auto">
                    <div class="gundLeft">
                        <ul id="food_sort">
                          <c:forEach items="${goodsCategoryList}" var="clist" varStatus="vs">
                            <li class="foodsort"><a data-tpye="#st${vs.index+1 }" class="" >${clist.categoryName}</a>
                                <span class="res_sort_num">0</span>
                            </li>
                           </c:forEach>
                        </ul>
                    </div>
                </div>
                <div id="scroll_food" class="right" style="width:75%;overflow:auto;background-color: #fff;">
                    <div id="food_img_list" class="bgf">
                        <c:forEach items="${goodsList}" var="good" varStatus="vs">
                         <h6 class="foodlist_label">${good[0].categoryName}</h6>
                        <div class="foodlist_box" id="st${vs.index+1}">
                         <c:forEach items="${good}" var="good">
                            <ul>
                                <li>
                                    <div class="img_list_box" tid="${good.goods_id}">
                                        <img  class="img_list_img" src="${good.goodsImg }" >
                                    </div>
                                    <div class="shop_style">
                                        <h3 class="food_img_name">${good.goodsName }</h3>
                                        <p class="font12 clo9">月销量：${good.goodsNums }</p><!--无大小份-->
                                        <p class="img_list_info">${good.goodsIntroduce }</p>
                                        <div class="weui-flex" style="line-height:30px;">
                                            <div class="weui-flex__item redprice" >
                                                ¥<span class="price" style="font-size: 14px;">${good.presentPrice }</span>
                                                <!-- text-decoration: line-through; -->
                                                <span style="font-size: 12px;color:#ccc;">&nbsp;${good.originalPrice }kg</span>
                                               <!--  <span class="copies">(150kg/份)</span> -->
                                            </div>
                                            <div class="weui-flex__item shop-cart">
                                                <div class="d-stock">
                                                    <a class="minus decrease" onclick="reduce('${good.goods_id}','${good.goodsName }','${good.presentPrice }','${good.canhefei }','${good.originalPrice }',this)">-</a>
                                                    <input id="num" class="result text_box" type="text" value="0">
                                                    <a class="increase" onclick="addCar('${good.goods_id}','${good.goodsName }','${good.presentPrice }','${good.canhefei }','${good.originalPrice }',this)">+</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                              </c:forEach> 
                            </ul>
                        </div>
                       </c:forEach>
                    </div>
                </div>
            </div>
            <!--底部-->
            <div class="mask"></div>
            <div class="gouwuche">
                <div class="first1"><span class="ydsp">已点商品</span><span class="clearB">清空购物车</span></div>
               <!--  <div class="d-stock">
                    <span>烧腊卤肉饭</span>
                    <span class="danjia" >15</span>
                        <span style="display: inline-block;">
                            <a class="jian1">-</a>
                            <input   type="text" value="1" class="int" style="width:15px;border:none;outline: none;">
                            <a  class="jia1">+</a>
                        </span>
                </div> -->
              
            </div>
            <div class="tqfooter">
                <div class="ft-lt">
                    <div class="cart">
                        <a class="nm" href="javascript:void(0);">
                            <div class="cart-num"></div>
                        </a>
                    </div>
                    <div class="price plet" >
                        <div class="peis" style="display: none;font-size: 18px;margin-top: 4px;">
                            <span style="color: white;">￥</span>
                            <span id="total" class="total" style="color: white;"></span>
                        </div>
                        <p class="font6">另需配送费￥<span class="share">${shangjiaData.psCost}</span></p>
                    </div>
                </div>
                <div class="ft"  style="display: block;background-color: #ddd;">
                    <%--<p><a id="jiesuan" href="javascript:void(0)" onclick="goTotol()">去结算</a></p>--%><!-- by yym -->
                    <p><a id="jiesuan" href="javascript:void(0)">${shangjiaData.deliveryAmount}元起送</a></p><!-- by zjh 2017-9-4 08:55:15 -->
                </div>
            </div>
            <!-- 商家公告栏-->
           
        </div>
        <!-- 评价-->
        <div id="tab2"  class="weui-tab__bd-item">
            <div class="assess">
         
                <div class="assess_top">
                    <ul class="assess_mi">
                        <li class="assess_info hover">全部(${evaluateList.size()})</li>
	                    <c:forEach items="${sysLabelList}" var="list" varStatus="va">
				        	<li class="assess_info" tid="${list.label_id}">${list.labelName}(${list.num})</li>
		        		</c:forEach>
                    </ul>
                </div>
                <!--顾客评论区  -->
                <div id="plContent">
	                
                </div>
            </div>
        </div>
        <!-- 商家店铺-->
        <div id="tab3"  class="weui-tab__bd-item">
            <div class="conter">
                <div class="weui-cells" style="margin-bottom:15px;">
                    <div class="weui-cell weui-cell_access"  >
                        <div class="weui-cell__hd">
                            <img src="static/images/wm/location1.png" style="margin-bottom: 2px;margin-right: 5px;vertical-align: middle;width:20px; height: 20px;"/>
                        </div>
                        <div class="weui-cell__bd1" style="width: 82%;">${shangjiaData.address }</div>
                       	<a class="weui-cell__rt " href="tel:${shangjiaData.tel_phone }">
                            <img src="static/images/wm/phone1.png" style="margin-bottom: 2px;margin-right: 5px;vertical-align: middle;width:20px; height: 20px;">
                        </a>
                    </div>
                    <div class="weui-cell weui-cell_access"  >
                        <div class="weui-cell__hd">
                            <img src="static/images/wm/time.png" style="margin-bottom: 2px;margin-right: 5px;vertical-align: middle;width:20px; height: 20px;"/>
                        </div>
                        <div class="weui-cell__bd">配送时间：${shangjiaData.psTime}</div>
                    </div>
                </div>
                <div class="weui-cells" style="margin-bottom:15px;">
                    <div class="weui-cell weui-cell_access"  >
                        <div class="weui-cell__hd">
                            <img src="static/images/wm/sound.png" style="margin-bottom: 2px;margin-right: 5px;vertical-align: middle;width:20px; height: 20px;"/>
                        </div>
                        <div class="weui-cell__bd">${shangjiaData.shopNotice}</div>
                    </div>
                    <div class="weui-cell weui-cell_access"  >
                        <div class="weui-cell__hd">
                            <img src="static/images/wm/gif.png" style="margin-bottom: 2px;margin-right: 5px;vertical-align: middle;width:20px; height: 20px;"/>
                        </div>
                        <div class="weui-cell__bd">
                        	   <c:forEach items="${mjyhList}" var="mj">
	                        		满${mj.man_num}减${mj.jian_num};
	                          </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
         <!-- 点击商品照片显示商品详情页-->
            <div id="food_img" style="left: 20.7px;">
                <div id="fullbg" class="fullbg" style="display: none;"></div>
                <div class="food_img_box2 pop1" style="display: none;">
                    <i class="guanbi2"></i>
                    <p class="food_img_see " style="width: 100%;height: 300px;">
                        <img id="food_img_path2" src="111" style="width: 100%; height: 100%;">
                    </p>
                    <div style="background-color: #fff;padding: 10px;padding-bottom: 0;">
                        <div id="cainame2" class=" font16">老盐柠檬</div>
                        <!-- <div id="img_list_price_box" style="color: #AEAEAE;font-size: 13px;margin-top: 5px">月售 448</div> -->
                        <p id="food_desc" style="color: #FC665D;font-size: 18px;margin-top: 5px">12</p>
                    </div>

                    <div id="food_detail2" style="margin-top: 5px;background-color: #fff;padding: 10px;overflow-y: auto;line-height: 25px;">宝贝详情请以实物为准宝贝情请以实物为准宝贝详情请以物为准宝贝详情请以实物实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准宝贝详情请以实物为准</div>
                </div>
           </div>
        
    </div>
</div>
<script>

$(function(){
	$(".pop1").height($(window).height());
});

    $(".img_list_box img").click(function(e){
        event.stopPropagation();
        $(".food_img_box2").show();
      
      /*   $(document).click(function(event){
            var _con = $('.food_img_box');   // 设置目标区域
            if(!_con.is(event.target) && _con.has(event.target).length === 0){ // Mark 1
                $('.food_img_box').fadeOut();//淡出消失

            }
        }); */
            $.post('api/kehu/getGoodDetailByID.do',{good_id:$(this).parent().attr("tid")},function(data){
	        	$("#food_img_path2").attr("src",data.rpd.goodsImg);
	        	$("#cainame2").text(data.rpd.goodsName);
	        	$("#food_desc").text("￥"+data.rpd.presentPrice);
	        	$("#food_detail2").text(data.rpd.goodsIntroduce);
	        });

    });
    
      //详情卡关闭
        $(".food_img_box2 .guanbi2").click(function(){
            $(".food_img_box2").fadeOut();
	      
        });
        
	        
    //点击查看商家详情
    $(".appmsg_m").click(function(e){
        event.stopPropagation();
        $(".food_img_box").show();
        
       /*  $(document).click(function(event){
            var _con = $('.food_img_box');   // 设置目标区域
            if(!_con.is(event.target) && _con.has(event.target).length === 0){ // Mark 1
                $('.food_img_box').fadeOut();//淡出消失

            }
        });
 */
    });
    
      //店铺详情卡关闭
       $(".food_img_box .guanbi1").click(function(){
           $(".food_img_box").fadeOut();
       });
        
    //点击商家头像查看商家详情
    $(".shop-top").click(function(e){
        event.stopPropagation();
        $(".food_img_box").show();
        //详情卡关闭
        $(".food_img_box .guanbi1").click(function(){
            $(".food_img_box").fadeOut();
        });
        
        $(document).click(function(event){
            var _con = $('.food_img_box');   // 设置目标区域
            if(!_con.is(event.target) && _con.has(event.target).length === 0){ // Mark 1
                $('.food_img_box').fadeOut();//淡出消失

            }
        });

    });
</script>
<script>
	$(function(){
		//购买、评价、店铺信息切换
		$(".weui-navbar>a").click(function(){
			if(!$(this).hasClass("weui-bar__item--on")){
				$(this).siblings().removeClass("weui-bar__item--on");
				$(this).addClass("weui-bar__item--on");
				var id=$(this).attr("tid");
				$("#"+id).siblings().removeClass("weui-tab__bd-item--active");
				$("#"+id).addClass("weui-tab__bd-item--active");
			}
		});
		
		//评价部分标签切换
	    $(".assess_mi li").click(function(){
	    	$(this).addClass("hover").siblings().removeClass("hover");
	    	getEvaluateListOfShangJia($(this).attr("tid"));
	    });
	    getEvaluateListOfShangJia("1");
	});
	
	//根据标签ID获取对应标签下的所有评论
	function getEvaluateListOfShangJia(id){
		var str="";
		if(id=="1"){
			id="";
		}
		$.post('api/kehu/getEvaluateListOfShangJia.do',{user_shangjia_id:"${user_shangjia_id}",label_id:id},function(data){
			$.each(data.evaluateList,function(){
				str+='<div class="assess_bot">';
				str+='<div class="eval">';
				str+='<div class="eval_lf"><img src="'+this.headImg+'"/></div>';
				str+='<div class="eval_rt">';
				str+='<div class="eval_rt_top">';
				str+='<div class="eval_rt_top_lf">'+this.userName+'</div>';
				str+='<div class="eval_rt_top_rt">'+this.time.substr(0,10)+'</div></div>';
				str+='<div class="comment1">';
				str+='<div class="score" >打分</div>';
				str+='<div class="comment" style="float:left;">';
				if(this.score=="0"){
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="0.5"){
					str+='<img src="static/images/wm/banxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="1"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="1.5"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/banxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="2"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="2.5"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/banxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="3"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="3.5"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/banxing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="4"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/huixingxing.png" alt=""/>';
				}else if(this.score=="4.5"){
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/banxing.png" alt=""/>';
				}else {
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
					str+='<img src="static/images/wm/xing.png" alt=""/>';
				}
				str+='</div></div>';
				str+='<div class="eval_rt_info">'+this.content+'</div>';
				/*
					<!--  
                    <div class="eval_rt_Img">
                        <div class="eval_rt_img">
                            <img  src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                        <div class="eval_rt_img">
                            <img src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                        <div class="eval_rt_img">
                            <img src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                        <div class="eval_rt_img">
                            <img src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                        <div class="eval_rt_img">
                            <img src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                        <div class="eval_rt_img">
                            <img src="http://fuss10.elemecdn.com/c/cd/c12745ed8a5171e13b427dbc39401jpeg.jpeg?imagediv2/1/w/114/h/114"/>
                        </div>
                    </div>
                    -->
				*/
				str+='<div class="eval_rt_log">'+this.labelNames+'</div>';
				str+='</div></div></div>';
			});
			$("#plContent").html(str);
		});
	}
</script>
<script>
    $(function(){
        $(".bgf4").height($(window).height()-244);
        $("#scroll_food").height($(window).height()-244);
        $("#food_sort").find("li:first-child").addClass("hover");
        $("#food_sort").find("li:first-child>a").addClass("curr");
    })
</script>
<script>
    $(function () {
        FastClick.attach(document.body);
        /*商品详情页*/
        $("#food_detail").height($(window).height()-432);
        /*文字滚动*/
        $('.myscroll').liMarquee({
            direction: 'up',
            loop:222

        });
        /*收藏*/
      /*   $(".collection i").click(function(){
            if($(this).hasClass('light')){
                $(this).removeClass('light');
                $(this).addClass('icon-xing');
                $(this).removeClass('icon-xing2');
                $(this).css('color','#fff');
                layer.msg('取消收藏',{
                    time:1500//单位毫秒
                });
            }else{
                $(this).addClass('light');
                $(this).removeClass('icon-xing');
                $(this).addClass('icon-xing2');
                $(this).css('color','#FFCE44');
                layer.msg('收藏成功',{
                    time:1500//单位毫秒
                });

            }
        }) */
        /*var shoucangss = "${shoucangs}"; 
        if(shoucangss == "02"){
			$(".collection i").addClass('icon-xing2');
            $(".collection i").removeClass('icon-xing');
            $(".collection i").css('color','#FFCE44');
		}*/
    });
    function shoucang(id){
    	var mkID = "${mkID}";
		var url = 'api/kehu/insertShouCang.do';
	 	$.ajax({
			url:url,
			type:"post",
			data:{
	   			"user_shangjia_id":id,
	   			"mkID":mkID
	   		},
	   		dataType:"json",
			success:function(data){
				console.log(data.respCode);
				if(data.respCode=="01"){
	                $(".collection i").removeClass('icon-xing');
	                $(".collection i").addClass('icon-xing2');
	                $(".collection i").css('color','#FFCE44');
	                layer.msg('收藏成功',{
	                    time:1500//单位毫秒
	                });
				}else if(data.respCode=="03"){
	                $(".collection i").addClass('icon-xing');
	                $(".collection i").removeClass('icon-xing2');
	                $(".collection i").css('color','#fff');
	                layer.msg('取消收藏',{
	                    time:1500//单位毫秒
	                });
	             	   
				}else{
					window.location.href="api/kehu/toLogin.do";
				}
			}
		});
	}
</script>
</script>
<script type="text/javascript">
//清除订单缓存信息  by zjh 2017-9-4 17:31:59
var zjhid="${h5User.user_kehu_id}";
if(zjhid!=""){
	$.post('api/kehu/clearCar',{},function(data){
		console.log("清除成功");
	});
		
}

//by yym 数组集合操作+
    var map=new Map();
	function Map() { 
	//创建map结构
	var struct = function(key, value) { 
		this.key = key; 
		this.value = value; 
	};
	
	var put = function(key, value){ 
	for (var i = 0; i < this.arr.length; i++){ 
		if (this.arr[i].key === key ) {
			this.arr[i].value = value; 
			return; 
		} 
	} 
		this.arr[this.arr.length] = new struct(key, value); 
	}; 
	
	var get = function(key) { 
	for (var i = 0; i < this.arr.length; i++) { 
		if ( this.arr[i].key === key ) { 
			return this.arr[i].value; 
		} 
	} 
		return null; 
	};
	
	
	var remove = function(key) { 
	var v; 
	for (var i = 0; i < this.arr.length; i++) { 
		//从尾部删除并返回删除的元素
		v = this.arr.pop(); 
		if (v.key === key ){ 
				continue; 
		} 
		this.arr.unshift(v); 
		
		} 
	};
	
	//移除
	/*var remove = function(key) { 
		var v; 
		var res;
		var lastNum;
		var endStr="";
		for (var i = 0; i < this.arr.length; i++){ 
			//从尾部删除并返回删除的元素
			v = this.arr.pop(); 
			if (v.key === key ){ 
				console.log("开始的结果是："+v.value)
				res = v.value.split(",");
				lastNum = res[(res.length-1)];
				if(parseInt(lastNum)==1){
				alert(1)
					continue; 
					this.arr.unshift(v); 
				}else{
					alert(11)
					var newNum = lastNum-1;
					endStr= res[0]+","+res[1]+","+res[2]+","+newNum;
					break;
				}
				
			} 
			
		} 
		alert(444)
		console.log("endStr是："+endStr)
		return endStr;
	}; */
	
	//得到集合的长度
	var size = function() { 
		return this.arr.length; 
	}; 
	
	//清空
	var isEmpty = function() { 
		return this.arr.length <= 0; 
	}; 
	this.arr = new Array(); 
	this.get = get; 
	this.put = put; 
	this.remove = remove; 
	this.size = size; 
	this.isEmpty = isEmpty; 
	}
</script>
<script type="text/javascript">
	/* var map=new Map();
	map.put('h','hello');
	map.put('hw','world');
	console.log(map);
	var r1 = map.get('h');
	console.log(r1); */
</script>
<script>

    $(function(){

        /*购物车增加*/
     /*    $(".increase").click(function(){
            var add=$(this).parent().find(".text_box").val();
            add++;
            if(add>0){
                $(this).parent().find(".minus").fadeIn();
                $(this).parent().find(".text_box").fadeIn();
            }
            $(this).parent().find(".text_box").val(add);
            Total();
        }); */
        /*购物车减少*/
    /*     $(".minus").click(function(){
            var reduce=$(this).parent().find(".text_box").val();
            if(reduce>1){
                reduce--;
                $(this).parent().find(".text_box").val( reduce)
            }else{
                $(this).fadeOut();
                $(this).parent().find(".text_box").fadeOut();
                $(this).parent().find(".text_box").val(0);
                $("#total").html("");
            }
            Total();
        }); */
        
    });
    
    //购物车减
    function reduce(id,name,presentPrice,canhefei,weight,e1){
            var reduce=$(e1).parent().find(".text_box").val();
            if(reduce>1){
                reduce--;
                $(e1).parent().find(".text_box").val(reduce)
            }else{
                $(e1).fadeOut();
                $(e1).parent().find(".text_box").fadeOut();
                $(e1).parent().find(".text_box").val(0);
                $("#total").html("");
            }
            Total();
            //添加到集合中
	        var num=$(e1).parent().find(".text_box").val();//数量
	    	var myValues = name+","+presentPrice+","+canhefei+","+num+","+weight;
	    	num=parseInt(num)+1;
	    	if(parseInt(num)==1){
	    		map.remove(id);
	    	}else{
	    		map.remove(id);
	    		var newNum = parseInt(num)-1;
	    		var myValues = name+","+presentPrice+","+canhefei+","+newNum+","+weight;
	    		map.put(id,myValues);
	    	}
	    	console.log(map)
        }
    //购物车加
    function addCar(id,name,presentPrice,canhefei,weight,e1){
       		var add=$(e1).parent().find(".text_box").val();
            add++;
            if(add>0){
                $(e1).parent().find(".minus").fadeIn();
                $(e1).parent().find(".text_box").fadeIn();
            }
            $(e1).parent().find(".text_box").val(add);
            Total();
	        //添加到集合中
	        var num=$(e1).parent().find(".text_box").val();//数量
	    	var myValues = name+","+presentPrice+","+canhefei+","+num+","+weight;
	    	map.put(id,myValues);
	    	console.log(map)
    
    	}
    	
    	//去结算
    	function goTotol(){
    	 var user_shangjia_id = $("#user_shangjia_id").val();
    	 var lat = "${lat}";
    	 var lng = "${lng}";
			 $.post('api/kehu/saveOrderTemp.do',
           {
	           user_shangjia_id:user_shangjia_id,
	           map:map.arr,
	           mkID:"${mkID}"
           },function(data){
           		console.log(data);
           		if(data.respCode=="01"){
           			window.location.href="api/kehu/orderPay.do?user_shangjia_id="+user_shangjia_id+"&lat="+lat+"&lng="+lng;
           		}else{
           			//未登录
           			window.location.href="api/kehu/toLogin.do";
           		}
           }); 
    	}
    	
    
    
     	//计算合计
        function Total(){
            var price=0;
            $(".shop-cart").each(function(){
                price += parseInt($(this).find('input[class*=result]').val()) * parseFloat($(this).siblings().find('span[class*=price]').text());
               // console.log(price)
            });
          /*   var n=0;
            var nIn = $("li.foodsort a.curr").attr("data-tpye");
            $(nIn + " input[class*=result]").each(function () {
                n+=parseInt($(this).val());
                if (n > 0) {
                    $(".curr").next().html(n).show();
                } else {
                    $(".curr").next().hide();
                }
            });
 */

            var num=0;
            $(".text_box").each(function(){
                num+=parseInt($(this).val());
            });
            if(num>0){
                $(".ft-lt").css("width","75%");
                $(".ft-rt").fadeIn();
                $(".ft").fadeIn();
                $(".font6").css("margin-top","-1px");
                $(".font6").css("font-size","10px");
                $(".peis").fadeIn();
                $(".cart-num").fadeIn().html(num);
            }else{
                $(".ft-lt").css("width","100%");
                $(".ft-rt").fadeOut();
                //$(".ft").fadeOut();//by zjh 注释 2017-9-4 09:52:07
                $(".font6").css("margin-top","13px").fadeIn();
                $(".font6").css("font-size","16px");
                $(".peis").fadeOut();
                $(".cart-num").fadeOut().html("");
            }

            $("#total").html(price.toFixed(2));
            
            //商家起送金额//by zjh 添加 2017-9-4 09:52:07
            var deliveryAmount="${shangjiaData.deliveryAmount}";
            if(price>deliveryAmount){
            	$(".ft").css("background-color","#43E365");
            	$(".ft").attr("onclick","goTotol()");
            	$("#jiesuan").html("去结算");
            }else{
            	$(".ft").css("background-color","#ddd");
            	$(".ft").attr("onclick","");
            	if(price==0){
                    //$(".ft").css("display","block");
                    $(".ft-lt").css("width","75%");
                    $(".ft").fadeIn();
            		$("#jiesuan").html(deliveryAmount+"元起送");
            	}else{
            		var temp=deliveryAmount-price;
                	$("#jiesuan").html("还差    "+temp);
            	}
            }
        }
    
    
</script>
<script type="text/javascript">
    var a=$('[id^="st"]');
    var arr1=[];
    var arr=[];
    var hei=$('body>div:first-child').height();
    for(var i=0;i<a.length;i++){
        var l=$(a[i]).offset().top;
        arr1.push(l);
        var m=$(a[i]).position().top;
        arr.push(m);
    }
    $('li.foodsort').click(function(){
        $('#scroll_food').scrollTop(arr[$(this).index()]);
        $(this).addClass('hover').siblings().removeClass('hover');
        $(this).find("a").addClass('curr').parent().siblings().find("a").removeClass('curr');
    });
 /*   $("#scroll_food").scroll(function(){
        var n=$(this).scrollTop();
        for(var i=0;i< a.length;i++){
            if(n>arr1[i]-hei&&n<arr1[i+1]-hei){
                if(n>arr1[arr1.length-2]-10&&n<arr1[arr1.length-1]){
                    $('.foodsort:last-child').addClass('hover').siblings().removeClass('hover');
                    $('.foodsort:last-child').find("a").addClass('curr').parent().siblings().find("a").removeClass('curr');
                }else{
                    $('.foodsort').eq(i).addClass('hover').siblings().removeClass('hover');
                    $('.foodsort').eq(i).find("a").addClass('curr').parent().siblings().find("a").removeClass('curr');
                }
            }
        }
    });*/
</script>
<script>
		 //加
 	/* 	 $(".jia1").click(function(){
				alert(111)
                var jia=$(this).prev().val();
                jia++;
                $(this).prev().val(jia);
                total();
            }); */
            
            //减
             /*  $(".jian1").click(function(){
               var jian=$(this).next().val();
               if($(this).next().val()>1){
                   jian--;
                   $(this).next().val(jian);
               }else{
                   $(this).parent().parent().remove();
                   $(".d-stock input").each(function(){
                       if($(this).val()==0){
                           $(".mask").fadeOut();
                           $(".gouwuche").hide();

                       }else{
                           $(".mask").fadeIn();
                           $(".gouwuche").show();
                       }
                   })
               }
               total();

           }); */
           
          //清空购物车
           $(".clearB").click(function(){
            $(".gouwuche").hide();
            $(".mask").fadeOut();
            //rr();
            //total();
            //by zjh 注释 2017-9-4 09:52:07
            location.href=location.href;
          });
          
          function rr(){
          	   	console.log(map.arr.length)
            for(var i=0;i<map.arr.length;i++){
            	map.remove(map.arr[i].key);
            	map.arr.length--;
            }
          }
          
         //点击购物车图标68551779
    $(".cart").click(function(){
        event.stopPropagation();
        if($(".gouwuche").is(":hidden")){
            $(".mask").show();
            //slideDown();
            $(".gouwuche").show();
            renderGouwuche();
        }else{
            $(".mask").hide();
            $(".gouwuche").hide();
        }
        
    });
    
    //js渲染购物车
    function renderGouwuche(){
     	$("div.gouwuche *").not(".first1").not(".ydsp").not(".clearB").each(function() { // "*"表示div.gouwuche下的所有元素
          		  $(this).remove();
       		 });
            for(var i=0;i<map.arr.length;i++){
           		var id = map.arr[i].key;
           	 	var rsArr = map.arr[i].value.split(",");
           	 	
           	 	//rsArr[0]=商品名字 rsArr[1]=价格，2=餐盒费 3=数量
           	 	for(var y=0;y<1;y++){
           	 		 var appendHtml = '<div class="d-stock">';
		   			 appendHtml+='<span>'+rsArr[0]+'</span>';
		   			 appendHtml+='<span class="danjia">￥'+rsArr[1]+'</span>';
		   			 appendHtml+='<span class="d-stock" style="display: inline-block;">';
		   			 appendHtml+='<a class="jian1" onclick="jianjian(\''+id+'\',\''+rsArr[0]+'\',\''+rsArr[1]+'\',\''+rsArr[2]+'\',\''+rsArr[3]+'\',\''+rsArr[4]+'\')">-</a>';
		   			 appendHtml+='<input type="text" class="num" value="'+rsArr[3]+'" style="width:15px;border:none;outline: none;">';
		   			 appendHtml+='<a class="jia1" onclick="jiajia(\''+id+'\',\''+rsArr[0]+'\',\''+rsArr[1]+'\',\''+rsArr[2]+'\',\''+rsArr[3]+'\',\''+rsArr[4]+'\')">+</a>';
		   			 appendHtml+='</span></div>';
           			 $(".first1").after(appendHtml);
           	 	}
            	
            } 
    
    }
   
      /*   $(document).click(function(event){
            var _con = $('.gouwuche');   // 设置目标区域
            if(!_con.is(event.target) && _con.has(event.target).length === 0){ // Mark 1

                $(".mask").fadeOut();
                $(".gouwuche").slideUp();
            }
        }); */
    
        
        //购物车减
    	function jianjian(id,name,price,canhefei,num,weight){
    		if(parseInt(num)==1){
	    		map.remove(id);
	    		renderGouwuche();
	    		total();
	    	}else{
	    		map.remove(id);
	    		var newNum = parseInt(num)-1;
	    		var myValues = name+","+price+","+canhefei+","+newNum+","+weight;
	    		map.put(id,myValues);
	    		renderGouwuche();
	    		total();
	    	}
	    	   var sname =name;
	    	  //--------------查找原来所有的物品 改变上边物品的数量begin-----------// 
			    var all = $(".foodlist_box .shop_style");
				for(var i=0;i<all.length;i++){
					//console.log(all.eq(i).find("h3").html());
					if(all.eq(i).find("h3").html()==sname){
						//console.log(all.eq(i).find(".shop-cart").find(".text_box").val())
						var num = all.eq(i).find(".shop-cart").find(".text_box").val();
						num--;
						//alert(num)
						all.eq(i).find(".shop-cart").find(".text_box").val(num)
						if(num==0){
							all.eq(i).find(".shop-cart").find(".text_box").hide();
							all.eq(i).find(".shop-cart").find(".text_box").parent().find(".decrease").hide();
						}
					}
				}
			 //--------------查找原来所有的物品 改变上边物品的数量end-----------// 
      		
      	}
        
        //购物车加
         function jiajia(id,name,price,canhefei,num,weight){
        	num= parseInt(num)+1;
        	var myvalues = name+","+price+","+canhefei+","+num+","+weight; 
        	map.put(id,myvalues);
        	renderGouwuche();
        	total();
        	var sname =name;
      		//--------------查找原来所有的物品 改变上边物品的数量begin-----------// 
			    var all = $(".foodlist_box .shop_style");
				for(var i=0;i<all.length;i++){
					//console.log(all.eq(i).find("h3").html());
					if(all.eq(i).find("h3").html()==sname){
						//console.log(all.eq(i).find(".shop-cart").find(".text_box").val())
						var num = all.eq(i).find(".shop-cart").find(".text_box").val();
						num++;
						//alert(num)
						all.eq(i).find(".shop-cart").find(".text_box").val(num)
					}
				} 
			 //--------------查找原来所有的物品 改变上边物品的数量end-----------// 
        }
        
        
        //计算购物车合计
        function total(){
            var price=0;
            var carNum = 0;
            for(var i=0;i<map.arr.length;i++){
       	 		var rsArr = map.arr[i].value.split(",");
       	 		//rsArr[0]=商品名字 rsArr[1]=价格，2=餐盒费 3=数量
        	 	for(var y=0;y<1;y++){
        	 		price+= rsArr[1]*rsArr[3];
        	 		carNum = parseInt(carNum)+parseInt(rsArr[3]);
        	 	}
       	 	}
            if(price.toFixed(2)==0){
            	$(".ft-lt").css("width","100%");
                $(".ft-rt").fadeOut();
                //$(".ft").fadeOut();//by zjh 注释 2017-9-4 09:52:07
                $(".font6").css("margin-top","13px").fadeIn();
                $(".font6").css("font-size","16px");
                $(".peis").fadeOut();
                $(".cart-num").fadeOut().html("");
            }else{
            	$(".cart-num").fadeIn().html(carNum);
            	$("#total").html(price.toFixed(2));
            }
          	//商家起送金额//by zjh 添加 2017-9-4 09:52:07
            var deliveryAmount="${shangjiaData.deliveryAmount}";
            if(price>deliveryAmount){
            	$(".ft").css("background-color","#43E365");
            	$(".ft").attr("onclick","goTotol()");
            	$("#jiesuan").html("去结算");
            }else{
            	$(".ft").css("background-color","#ddd");
            	$(".ft").attr("onclick","");
            	if(price==0){
                    //$(".gouwuche").css("display","none");
                    $(".mask").hide();
            		$(".gouwuche").hide();
                    $(".ft-lt").css("width","75%");
                    $(".ft").fadeIn();
            		$("#jiesuan").html(deliveryAmount+"元起送");
            	}else{
            		var temp=deliveryAmount-price;
                	$("#jiesuan").html("还差    "+temp);
            	}
            }
            
        }
</script>
</body>
</html>