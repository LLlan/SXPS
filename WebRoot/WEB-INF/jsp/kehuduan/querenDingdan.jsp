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
    <script src="static/js/layer/mobile/layer.js"></script>

    <title>确认订单</title>
    <style>
        #mobile{
            width:65px;
            color:#0283fb;
            font-size:16px;
            float:right;
            text-align:right;
            height:46px;
            line-height:46px;
            color:#0283fc;
        }
        .toolbar .toolbar-inner{
            height:40px;
        }
        .toolbar .picker-button{
            height:40px;
            line-height: 40px;
            font-size:16px;
        }
        .toolbar .title{
            height:40px;
            line-height: 40px;
            font-size:16px;
        }
        .weui-picker-modal{
            height:250px;
        }
        .weui-picker-modal .picker-modal-inner{
            height:150px;
        }
        .weui-picker-modal .picker-items{
        	font-size:14px;
        }
        .cart {
            background: url(static/images/wm/gouwuche22.png) no-repeat;
            background-size: 30px 30px;
        }
        .tqfooter{
            background-color: #303030;
        }
        .tqfooter .ft-lt{
            width:75%;
            float: left;
        }
        .ft{
            width:25%;
            height:50px;
            text-align: center;
            line-height: 50px;
            color:#fff;
            background-color: #43E365;
            font-size: 16px;;
        }
        .ft>p>a{
            font-size:16px;;
            color:#fff;
        }
        .tqfooter .ft{
            float: right;
        }
        .plet{
            height:50px;
            margin-left:0;
            padding-left:20px;
        }
        .total{
            font-size: 14px;
        }
        .liuyan>textarea {
		    line-height: 25px;
		    height: 95px;
		}
		.ciaming {
		    font-size: 15px;
		}
		.plet {
		 font-size: 12px;
		}
		.liuyanDiv {
		    height: 100px;
		}
		.plet {
		    line-height: 45px;
		}
		.nulldizhi{
			margin-top: 25px;
			margin-left: 20px;
		}
		.dizhiDiv {
		   /*  margin-top: -10px; */
		}
		.liuyan>textarea {
	    	color: #333;
		}
		#peisonTime {
		    width: 65px;
		    font-size: 16px;
		    float: right;
		    text-align: right;
		    height: 46px;
		    line-height: 46px;
		    color: #0283fc;
		}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
    <!-- api/kehu/delTempOrder.do?user_shangjia_id=${user_shangjia_id}&mkID=${resultList[0].mkID} -->
        <a href="javascript:window.history.back(-1);" class="iconfont icon-toLeft-copy back"></a>
        <h1>确认订单</h1>
    </div>
</header>
<!-- 隐藏域传值 -->
<!-- 是否是默认地址 -->
<input type="hidden" id="isdefault" value="${dizhiData.linkmanName}">
<!-- 商家主键id -->
<input type="hidden" id="user_shangjia_id" value="${user_shangjia_id}">
<!-- 配送费 -->
<input type="hidden" id="psCost" value="${shangjiaData.psCost}">
<!-- 收货地址id -->
<input type="hidden" id="shouhuo_address_id" value="${dizhiData.shouhuo_address_id}">

<div class="contentDiv">
    <div class="dizhiDiv" onclick="getAddressList('${user_shangjia_id}')">
      <c:if test="${dizhiData==''|| empty dizhiData}">
      	    <div class="dizhiLeft">
                <p class="nulldizhi">您还未设置默认收货地址</p>  
	        </div>
	        <div class="dizhiRight">
	            <p><a href="javascript:void(0)" class="iconfont icon-jiantou-copy"></a></p>
	        </div>
      </c:if>
       <c:if test="${dizhiData!=''|| not empty dizhiData}">
	        <div class="dizhiLeft">
	            <p class="line1" style="height: 20px;"><span>${dizhiData.linkmanName }</span><span>${dizhiData.phone }</span><span>${dizhiData.identity}</span></p>  
	            <p class="line2"><span>${dizhiData.lable }</span>${dizhiData.address } ${dizhiData.detailAddress }</p>
	        </div>
	        <div class="dizhiRight">
	            <p><a href="javascript:void(0)" class="iconfont icon-jiantou-copy"></a></p>
	        </div>
        </c:if>
    </div>
    <div class="shijian">
        <span>送达时间</span>
        <!--<a href="javascript:void(0)" id="peisonTime" class="shijianA">选择配送时间</a>-->
        <input id="peisonTime" class="shijianA" value="立即送出">
    </div>
    <div class="shijian">
        <span>配送方式</span>
        <input id="mobile" class="shijianA" value="商家配送">
        <input type="hidden" id="mobile1" value="商家配送">
    </div>
  <!--   <div class="shijian">
        <span>优惠券</span>
        <a href="javascript:void(0)" class="youhuiquanA">暂无可用</a>
    </div> -->
    <div class="yixuanDiv">
        <p class="yixuanHead"><span>已选商品</span></p>
        <c:forEach items="${resultList}" var="rs">
        <p class="luroufan">
            <span class="ciaming">${rs.name }</span>
            <span class="shuliang">x${rs.num }</span>
            <span class="jiage">￥${rs.price }</span>
        </p>
       </c:forEach>
       <!--  
       <p class="luroufan">
            <span class="ciaming">包装费</span>
            <span class="shuliang"></span>
            <span class="jiage">￥${totolData.canhefei }</span>
        </p>
        -->
        <c:if test="${shangjiaData.psCost!='' && shangjiaData.psCost!=null}">
	        <p class="luroufan" id="psf">
	            <span class="ciaming">配送费</span>
	            <span class="shuliang"></span>
	            <span class="jiage">￥${shangjiaData.psCost}</span>
	        </p>
        </c:if>
    </div>
    <!-- 满减优惠 -->
    <c:if test="${mjyh>0 }">
	    <p style="margin-left: 10px;line-height: 30px;">
	    	<img alt="" src="static/images/wm/hui.png" style="height: 15px;width: 15px;vertical-align: middle;">
	    	<span>满减优惠</span>
	      	<span style="float: right;margin-right: 13px;">-￥${mjyh }</span>
	    </p>
    </c:if>
    <!-- 满减配送费 -->
    <c:if test="${mjpsf>0 }">
    	<p id="mjpsf" class="font6" style="margin-top: 5px;font-size: 13px;margin-left: 10px;">
    		<img alt="" src="static/images/wm/jian.png" style="height: 15px;width: 15px;vertical-align: middle;">
    		<span>满减配送费</span>
    		<span style="float: right;margin-right: 13px;">-￥${mjpsf}</span>
    	</p>
    </c:if>
    <!-- 本店新用户立减 -->
    <c:if test="${xyhli>0 }">
    	<p style="margin-left: 10px;line-height: 30px;">
	    	<img alt="" src="static/images/wm/xin.png" style="height: 15px;width: 15px;vertical-align: middle;">
	    	<span>本店新用户立减</span>
	      	<span style="float: right;margin-right: 13px;">-￥${xyhli }</span>
	    </p>
    </c:if>
    <div class="liuyanDiv">
        <div class="liuyan">
            <span>留言 : </span>
            <textarea  id="remark" placeholder="请输入口味、偏好等要求..."></textarea>
        </div>
    </div>
</div>
<div class="tqfooter">
    <div class="ft-lt">
        <div class="price plet" >
        	<input type="hidden" id="heji" value="${totolData.totol+totolData.canhefei+shangjiaData.psCost-(mjpsf+xyhli+mjyh) }">
            <p id="total" class="total">
            	<span style="color: white;" id="yyh">已优惠￥${mjpsf+xyhli+mjyh }</span>
            	<span style="color: white;float: right;margin-right: 20px;" id="shouheji">合计￥${totolData.totol+totolData.canhefei+shangjiaData.psCost-(mjpsf+xyhli+mjyh) }</span>
            </p>
            <!-- <p id="total" class="total">￥${totolData.totol+shangjiaData.psCost}</p> by yym -->
           <!--  <p class="font6">另需配送费￥<span class="share">3</span></p> -->
        </div>
    </div>
    <div class="ft"  style="display: block;">
        <p><a id="jiesuan" href="javascript:void(0)" onclick="submitOrder()">提交订单</a></p>
    </div>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
        $("#mobile").picker({
            title: "请选择您的配送方式",
            cols: [
                {
                    textAlign: 'center',
                    values: ['自取', '商家配送']
                }
            ],
            onChange: function(p, v, dv) {
                console.log(p, v, dv);
            },
            onClose: function(p, v, d) {
                console.log("close");
                var mobile=$("#mobile").val();
                var mobile1=$("#mobile1").val();
                if(mobile!=mobile1){
                	$("#mobile1").val($("#mobile").val());
                	if(mobile=="商家配送"){
                		$("#psf").css("display","block");
                		$("#mjpsf").css("display","block");
                		$("#heji").val("${totolData.totol+totolData.canhefei+shangjiaData.psCost-(mjpsf+xyhli+mjyh) }");
                		$("#shouheji").html("合计￥"+"${totolData.totol+totolData.canhefei+shangjiaData.psCost-(mjpsf+xyhli+mjyh) }");
                		$("#yyh").html("已优惠￥"+"${mjpsf+xyhli+mjyh }");
                		$("#psCost").val("${shangjiaData.psCost}");
                	}else{
                		$("#psf").css("display","none");
                		$("#mjpsf").css("display","none");
                		$("#heji").val("${totolData.totol+totolData.canhefei-(xyhli+mjyh) }");
                		$("#shouheji").html("合计￥"+"${totolData.totol+totolData.canhefei-(xyhli+mjyh) }");
                		$("#yyh").html("已优惠￥"+"${xyhli+mjyh }");
                		$("#psCost").val(0);
                	}
                }
            }
        });
        
           $("#peisonTime").picker({
            title: "请选择您的送餐时间",
            cols: [
                {
                    textAlign: 'center',
                    values: ['立即送出', '12:00', '12:30', '13:00', '13:00', '13:30', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00']
                }
            ],
            onChange: function(p, v, dv) {
                console.log(p, v, dv);
            },
            onClose: function(p, v, d) {
                console.log("close");
            }
        });
    });
    
    
    function submitOrder(){
    	var isdefault = $("#isdefault").val();
    	if(isdefault==""){
    		 //提示
			  layer.open({
			    content: '请设置默认收货地址'
			    ,skin: 'msg'
			    ,time: 2 //2秒后自动关闭
			  });
			  return false;
    	}
    	var remark = $("#remark").val();
    	var total = $("#heji").val();
    	var user_shangjia_id = $("#user_shangjia_id").val();
    	var shouhuo_address_id = $("#shouhuo_address_id").val();
    	var psCost = $("#psCost").val();
    	var arriveTime = $("#peisonTime").val();
    	
    	//优惠部分
    	var mjyh="${mjyh}";
    	var xyhli="${xyhli}";
    	var mjpsf="${mjpsf}";
    	var deliveryMode=4;//默认为商家配送
    	//如果客户自取,则无满减配送费优惠
    	if($("#mobile").val()=="自取"){
    		mjpsf=0;
    		deliveryMode=3;
    	}
    	
    	var mkID="${resultList[0].mkID}";
    	
    	window.location.href="api/kehu/submitOrder.do?remark="+remark+
    	"&total="+total+"&user_shangjia_id="+user_shangjia_id+
    	"&shouhuo_address_id="+shouhuo_address_id+"&psCost="+psCost+"&mjyh="+mjyh+"&xyhli="+xyhli+"&mjpsf="+mjpsf+"&mkID="+mkID+"&deliveryMode="+deliveryMode+"&arriveTime="+arriveTime;
    }
    
    function getAddressList(id){
    	window.location.href="api/kehu/shouhuoDizhi.do?tag=1&user_shangjia_id="+id+"&lat="+"${lat}"+"&lng="+"${lng}";
    }
</script>
</body>
</html>
