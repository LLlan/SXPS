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
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
</head>
<body>
	<form action="notice/${msg }.do" method="post" id="Form">
		<input type="hidden" name="notice_id" value="${pd.notice_id}"/>
		<div id="zhongxin">
		<table id="table_report"  class="table table-striped table-bordered table-hover">
			<tr>
				<td>标题</td>
				<td>
					<input type="text" name="title" id="title" placeholder="输入标题名称" value="${pd.title }"/>
				</td>
			</tr>
			<tr>
				<td>内容</td>
				<td>
					<textarea name="content" id="content" style="width: 600px;" rows="17" cols="" placeholder="请输入公告内容">${pd.content }</textarea>
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
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><img src="static/images/jzx.gif" style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
	</form>
<script type="text/javascript">
	$(top.hangge());
	//保存
	function save(){
		if($("#title").val()==""){
			$("#title").tips({
				side:3,
	            msg:'请输入标题',
	            bg:'#AE81FF',
	            time:1
	        });
			$("#title").focus();
			return false;
		}
		if($("#content").val()==""){
			$("#content").tips({
				side:3,
	            msg:'输入公告内容',
	            bg:'#AE81FF',
	            time:1
	        });
			$("#content").focus();
			return false;
		}
		//提交form表单
		$("#Form").submit();
	}
</script>
</body>
</html>