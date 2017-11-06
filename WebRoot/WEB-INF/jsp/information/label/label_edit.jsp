<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<link rel="stylesheet" href="static/css/datepicker.css" /><!-- 日期框 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
<script type="text/javascript">
	
	$(top.hangge());
	//保存
	function save(){
		if($("#labelName").val()==""){
			$("#labelName").tips({
				side:3,
				msg:'请输入标签名称',
				bg:'#AE81FF',
				time:2
			});
			$("#labelName").focus();
			return false;
		}
		//判断是否已经存在
		var url='label/isExist.do';
		$.post(url,{"labelName":$("#labelName").val(),"type":$("#type").val()},function(data){
			console.log(data)
			if("00" == data.respCode){
				$("#labelName").tips({
					side:3,
		            msg:'该标签名称已存在',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#labelName").focus();
			}else{
				$("#Form").submit();
			}
		});
	
	}
	
</script>
	</head>
<body>
	<form action="label/${msg}.do" name="Form" id="Form" method="post">
		<input type="hidden" name="label_id" id="label_id" value="${pd.label_id}"/>
		<div id="zhongxin">
		<table id="table_report" class="table table-striped table-bordered table-hover">
			<tr>
				<td>标签名称:</td>
				<td><input type="text" style="width:95%;" name="labelName" id="labelName" value="${pd.labelName}" placeholder="请输入标签名称"/></td>
			</tr>
			<tr>
				<td>选择分类:</td>
				<td>
					<select name="type" id="type">
						<option value="1" ${pd.type=="1"?"selected":"" }>商家</option>
						<option value="2" ${pd.type=="2"?"selected":"" }>骑手</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="text-align: center;"colspan="2">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
		
	</form>
	
	
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		<script type="text/javascript">
		$(top.hangge());
		$(function() {
			
			//单选框
			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
			
			//日期框
			$('.date-picker').datepicker();
			
		});
		
		</script>
</body>
</html>