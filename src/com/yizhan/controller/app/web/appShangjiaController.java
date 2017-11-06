package com.yizhan.controller.app.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.config.MvcNamespaceHandler;

import com.google.gson.Gson;
import com.hp.hpl.sparta.xpath.ThisNodeTest;
import com.yizhan.controller.app.jpushModel.JpushClientUtil;
import com.yizhan.controller.base.BaseController;
import com.yizhan.service.app.shangjia.ShangjiaService;
import com.yizhan.service.app.shangjiaOrder.ShangjiaOrderService;
import com.yizhan.service.information.mokuai.MokuaiService;
import com.yizhan.util.AppUtil;
import com.yizhan.util.Const;
import com.yizhan.util.DateTimeUtil;
import com.yizhan.util.DateUtil;
import com.yizhan.util.FileUpload;
import com.yizhan.util.FileUtil;
import com.yizhan.util.MD5;
import com.yizhan.util.PageData;
import com.yizhan.util.PathUtil;
import com.yizhan.util.SmsUtil;
import com.yizhan.util.Tools;
/**
  * app用户-接口类 
  *    
  * 相关参数协议：
  * 00	请求失败
  * 01	请求成功
  * 02	返回空值
  * 03	请求协议参数不完整    
  * 04  用户名或密码错误
  * 05  FKEY验证失败
 */
@Controller
@RequestMapping(value="/api/shangjia")
public class appShangjiaController extends BaseController{
	
	@Resource(name="shangjiaService")
	private ShangjiaService shangjiaService;
	@Resource(name="shangjiaOrderService")
	private ShangjiaOrderService shangjiaOrderService;
	@Resource(name="mokuaiService")
	private MokuaiService mokuaiService;
	/**
	 * 判断用户登录状态,缓存是否有效
	 * @throws Exception 
	 */
	@RequestMapping(value="/judgeAgainDeploy")
	@ResponseBody
	public Object judgeAgainDeploy() throws Exception{
		logBefore(logger, "--判断重新部署--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		
		String respCode = "00";
		String respMsg="请求失败，请联系管理员";
		try{
			if(Tools.isEmpty(pd.getString("backCode"))){
				respMsg="backCode为空,请重新登录";	
			}else{
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					respMsg="缓存信息失效，请重新登录";
				}else{
					respCode="01";
					respMsg="缓存信息有效";
				}
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 判断用户是否认证、认证状态以及信息是否完善
	 * @throws Exception 
	 */
	@RequestMapping(value="/isComplete")
	@ResponseBody
	public Object isComplete(){
		logBefore(logger, "--判断用户是否认证、认证状态以及信息是否完善--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "0df28b1e05e9344b03d34686b7dbe044");
		
		String respCode = "00";
		String respMsg="请求失败，请联系管理员";
		
		String respCode1 = "01";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//获取商家信息
			PageData tempPd=shangjiaService.getDataByPhone(cacheData);
			
			//运费信息
			pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
			List<PageData> list=shangjiaService.getFreightOfShangJia(pd);
			
			//判断是否认证，若没有认证，则提示去认证
			if(Tools.isEmpty(tempPd.getString("authenticationState"))){
				respCode1 = "02";
				respMsg="您尚未进行认证,点击确定进行认证!";
			}else{
				//判断认证状态
				if(tempPd.getString("authenticationState").equals("0")){
					respCode1 = "03";
					respMsg="您的认证审核未通过,点击确定重新认证";
				}else{
					//判断信息是否完善
					if(Tools.isEmpty(tempPd.getString("address")) ||
							Tools.isEmpty(tempPd.getString("shopName")) ||
							Tools.isEmpty(tempPd.getString("deliveryAmount")) ||
							Tools.isEmpty(tempPd.getString("tel_phone"))||
							Tools.isEmpty(tempPd.getString("logoImg")) ||
							Tools.isEmpty(tempPd.getString("realName"))||
							Tools.isEmpty(tempPd.getString("psTime"))||
							Tools.isEmpty(tempPd.getString("psRange"))||
							Tools.isEmpty(tempPd.getString("identityCard"))){
						respCode1 = "04";
						respMsg="商家资料尚未完善,点击确定去完善信息";
					}else{
						if(list.size()>0 && list!=null && !list.isEmpty()){
							respCode="01";
							respMsg="认证通过,商家资料完善,运费管理信息完善";
						}else {
							respCode1 = "05";
							respMsg="运费管理信息尚未完善,点击确定去完善信息!";
						}
					}
				}
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respCode1", respCode1);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 发送验证码
	 */
	@RequestMapping(value="/sendSecurityCode")
	@ResponseBody
	public Object sendSecurityCode(){
		logBefore(logger, "---发送验证码---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg="";
		//测试时,传递的参数,之后删除
		//pd.put("phone", "18289763525");
		
		//电话号码
		String phone = pd.getString("phone");
		if(Tools.notEmpty(phone)){
			//发送验证码
			Map mapResult  = SmsUtil.sendMsM(phone);
			if(mapResult.get("result").equals("验证码发送成功")){
				String securityCode =  (String)mapResult.get("yanzhengma");
				//请求成功信息
				respCode = "01";
				//注册请求识别码
				map.put("securityCode", securityCode);
				respMsg="请求成功,securityCode是我返回给你的正确的验证码，存于你们本地，最后注册请求时将该码与用户填的验证码一起传来。";
			}else{
				//请求失败
				respMsg="失败";
			}
		}else{ 
			//请求失败
			respMsg="电话号码不能为空";
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 注册
	 */
	@RequestMapping(value="/register")
	@ResponseBody
	public Object register(HttpServletRequest request){
		logBefore(logger, "---注册--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "注册失败,该手机号已经注册";
		try{
		 	//判断用户是否存在
			PageData pd1=new PageData();
			pd1.put("phone", pd.getString("phone"));
			PageData pds = shangjiaService.getDataByPhone(pd1);
			if(pds==null){
				//满足条件，执行保存操作
				PageData sjPd=new PageData();
				sjPd.put("user_shangjia_id", this.get32UUID());//主键
				sjPd.put("phone", pd.getString("phone"));
				sjPd.put("tel_phone", pd.getString("phone"));
				sjPd.put("loginPassword", MD5.md5(pd.getString("loginPassword")));
				
				sjPd.put("Amount", 0);//账户余额
				sjPd.put("Incometoday", 0);//今日收入
				sjPd.put("totalassets", 0);//总资产
				sjPd.put("psCost", 0);//配送费
				
				sjPd.put("payPwdStatus", 0);//支付密码设置状态（0-未设置，1-已设置）'
				sjPd.put("registerTime", DateUtil.getTime());//注册时间	
				sjPd.put("last_login_time", DateUtil.getTime());//最近登陆时间	
				sjPd.put("ip", request.getRemoteHost());//ip地址	
				sjPd.put("status", "1");//1 使用中 0 已停用
				sjPd.put("bz", "app用户");
				//保存客户端用户信息
				shangjiaService.saveShangJiaUser(sjPd);
				respCode = "01";
				respMsg = "注册成功";
			}
		}catch(Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(new PageData(), map);
	}
	/**
	 * 登录
	 */
	@RequestMapping(value="/login")
	@ResponseBody
	public Object login(HttpServletRequest request){
		logBefore(logger, "---登录--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "登录失败,手机号或密码错误";
		try{
			//根据手机号和密码获取用户信息
			PageData pd1=new PageData();
			pd1.put("phone", pd.getString("phone"));
			pd1.put("loginPassword", MD5.md5(pd.getString("loginPassword")));
			
			PageData pds = shangjiaService.getDataByPhone(pd1);
			String user_shangjia_id="";
			if(pds!=null){
				user_shangjia_id=pds.getString("user_shangjia_id");
			
				//加密后的返回码，用于请求识别
				String backCode=MD5.md5(pd.getString("phone"));
				//每一次登录，都要修改这次登录时间为最后一次登录时间
				pd.put("last_login_time",DateUtil.getTime());
				pd.put("ip",request.getRemoteHost());
				shangjiaService.updateLoginTimeAndIp(pd);
				//根据返回码获取缓存信息(存在则更新、不存在则添加)
				pd.put("backCode", backCode);
				PageData cacheData = shangjiaService.getDataByBackCode(pd);      
				if(cacheData==null){
					//添加缓存
					PageData cachePD = new PageData();
					cachePD.put("backCode", backCode);
					cachePD.put("phone", pd.getString("phone"));
					cachePD.put("user_shangjia_fid", user_shangjia_id);
					cachePD.put("cache_user_shangjia_id", this.get32UUID());
					//将用户信息存进缓存表中
					shangjiaService.saveCacheData(cachePD);
				}else{
					//更新缓存
					PageData cachePD = new PageData();
					cachePD.put("backCode", backCode);
					cachePD.put("phone", pd.getString("phone"));
					cachePD.put("user_shangjia_fid", user_shangjia_id);
					cachePD.put("cache_user_shangjia_id", cacheData.getString("cache_user_shangjia_id"));
					//将用户信息存进缓存表中
					shangjiaService.updateCacheData(cachePD);
				}
				respCode = "01";
				respMsg="登录成功！";
				map.put("backCode", backCode);
			}
		} catch(Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(pd, map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 退出，注销 清除用户登录信息缓存
	 * @throws Exception 
	 */
	@RequestMapping(value="/clearLoginInfo")
	@ResponseBody
	public Object clearLoginInfo(){
		logBefore(logger, "---清除用户登录信息--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		
		String respCode = "00";
		String respMsg = "清除失败";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				respMsg="backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				pd.put("isOpen", 0);
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.isupdateStart(pd);//当退出app时将设置成不营业
				shangjiaService.deleteCacheData(pd);
				respCode = "01";
				respMsg="清除成功";
			}
				
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 找回密码
	/**
	 * 找回密码1：验证该手机号是否注册
	 * @return
	 */
	@RequestMapping(value="/goToBackPassword1")
	@ResponseBody
	public Object goToBackPassword1(){
		logBefore(logger, "---找回密码1：验证该手机号是否注册--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,该手机号尚未注册";
		try {
			//判断用户是否存在
			PageData pds = shangjiaService.getDataByPhone(pd);
			if(pds!=null){
				respCode="01";
				respMsg="成功,该手机号已经注册";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 找回密码2：保存新密码
	 * @return
	 */
	@RequestMapping(value="/goToBackPassword2")
	@ResponseBody
	public Object goToBackPassword2(){
		logBefore(logger, "---找回密码2：保存新密码--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("phone")) && Tools.notEmpty(pd.getString("loginPassword"))){
				//执行更新
				pd.put("loginPassword", MD5.md5(pd.getString("loginPassword")));
				shangjiaService.updateLoginPassword(pd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 商家资料
	/**
	 * 点击商家资料进入商家基本信息页面
	 * @return
	 */
	@RequestMapping(value="/shangJiaBaseInformation")
	@ResponseBody
	public Object shangJiaBaseInformation(){
		logBefore(logger, "---点击商家资料进入商家基本信息页面--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "0df28b1e05e9344b03d34686b7dbe044");
		
		String respCode = "00";
		String respMsg = "失败";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//获取商家信息
			PageData userData=shangjiaService.getDataByPhone(cacheData);
			String imgPaht=userData.getString("logoImg");
			userData.put("logoImg", BaseController.getPath(getRequest())+imgPaht);
			map.put("userData", userData);
			respCode="01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 修改商家头像(logo)
	 * @return
	 */
	@RequestMapping(value="/changeLogoImg")
	@ResponseBody
	public Object changeLogoImg(@RequestParam(required=false) MultipartFile logoImgFile,String backCode){
		logBefore(logger, "---修改商家头像(logo)--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		String respCode = "00";
		String respMsg = "失败";
		try {
			if (null != logoImgFile && !logoImgFile.isEmpty()){
				//根据backCode获取缓存信息
				pd.put("backCode", backCode);
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//获取当前用户的头像信息
				PageData tempPd=shangjiaService.getDataByPhone(cacheData);
				if(Tools.notEmpty(tempPd.getString("logoImg"))){
					//删除已存在的图片
					File oldFile=new File(PathUtil.getClasspath()+tempPd.getString("logoImg"));
					if(oldFile.exists()){
						oldFile.delete();
					}
				}
				//自定义头像的保存路径
				String  logoImgfolder = Const.FILEPATHIMG + "shangjia/logo/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + logoImgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String logoImgName = FileUpload.fileUp(logoImgFile, filePath, this.get32UUID());
				//更新用户头像
				pd.put("logoImg", logoImgfolder + logoImgName);
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}else{
				respMsg="操作失败,图片文件不能为空";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家名称第二步:修改商家店铺名称
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateShopName2")
	@ResponseBody
	public Object updateShopName2(){
		logBefore(logger, "---修改商家名称第二步:修改商家店铺名称--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		//pd.put("shopName", "张建华");
		
		String respCode = "00";
		String respMsg = "失败";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//判断该用户名是否存在
			PageData tempPd=shangjiaService.getDataByShopName(pd);
			if(tempPd!=null){
				respMsg="该店铺名称已存在,请重新选择";
			}else {
				//更新用户名
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家地址第二步:修改商家地址
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateAddress2")
	@ResponseBody
	public Object updateAddress2(){
		logBefore(logger, "---修改商家地址第二步:修改商家地址--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		//pd.put("address", "海南省海口市龙华区国贸路景瑞大厦A座13楼C室");
		
		String respCode = "00";
		String respMsg = "失败";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//更新用户名
			pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
			shangjiaService.updateUserData(pd);
			respCode = "01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家电话第二步:修改商家电话
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateTelPhone2")
	@ResponseBody
	public Object updateTelPhone2(){
		logBefore(logger, "---修改商家电话第二步:修改商家电话--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		//pd.put("tel_phone", "0558-7530276");
		
		String respCode = "00";
		String respMsg = "失败";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//更新用户名
			pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
			shangjiaService.updateUserData(pd);
			respCode = "01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家起送金额第二步:修改商家起送金额
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateDeliveryAmount2")
	@ResponseBody
	public Object updateDeliveryAmount2(){
		logBefore(logger, "---修改商家起送金额第二步:修改商家起送金额--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("backCode", "d1d52e685369685c870983147fe98d48");
		//pd.put("deliveryAmount", 30);
		
		String respCode = "00";
		String respMsg = "失败";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//更新用户名
			pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
			shangjiaService.updateUserData(pd);
			respCode = "01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改个人信息，商家姓名
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateRealName")
	@ResponseBody
	public Object updateRealName(){
		logBefore(logger, "---修改个人信息，商家姓名--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败";
		try{
			if(Tools.isEmpty(pd.getString("backCode"))){
				respCode = "00";
				map.put("respCode", respCode);
				respMsg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				if (cacheData == null) {
					respCode = "00";
					map.put("respCode", respCode);
					respMsg="缓存信息失效,请重新登录";
				}else {
					if (Tools.isEmpty(pd.getString("realName"))) {
						respCode = "00";
						map.put("respCode", respCode);
						respMsg="请输入您的真实姓名";
					}else {
						//判断商家真实姓名是否重复
						PageData realNames=shangjiaService.getDataByRealName(pd);
						if (realNames == null) {
							//更新用户名
							pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
							shangjiaService.updateUserData(pd);
							respCode = "01";
							respMsg="成功";
						}else {
							respCode = "00";
							map.put("respCode", respCode);
							respMsg="姓名已存在";
						}
					}
				}
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改个人信息，商家身份证号码
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateIdentityCard")
	@ResponseBody
	public Object updateIdentityCard(){
		logBefore(logger, "---修改个人信息，商家身份证号码--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,身份证已存在";
		try{
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//判断商家身份号码是否重复
			PageData identityCard=shangjiaService.getDataByIdentityCard(pd);
			if (identityCard == null) {
				//更新用户名
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家公告
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateShopNotice")
	@ResponseBody
	public Object updateShopNotice(){
		logBefore(logger, "---修改商家公告--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) && Tools.notEmpty(pd.getString("shopNotice"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//更新
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 满减优惠部分
	
	/**
	 * 删除满减优惠
	 * @throws Exception 
	 */
	@RequestMapping(value="/deleteMjyh")
	@ResponseBody
	public Object deleteMjyh(){
		logBefore(logger, "---删除满减优惠--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjyh_id"))){
				
				shangjiaService.deleteMjyh(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 编辑满减优惠
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateMjyh")
	@ResponseBody
	public Object updateMjyh(){
		logBefore(logger, "---编辑满减优惠--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjyh_id")) 
					&& Tools.notEmpty(pd.getString("man_num"))
					&& Tools.notEmpty(pd.getString("jian_num"))){
				
				shangjiaService.updateMjyh(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 添加满减优惠
	 * @throws Exception 
	 */
	@RequestMapping(value="/addMjyh")
	@ResponseBody
	public Object addMjyh(){
		logBefore(logger, "---添加满减优惠--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) 
					&& Tools.notEmpty(pd.getString("man_num"))
					&& Tools.notEmpty(pd.getString("jian_num"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//添加
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				pd.put("mjyh_id", this.get32UUID());
				pd.put("mjyh_state", "1");
				shangjiaService.addMjyh(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改满减优惠的状态
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateMjyhState")
	@ResponseBody
	public Object updateMjyhState(){
		logBefore(logger, "---修改满减优惠的状态--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjyh_id")) && Tools.notEmpty(pd.getString("mjyh_state"))){
				//更新
				shangjiaService.updateMjyhState(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 获取满减优惠列表（满减优惠主页）
	 * @throws Exception 
	 */
	@RequestMapping(value="/getMjyhList")
	@ResponseBody
	public Object getMjyhList(){
		logBefore(logger, "---获取满减优惠列表（满减优惠主页）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//获取
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				List<PageData> dataList=shangjiaService.getMjyhList(pd);
				map.put("dataList", dataList);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 满减配送费部分
	
	/**
	 * 删除满减配送费
	 * @throws Exception 
	 */
	@RequestMapping(value="/deleteMjpsf")
	@ResponseBody
	public Object deleteMjpsf(){
		logBefore(logger, "---删除满减配送费--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjpsf_id"))){
				
				shangjiaService.deleteMjpsf(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
		
	/**
	 * 编辑满减配送费
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateMjpsf")
	@ResponseBody
	public Object updateMjpsf(){
		logBefore(logger, "---编辑满减配送费--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjpsf_id")) 
					&& Tools.notEmpty(pd.getString("man_num"))
					&& Tools.notEmpty(pd.getString("jian_num"))){
				
				shangjiaService.updateMjpsf(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 添加满减配送费
	 * @throws Exception 
	 */
	@RequestMapping(value="/addMjpsf")
	@ResponseBody
	public Object addMjpsf(){
		logBefore(logger, "---添加满减配送费--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) 
					&& Tools.notEmpty(pd.getString("man_num"))
					&& Tools.notEmpty(pd.getString("jian_num"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//添加
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				pd.put("mjpsf_id", this.get32UUID());
				pd.put("mjpsf_state", "1");
				shangjiaService.addMjpsf(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改满减配送费的状态
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateMjpsfState")
	@ResponseBody
	public Object updateMjpsfState(){
		logBefore(logger, "---修改满减配送费的状态--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("mjpsf_id")) && Tools.notEmpty(pd.getString("mjpsf_state"))){
				//更新
				shangjiaService.updateMjpsfState(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 获取满减配送费列表（满减配送费主页）
	 * @throws Exception 
	 */
	@RequestMapping(value="/getMjpsfList")
	@ResponseBody
	public Object getMjpsfList(){
		logBefore(logger, "---获取满减配送费列表（满减配送费主页）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//获取
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				List<PageData> dataList=shangjiaService.getMjpsfList(pd);
				map.put("dataList", dataList);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 设置部分中的接口
	/**
	 * 满减配送费
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateMjpsf1")
	@ResponseBody
	public Object updateMjpsf1(){
		logBefore(logger, "---满减配送费--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) 
					&& Tools.notEmpty(pd.getString("mjpsf"))
					&& Tools.notEmpty(pd.getString("mjpsfState"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//更新
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 新用户立减
	 * @throws Exception 
	 */
	@RequestMapping(value="/updateXyhli")
	@ResponseBody
	public Object updateXyhli(){
		logBefore(logger, "---新用户立减--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) 
					&& Tools.notEmpty(pd.getString("xyhli"))
					&& Tools.notEmpty(pd.getString("xyhliState"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//更新
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家配送时间段
	 * @throws Exception 
	 */
	@RequestMapping(value="/updatePsTime")
	@ResponseBody
	public Object updatePsTime(){
		logBefore(logger, "---修改商家配送时间段--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) && Tools.notEmpty(pd.getString("psTime"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//更新配送时间
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 修改商家配送范围
	 * @throws Exception 
	 */
	@RequestMapping(value="/updatePsRange")
	@ResponseBody
	public Object updatePsRange(){
		logBefore(logger, "---修改商家配送范围--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) && Tools.notEmpty(pd.getString("psRange"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//更新配送时间
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 运费管理:第一步获取指定商家的运费设置信息
	 * @throws Exception 
	 */
	@RequestMapping(value="/getFreightOfShangJia")
	@ResponseBody
	public Object getFreightOfShangJia(){
		logBefore(logger, "---运费管理:第一步获取指定商家的运费设置信息--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				
				//运费信息
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				List<PageData> list=shangjiaService.getFreightOfShangJia(pd);
				map.put("dataList", list);
				
				//超重收费信息
				PageData dataPd=shangjiaService.getWeightBeyondOfShangJia(pd);
				map.put("dataPd", dataPd);
				
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 运费管理:第二步保存运费信息
	 * @throws Exception 
	 */
	@RequestMapping(value="/updatePsCost")
	@ResponseBody
	public Object updatePsCost(){
		logBefore(logger, "---运费管理:第二步保存运费信息--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try{
			if(Tools.notEmpty(pd.getString("backCode")) && Tools.notEmpty(pd.getString("strinfo"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				
				//删除原有的运费信息
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.deleteFreightOfShangJia(pd);
				
				//删除原有的超重收费信息
				shangjiaService.deleteWeightBeyondOfShangJia(pd);
				
				//添加新的运费信息
				String[] str1=pd.getString("strinfo").split(",yizhan,");
				for (int i = 0; i < str1.length-1; i++) {
					
					String[] str2=str1[i].split(",");
					
					PageData pdData=new PageData();
					pdData.put("distance1", str2[0]);
					pdData.put("distance2", str2[1]);
					pdData.put("cost", str2[2]);
					pdData.put("freight_id", this.get32UUID());
					pdData.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					
					shangjiaService.saveFreightOfShangJia(pdData);

				}
				
				//添加新的超重收费信息
				String[] str3=str1[str1.length-1].split(",");
				PageData pData=new PageData();
				pData.put("weight", str3[0]);
				pData.put("unit", str3[1]);
				pData.put("cost", str3[2]);
				pData.put("weight_beyond_id", this.get32UUID());
				pData.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				
				shangjiaService.saveWeightBeyondOfShangJia(pData);
				
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 换绑手机号第一步：进入短信验证页面
	 * @return
	 */
	@RequestMapping(value="/changePhone1")
	@ResponseBody
	public Object changePhone1(){
		logBefore(logger, "---换绑手机号第一步：进入短信验证页面--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			respCode = "01";
			respMsg="成功";
			map.put("phone", cacheData.getString("phone"));
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 换绑手机号第二步：进行短信验证
	 * @return
	 */
	@RequestMapping(value="/changePhone2")
	@ResponseBody
	public Object changePhone2(){
		logBefore(logger, "---换绑手机号第二步：进行短信验证--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败";
		try {
			if(!pd.getString("securityCode").equals(pd.getString("yanzhengma"))){ 
			 	respMsg = "验证码不正确";
			}else {
				respCode = "01";
				respMsg = "成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 换绑手机号第三步：换绑新的手机号
	 * @return
	 */
	@RequestMapping(value="/changePhone3")
	@ResponseBody
	public Object changePhone3(){
		logBefore(logger, "---换绑手机号第三步：换绑新的手机号--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//判断该手机号是否已被使用
			PageData tempData=shangjiaService.getDataByPhone(pd);
			if(tempData!=null){
				respMsg="换绑失败,该手机号已注册为商家";
			}else{
				//更新用户的手机号信息
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateUserData(pd);
				//更新缓存信息
				String backCode=MD5.md5(pd.getString("phone"));
				PageData tempPd=new PageData();
				tempPd.put("phone", pd.getString("phone"));
				tempPd.put("backCode", backCode);
				tempPd.put("cache_user_shangjia_id", cacheData.getString("cache_user_shangjia_id"));
				shangjiaService.updateCacheData(tempPd);
				respCode = "01";
				respMsg="成功";
				map.put("backCode", backCode);
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 商家认证
	/**
	 * 商家认证
	 * @return
	 */
	@RequestMapping(value="/shangJiaRenZheng")
	@ResponseBody
	public Object shangJiaRenZheng(
			@RequestParam(required=false) MultipartFile menlianImgFile,
			@RequestParam(required=false) MultipartFile[] dianNeiImgFile,
			@RequestParam(required=false) MultipartFile handIdentityImgFile,
			@RequestParam(required=false) MultipartFile businessLicenceImgFile,
			@RequestParam(required=false) MultipartFile licenceImgFile,
			@RequestParam(required=false) MultipartFile logoImgFile,
			@RequestParam(required=false) MultipartFile[] shangPinImgFile,
			String backCode
			){
		logBefore(logger, "---商家认证--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd.put("backCode", backCode);
		String respCode = "00";
		String respMsg = "失败";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//获取商家信息
			PageData sahgnJiaData=shangjiaService.getDataByPhone(cacheData);
			PageData updatePd=new PageData();
			updatePd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
			updatePd.put("submitTime", DateUtil.getTime());
			updatePd.put("authenticationState", "2");
			//上传文件操作
			//1.上传门脸照
			if (null != menlianImgFile && !menlianImgFile.isEmpty()){
				//删除已有图片
				if(Tools.notEmpty(sahgnJiaData.getString("menlianImg"))){
					FileUtil.delFile(PathUtil.getClasspath()+sahgnJiaData.getString("menlianImg"));
				}
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(menlianImgFile, filePath, this.get32UUID());
				updatePd.put("menlianImg", imgfolder + imgName);
			}else{
				map.put("menlianImgFile_msg", "门脸照图片文件为空");
			}
			//2.上传店内环境图
			if (dianNeiImgFile.length>0 && dianNeiImgFile[0].getSize()!=0){
				System.out.println("=========================上传店内环境图的个数为："+dianNeiImgFile.length);
				//删除已存在的文件图片
				cacheData.put("mark", "1");
				List<PageData> dianNeiImgList=shangjiaService.getRenZhengImgList(cacheData);
				if(dianNeiImgList!=null && !dianNeiImgList.isEmpty()){
					for (int i = 0; i < dianNeiImgList.size(); i++) {
						FileUtil.delFile(PathUtil.getClasspath()+dianNeiImgList.get(i).getString("imgPath"));
					}
				}
				//删除数据库中失效的图片信息
				shangjiaService.deleteRenZhengImg(cacheData);
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				for (int i = 0; i < dianNeiImgFile.length; i++) {
					PageData tPd=new PageData();
					tPd.put("imgPath_diannei_id", this.get32UUID());
					tPd.put("mark", "1");
					tPd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					String imgName = FileUpload.fileUp(dianNeiImgFile[i], filePath, this.get32UUID());
					tPd.put("imgPath", imgfolder + imgName);
					shangjiaService.saveRenZhengImg(tPd);
				}
			}else{
				map.put("dianNeiImgFile_msg", "店内环境图片文件为空");
			}
			//3.手持身份证合影图片
			if (null != handIdentityImgFile && !handIdentityImgFile.isEmpty()){
				//删除已有图片
				if(Tools.notEmpty(sahgnJiaData.getString("handIdentityImg"))){
					FileUtil.delFile(PathUtil.getClasspath()+sahgnJiaData.getString("handIdentityImg"));
				}
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(handIdentityImgFile, filePath, this.get32UUID());
				updatePd.put("handIdentityImg", imgfolder + imgName);
			}else{
				map.put("handIdentityImgFile_msg", "身份证合影图片文件为空");
			}
			//4.营业执照照片
			if (null != businessLicenceImgFile && !businessLicenceImgFile.isEmpty()){
				//删除已有图片
				if(Tools.notEmpty(sahgnJiaData.getString("businessLicenceImg"))){
					FileUtil.delFile(PathUtil.getClasspath()+sahgnJiaData.getString("businessLicenceImg"));
				}
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(businessLicenceImgFile, filePath, this.get32UUID());
				updatePd.put("businessLicenceImg", imgfolder + imgName);
			}else{
				map.put("businessLicenceImgFile_msg", "营业执照图片文件为空");
			}
			//5.餐饮服务许可证照片
			if (null != licenceImgFile && !licenceImgFile.isEmpty()){
				//删除已有图片
				if(Tools.notEmpty(sahgnJiaData.getString("licenceImg"))){
					FileUtil.delFile(PathUtil.getClasspath()+sahgnJiaData.getString("licenceImg"));
				}
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(licenceImgFile, filePath, this.get32UUID());
				updatePd.put("licenceImg", imgfolder + imgName);
			}else{
				map.put("licenceImgFile_msg", "许可证图片文件为空");
			}
			//6.店铺logo
			if (null != logoImgFile && !logoImgFile.isEmpty()){
				//删除已有图片
				if(Tools.notEmpty(sahgnJiaData.getString("logoImg"))){
					FileUtil.delFile(PathUtil.getClasspath()+sahgnJiaData.getString("logoImg"));
				}
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(logoImgFile, filePath, this.get32UUID());
				updatePd.put("renZhenglogoImg", imgfolder + imgName);
			}else{
				map.put("logoImgFile_msg", "店铺logo图片文件为空");
			}
			//7.上传商品图
			if (shangPinImgFile.length>0 && shangPinImgFile[0].getSize()!=0){
				System.out.println("=========================上传商品图的个数为："+shangPinImgFile.length);
				//删除已存在的文件图片
				cacheData.put("mark", "2");
				List<PageData> shangPinImgList=shangjiaService.getRenZhengImgList(cacheData);
				if(shangPinImgList!=null && !shangPinImgList.isEmpty()){
					for (int i = 0; i < shangPinImgList.size(); i++) {
						FileUtil.delFile(PathUtil.getClasspath()+shangPinImgList.get(i).getString("imgPath"));
					}
				}
				//删除数据库中失效的图片信息
				shangjiaService.deleteRenZhengImg(cacheData);
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/renzheng/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				for (int i = 0; i < shangPinImgFile.length; i++) {
					PageData tPd=new PageData();
					tPd.put("imgPath_diannei_id", this.get32UUID());
					tPd.put("mark", "2");
					tPd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					String imgName = FileUpload.fileUp(shangPinImgFile[i], filePath, this.get32UUID());
					tPd.put("imgPath", imgfolder + imgName);
					shangjiaService.saveRenZhengImg(tPd);
				}
			}else{
				map.put("shangPinImgFile_msg", "商品图图片文件为空");
			}
			//更新用户信息
			shangjiaService.updateUserData(updatePd);
			respCode="01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 商品管理部分
	/**
	 * 门店运营中-点击商品管理-选择类型-获取类型
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getListOfMokuai")
	@ResponseBody
	public Object getListOfMokuai() throws Exception{
		logBefore(logger, "---门店运营中-点击商品管理-选择类型-获取类型--");
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		
		String respCode = "01";
		String respMsg = "成功";
		List<PageData> list=mokuaiService.getListOfMokuai(pd);
		//该for循环的目的，获取图片的完整路径，否则前台无法显示
		for (PageData temp:list) {
			temp.put("headImg", BaseController.getPath(getRequest())+temp.getString("headImg"));
		}
		map.put("dataList", list);
		
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 获取商品分类
	 * @return
	 */
	@RequestMapping(value="/getShangPinFenLei")
	@ResponseBody
	public Object getShangPinFenLei(){
		logBefore(logger, "---获取商品分类--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("backCode")) && Tools.notEmpty(pd.getString("mokuai_id"))){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//获取商品分类列表
				PageData temp=new PageData();
				temp.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				temp.put("mokuai_id", pd.getString("mokuai_id"));
				List<PageData> dataList=shangjiaService.getlistspfl(temp);
				map.put("dataList", dataList);
				
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 根据分类获取对应的商品列表
	 * @return
	 */
	@RequestMapping(value="/getShangPinByFenLei")
	@ResponseBody
	public Object getShangPinByFenLei(){
		logBefore(logger, "---根据分类获取对应的商品列表--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("goods_category_id"))){
				pd.put("yearsAndmonth", DateTimeUtil.formateYearAndMonth(new Date()));//获取当前月份,目的是为了获取商品的月销售量
				System.out.println(DateTimeUtil.formateYearAndMonth(new Date())+"****************");
				List<PageData> goodsList=shangjiaService.goodsgetlistAll(pd);
				for (int i = 0; i < goodsList.size(); i++) {
					goodsList.get(i).put("goodsImg", BaseController.getPath(getRequest())+goodsList.get(i).getString("goodsImg"));
				}
				map.put("dataList", goodsList);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 新增商品分类
	 * @return
	 */
	@RequestMapping(value="/addShangPinFenLei")
	@ResponseBody
	public Object addShangPinFenLei(){
		logBefore(logger, "---新增商品分类--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if (Tools.notEmpty(pd.getString("backCode"))
					&& Tools.notEmpty(pd.getString("categoryName"))
					&& Tools.notEmpty(pd.getString("mokuai_id"))) {
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//验证该分类名称是否已经存在
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				PageData tempPd=shangjiaService.spflgetDateByIdorName(pd);
				if(tempPd!=null){
					respMsg="该分类名称已经存在,无需重复添加";
				}else{
					PageData addPd=new PageData();
					addPd.put("goods_category_id", this.get32UUID());
					addPd.put("categoryName", pd.getString("categoryName"));
					addPd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					addPd.put("addTime", DateUtil.getTime());
					addPd.put("mokuai_fid", pd.getString("mokuai_id"));
					shangjiaService.spflinsert(addPd);
					respCode="01";
					respMsg="成功";
				}
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 修改商品分类
	 * @return
	 */
	@RequestMapping(value="/updateShangPinFenLei")
	@ResponseBody
	public Object updateShangPinFenLei(){
		logBefore(logger, "---修改商品分类--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if (Tools.notEmpty(pd.getString("backCode"))
					&& Tools.notEmpty(pd.getString("categoryName"))
					&& Tools.notEmpty(pd.getString("mokuai_id"))
					&& Tools.notEmpty(pd.getString("goods_category_id"))) {
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//验证该分类名称是否已经存在
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				PageData tempPd=shangjiaService.spflgetDateByIdorName(pd);
				if(tempPd!=null){
					respMsg="该分类名称已经存在";
				}else{
					pd.put("addTime", DateUtil.getTime());
					shangjiaService.spflupdate(pd);
					respCode="01";
					respMsg="成功";
				}
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 删除指定分类
	 * @return
	 */
	@RequestMapping(value="/deleteShangPinFenLei")
	@ResponseBody
	public Object deleteShangPinFenLei(){
		logBefore(logger, "---删除指定分类--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("goods_category_id"))){
				shangjiaService.spfldeleteOne(pd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 新建商品
	 * @return
	 */
	@RequestMapping(value="/addShangPin")
	@ResponseBody
	public Object addShangPin(
			@RequestParam(required=false) MultipartFile goodsImgFile,
			String goodsName,
			String goodsIntroduce,//商品介绍
			String goods_category_id,
			String originalPrice,
			String presentPrice,
			String backCode,
			String canhefei
			){
		logBefore(logger, "---新建商品--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd.put("backCode", backCode);
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if (null != goodsImgFile && !goodsImgFile.isEmpty() 
					&& Tools.notEmpty(goodsName) 
					&& Tools.notEmpty(goods_category_id)
					&& Tools.notEmpty(originalPrice)
					&& Tools.notEmpty(presentPrice)
					&& Tools.notEmpty(backCode)
					&& Tools.notEmpty(canhefei)){
				//根据backCode获取缓存信息
				PageData cacheData=shangjiaService.getDataByBackCode(pd);
				//自定义头像的保存路径
				String  imgfolder = Const.FILEPATHIMG + "shangjia/shangpin/" + DateUtil.getDays() + "/";
				String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
				//执行上传操作,获取文件名
				String imgName = FileUpload.fileUp(goodsImgFile, filePath, this.get32UUID());
				pd.put("goodsImg", imgfolder + imgName);
				pd.put("goodsName", goodsName);
				pd.put("goodsIntroduce", goodsIntroduce);//商品介绍
				pd.put("goods_category_fid", goods_category_id);
				pd.put("canhefei", canhefei);
				pd.put("originalPrice", originalPrice);
				pd.put("presentPrice", presentPrice);
				pd.put("goods_id", this.get32UUID());
				pd.put("fabuTime", DateUtil.getTime());
				pd.put("goodsState", "1");
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				shangjiaService.goodsinsert(pd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 编辑商品第一步：进入编辑商品页面
	 * @return
	 */
	@RequestMapping(value="/updateShangPin1")
	@ResponseBody
	public Object updateShangPin1(){
		logBefore(logger, "---编辑商品第一步：进入编辑商品页面 --");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("goods_id"))){
				PageData dataPd=shangjiaService.goodsgetDateByIdorName(pd);
				dataPd.put("goodsImg", BaseController.getPath(getRequest())+dataPd.getString("goodsImg"));
				map.put("dataPd", dataPd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 编辑商品第二步：保存编辑后的商品
	 * @return
	 */
	@RequestMapping(value="/updateShangPin2")
	@ResponseBody
	public Object updateShangPin2(
			@RequestParam(required=false) MultipartFile goodsImgFile,
			String goodsName,
			String goodsIntroduce,
			String goods_category_id,
			String originalPrice,
			String presentPrice,
			String canhefei,
			String goods_id
			){
		logBefore(logger, "---编辑商品第二步：保存编辑后的商品 --");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();

		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			System.out.println("goodsName="+goodsName+"goods_category_id="+goods_category_id+"originalPrice="+originalPrice+"presentPrice="+presentPrice+"canhefei="+canhefei+"goods_id="+goods_id);
			if (Tools.notEmpty(goodsName) 
					&& Tools.notEmpty(goods_category_id)
					&& Tools.notEmpty(originalPrice)
					&& Tools.notEmpty(presentPrice)
					&& Tools.notEmpty(canhefei)
					&& Tools.notEmpty(goods_id)){
				pd.put("goods_id", goods_id);
				//根据主键ID，获取修改前的商品信息
				PageData dataPd=shangjiaService.goodsgetDateByIdorName(pd);
				if (null != goodsImgFile && !goodsImgFile.isEmpty()){
					//删除已有图片
					if(Tools.notEmpty(dataPd.getString("goodsImg"))){
						FileUtil.delFile(PathUtil.getClasspath()+dataPd.getString("goodsImg"));
					}
					//自定义头像的保存路径
					String  imgfolder = Const.FILEPATHIMG + "shangjia/shangpin/" + DateUtil.getDays() + "/";
					String filePath = PathUtil.getClasspath() + imgfolder;	//文件上传路径
					//执行上传操作,获取文件名
					String imgName = FileUpload.fileUp(goodsImgFile, filePath, this.get32UUID());
					pd.put("goodsImg", imgfolder + imgName);
				}else{
					pd.put("goodsImg", dataPd.getString("goodsImg"));
					map.put("goodsImgFile_msg", "图片文件为空");
				}
				pd.put("goodsName", goodsName);
				pd.put("goodsIntroduce", goodsIntroduce);//商品介绍
				pd.put("goods_category_fid", goods_category_id);
				pd.put("originalPrice", originalPrice);
				pd.put("presentPrice", presentPrice);
				pd.put("canhefei", canhefei);
				pd.put("fabuTime", DateUtil.getTime());
				shangjiaService.goodsupdate(pd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 修改指定商品的状态（上架或下架）
	 * @return
	 */
	@RequestMapping(value="/updateShangPinState")
	@ResponseBody
	public Object updateShangPinState(){
		logBefore(logger, "---修改指定商品的状态（上架或下架）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("goods_id")) && Tools.notEmpty(pd.getString("goodsState"))){
				shangjiaService.goodsChangeState(pd);
				respCode="01";
				respMsg="成功";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 删除商品
	 * @throws Exception 
	 */
	@RequestMapping(value="/deleteGoods")
	@ResponseBody
	public Object deleteGoods()throws Exception{
		logBefore(logger, "---删除商品---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String result = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if (Tools.notEmpty(pd.getString("goods_id"))) {
				shangjiaService.goodsdelete(pd);
				result = "01";
				respMsg="成功!";
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", result);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	//TODO 商家订单部分
	/**
	 * 商家历史订单主页以及主页内的今日完成的订单、本月完成订单、已完成订单（请求的为同一接口）
	 * @return
	 */
	@RequestMapping(value="/liShiWanChengOrderList")
	@ResponseBody
	public Object liShiWanChengOrderList(){
		logBefore(logger, "---商家历史订单主页以及主页内的今日完成的订单、本月完成订单、已完成订单（请求的为同一接口）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "请求失败，程序出现异常，请联系管理人员";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//根据商家的主键ID，获取其下所有当日的订单信息
			PageData tempPd=new PageData();
			if(pd.getString("markNum").equals("1")){
				tempPd.put("nowTime", DateUtil.getDay());//当天时间yyyy-MM-dd
			}else if(pd.getString("markNum").equals("2")){
				tempPd.put("nowTime", DateTimeUtil.formateYearAndMonth(new Date()));//当月时间yyyy-MM
			}
			//当markNum="3"的时候，不产生nowTime条件
			tempPd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
			tempPd.put("orderStateShangjia", "5");
			List<PageData> list1=shangjiaOrderService.getOrderList(tempPd);
			//根据条件获取订单的数量
			PageData temp=shangjiaOrderService.getOrderNumberByTiaoJian(tempPd);
			List liShiWanChengOrderList=new ArrayList<PageData>();
			for(PageData pd1:list1){
				PageData dataPd=new PageData();
				dataPd.put("orderTime", pd1.get("orderTime"));
				dataPd.put("qucan_number", "S"+pd1.get("qucan_number").toString());
				dataPd.put("linkmanName", pd1.getString("linkmanName"));
				dataPd.put("identity", pd1.getString("identity"));
				dataPd.put("phone", pd1.getString("kehuphone"));
				dataPd.put("detailAddress", pd1.getString("detailAddress"));
				dataPd.put("canhefei", pd1.get("canhefei"));
				dataPd.put("peisongfei", pd1.get("peisongfei"));
				dataPd.put("order_remark", pd1.getString("order_remark"));
				dataPd.put("xiaoji", pd1.get("xiaoji"));
				dataPd.put("fuwufei", pd1.get("fuwufei"));
				dataPd.put("yujishouru", pd1.get("yujishouru"));
				String goodsNum[] =pd1.get("goodsNum").toString().split(",");
				String goodsName[] =pd1.getString("goodsName").split(",");
				String zhiding_shangpin_zongjia[] =pd1.getString("zhiding_shangpin_zongjia").split(",");
				List<PageData> list2=new ArrayList<PageData>();
				for(int i=0;i<goodsNum.length;i++){
					PageData sppd = new PageData();
					sppd.put("goodsNum", goodsNum[i]);
					sppd.put("goodsName", goodsName[i]);
					sppd.put("feiyong", zhiding_shangpin_zongjia[i]);
					list2.add(sppd);
					//pd2.put("shangpinList", shangpinList);
				}
				dataPd.put("shangpinList", list2);
				liShiWanChengOrderList.add(dataPd);
			}
			map.put("liShiWanChengOrderList", liShiWanChengOrderList);
			map.put("number", temp.get("number").toString());
			respCode="01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 订单大厅部分
	/**
	 * 商家订单管理主页以及主页内的新订单、待取餐、进行中、已完成（请求的为同一接口）
	 * @return
	 */
	@RequestMapping(value="/dingDanGuanLiOrderList")
	@ResponseBody
	public Object dingDanGuanLiOrderList(){
		logBefore(logger, "---商家订单管理主页以及主页内的新订单、待取餐、进行中、已完成（请求的为同一接口）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String respCode = "00";
		String respMsg = "请求失败，程序出现异常，请联系管理人员";
		try {
			//根据backCode获取缓存信息
			PageData cacheData=shangjiaService.getDataByBackCode(pd);
			//根据商家的主键ID，获取其下所有当日的新订单、待取餐、进行中、已完成订单信息
			PageData tempPd=new PageData();
			tempPd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
			tempPd.put("nowTime", DateUtil.getDay());//当天时间yyyy-MM-dd
			if(pd.getString("markNum").equals("1")){//新订单
				tempPd.put("orderStateKehu", "2");
				tempPd.put("orderStateShangjia", "1");
			}else if(pd.getString("markNum").equals("2")){//待取餐
//				tempPd.put("orderStateQishou", "6");
				tempPd.put("orderStateShangjia", "2");
			}else if(pd.getString("markNum").equals("3")){//进行中
				tempPd.put("orderStateQishou", "2");
				tempPd.put("orderStateShangjia", "4");
			}else if(pd.getString("markNum").equals("4")){//已完成
				tempPd.put("orderStateQishou", "3");
				tempPd.put("orderStateShangjia", "5");
			}
			List<PageData> list1=shangjiaOrderService.getOrderList(tempPd);
			List dingDanGuanLiOrderList=new ArrayList<PageData>();
			for(PageData pd1:list1){
				PageData dataPd=new PageData();
				dataPd.put("orderTime", pd1.get("orderTime"));
				/*if(pd.getString("markNum").equals("1")){
					dataPd.put("reqsTime", DateUtil.gethourAndminute(pd1.getString("orderTime"), 15));
				}*/
				dataPd.put("order_takeou_id", pd1.getString("order_takeou_id"));
				dataPd.put("deliveryMode", pd1.getString("deliveryMode"));
				dataPd.put("mjyh", pd1.getString("mjyh"));
				dataPd.put("xyhli", pd1.getString("xyhli"));
				dataPd.put("mjpsf", pd1.getString("mjpsf"));
				dataPd.put("qucan_number", "S"+pd1.get("qucan_number"));
				dataPd.put("linkmanName", pd1.getString("linkmanName"));
				dataPd.put("identity", pd1.getString("identity"));
				dataPd.put("phone", pd1.getString("kehuphone"));
				dataPd.put("qishouPhone", pd1.getString("qishouPhone"));
				dataPd.put("detailAddress", pd1.getString("detailAddress"));
				dataPd.put("canhefei", pd1.get("canhefei").toString());
				dataPd.put("peisongfei", pd1.get("peisongfei").toString());
				dataPd.put("order_remark", pd1.getString("order_remark"));
				dataPd.put("xiaoji", pd1.get("xiaoji").toString());
				dataPd.put("fuwufei", pd1.get("fuwufei").toString());
				dataPd.put("yujishouru", pd1.get("yujishouru").toString());
				String goodsNum[] =pd1.get("goodsNum").toString().split(",");
				String goodsName[] =pd1.getString("goodsName").split(",");
				String zhiding_shangpin_zongjia[] =pd1.getString("zhiding_shangpin_zongjia").split(",");
				List<PageData> list2=new ArrayList<PageData>();
				for(int i=0;i<goodsNum.length;i++){
					PageData sppd = new PageData();
					sppd.put("goodsNum", goodsNum[i]);
					sppd.put("goodsName", goodsName[i]);
					sppd.put("feiyong", zhiding_shangpin_zongjia[i]);
					list2.add(sppd);
					//pd2.put("shangpinList", shangpinList);
				}
				dataPd.put("shangpinList", list2);
				dingDanGuanLiOrderList.add(dataPd);
			}
			map.put("dingDanGuanLiOrderList", dingDanGuanLiOrderList);
			respCode="01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 修改订单状态（1.商家15分钟内未受理，系统自动取消订单;2.商家受理;3.商家取消受理;）
	 * @return
	 */
	@RequestMapping(value="/update_order_state")
	@ResponseBody
	public Object update_order_state(){
		logBefore(logger, "---修改订单状态（1.商家15分钟内未受理，系统自动取消订单;2.商家受理;3.商家取消受理;）--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//测试时,传递的参数,之后删除
		//pd.put("order_takeou_id", "2");
		//pd.put("markNum", "systemQuXiaoOrder");
		//pd.put("markNum", "shangJiaShouLi"); 
		//pd.put("markNum", "shangJiaQuXiaoShouLi"); 
		String respCode = "00";
		String respMsg = "请求失败，程序出现异常，请联系管理人员";
		
		String deliveryMode="";
		String reward="";
		
		try {
			if(pd.getString("markNum").equals("1")){
				pd.put("orderStateShangjia", "6");//6系统取消
				pd.put("orderStateKehu", "7");//7系统取消
			}else if(pd.getString("markNum").equals("2")){
				
				deliveryMode=pd.getString("deliveryMode");
				reward=pd.getString("reward");
				
				//商家选择第三方配送时,对骑手段进行推送
				if(deliveryMode.equals("1")){
					
					pd.put("orderStateShangjia", "2");//2-已受理
					pd.put("orderStateKehu", "3");//3待发货
					
					Map<String,Object> maps = new HashMap<String,Object>();
					maps.put("jump", "0");//0跳转到骑手新任务
					maps.put("mp3", "xxx.mp3");
					maps.put("notification_title", "任务大厅有新任务了！");
					maps.put("msg_title", "你有新任务啦！");
					maps.put("time", System.currentTimeMillis());
					System.out.println("受理时间"+maps.put("time", System.currentTimeMillis()));
					String extrasparam = new Gson().toJson(maps);
					JpushClientUtil.sendToAllQishou("任务大厅有新任务了！", "你有新任务啦！", "有新任务", extrasparam);//商家已受理成功后，将订单推送给所有骑手。
					JpushClientUtil.ios_sendToAllQishou("任务大厅有新任务了！", "你有新任务啦！", "有新任务", extrasparam);//商家已受理成功后，将订单推送给所有骑手。
					System.out.println(".........商家点击已受理后+执行推送给全部骑手用户（安卓和ios）.........");
				}else {//选择自送时,跳过待取餐,直接到进行中
					pd.put("orderStateQishou", "2");
					pd.put("orderStateShangjia", "4");
					pd.put("orderStateKehu", "4");//待收货
				}
				
			}else if(pd.getString("markNum").equals("3")){
				pd.put("orderStateShangjia", "0");
				pd.put("orderStateKehu", "0");
			}
			
			pd.put("deliveryMode", deliveryMode);
			pd.put("reward", reward);
			shangjiaOrderService.update_order_state(pd);
			respCode="01";
			respMsg="成功";
		}catch (Exception e){
			e.printStackTrace();
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 商家系统消息
	 * @throws Exception 
	 */
	@RequestMapping(value="/systemMessage")
	@ResponseBody
	public Object systemMessage()throws Exception{
		logBefore(logger, "---商家系统消息---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "失败";
		String result = "00";
		try {
			List<PageData> List = shangjiaService.systemMessage(pd);
			result = "01";
			msg="成功!";
			map.put("resultList", List);
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respCode", result);
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 设置是否已读状态
	 * @throws Exception 
	 */
	@RequestMapping(value="/setStatus")
	@ResponseBody
	public Object setStatus()throws Exception{
		logBefore(logger, "---设置是否已读状态---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "失败";
		String result = "00";
		try {
			PageData sData = shangjiaService.querySysMessage(pd);
			if (sData == null) {
				result = "00";
				map.put("respCode", result);
				msg="消息(sys_message_id)出错啦!";
			}else{
				if (Tools.isEmpty(pd.getString("sys_message_id"))) {
					result = "00";
					map.put("respCode", result);
					msg="请求协议参数不能为空";
				}else {
					shangjiaService.setStatus(pd);
					result = "01";
					msg="设置已读成功!";
				}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respCode", result);
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 商家系统消息
	 * @return
	 */
	@RequestMapping(value="/goSysMessage")
	public ModelAndView goSysMessage(){
		logBefore(logger, "------商家系统消息-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "saveinsert");
		mv.setViewName("information/shangJia/sysxiaoxi");
		return mv;
	}
	
	/**
	 * 我的收入
	 * @throws Exception 
	 */
	@RequestMapping(value="/queryMywallet")	
	@ResponseBody
	public Object queryMywallet(HttpServletRequest request)throws Exception{
		logBefore(logger, "---我的收入---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		PageData pdresult= new PageData();
		String respMsg = "失败！";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				respMsg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					respMsg="缓存信息失效,请重新登录";
				}else {
					pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					//今日总收入
					PageData income = shangjiaService.queryIncomeToday(pd);
					//我的账户余额 、今日收入、总资产
					PageData Accounts = shangjiaService.queryAccountbalance(pd);
					//我的账户余额
					String a = income.get("sum").toString();//从订单表合计的今日收入
					String s = Accounts.get("Amount").toString();//我的账户余额
					String c = Accounts.get("Incometoday").toString();//我的今日总额收入
					String d = Accounts.get("totalassets").toString();//我的总资产
					
					double Incometodays =Double.parseDouble(c);//我的今日收入类型转换
					double IncometodaySum = Double.parseDouble(a);//从订单表合计的今日收入类型转换
					if (IncometodaySum == 0) {
						double jiri = IncometodaySum - Incometodays*0;
						System.out.println(jiri);
						double Accountsum = jiri +  Double.parseDouble(s);//我的账户余额 = 今日收入 + 账户余额
						pd.put("Incometoday", jiri);//今日收入
						pd.put("Amount", Accountsum);//我的账户余额
						pd.put("totalassets", Accountsum);//总资产
						shangjiaService.setMywallet(pd);
						result = "01";
						map.put("respCode", result);
						respMsg="计算成功";
					}else{
						if (Incometodays > IncometodaySum) {
//								double jiri = Incometodays - IncometodaySum;
							double Accountsum = IncometodaySum +  Double.parseDouble(s);//我的账户余额 = 今日收入 + 账户余额
							double jiris = Incometodays + IncometodaySum;
							pd.put("Incometoday", jiris);//今日收入
							pd.put("Amount", Accountsum);//我的账户余额
							pd.put("totalassets", Accountsum);//总资产
							shangjiaService.setMywallet(pd);//存入账户余额和今日收入
							result = "01";
							map.put("respCode", result);
							respMsg="计算成功";
						}else{
							if (!Accounts.get("Incometoday").equals(IncometodaySum)) {
//							double jiri = yuanshi - today;
								double jiri = IncometodaySum - Incometodays;
								double Accountsum = jiri +  Double.parseDouble(s);//我的账户余额 = 今日收入 + 账户余额
								double jiris = Incometodays + jiri;
								pd.put("Incometoday", jiris);//今日收入
								pd.put("Amount", Accountsum);//我的账户余额
								pd.put("totalassets", Accountsum);//总资产
								shangjiaService.setMywallet(pd);//存入账户余额和今日收入
								result = "01";
								map.put("respCode", result);
								respMsg="计算成功";
							}else{
								if (IncometodaySum > Incometodays) {
									double jiri = IncometodaySum - Incometodays;
									double Accountsum = jiri +  Double.parseDouble(s);//我的账户余额 = 今日收入 + 账户余额
									double jiris = Incometodays + jiri;
									pd.put("Incometoday", jiris);//今日收入
									pd.put("Amount", Accountsum);//我的账户余额
									pd.put("totalassets", Accountsum);//总资产
									shangjiaService.setMywallet(pd);//存入账户余额和今日收入
									result = "01";
									map.put("respCode", result);
									respMsg="计算成功";
								}
								double jiri = IncometodaySum - Incometodays;
								if (!Accounts.get("Incometoday").equals(jiri)) {//判断今日收入金额是否相等
									double Accountsum = jiri +  Double.parseDouble(s);//我的账户余额 = 今日收入 + 账户余额
									pd.put("Incometoday", Incometodays);//今日收入
									pd.put("Amount", Accountsum);//我的账户余额
									pd.put("totalassets", Accountsum);//总资产
									shangjiaService.setMywallet(pd);//存入账户余额和今日收入
									result = "01";
									map.put("respCode", result);
									respMsg="计算成功";
								}else{
									result = "00";
									map.put("respCode", result);
									respMsg="失败";
								}
								
							}
						}
					}
					pd.put("phone", cacheData.getString("phone"));
					PageData GeRZL = shangjiaService.getDataByPhone(pd);
					pdresult.put("Amount", GeRZL.get("Amount"));//我的账户余额
					pdresult.put("Incometoday", GeRZL.get("Incometoday"));//今日收入
					pdresult.put("totalassets", GeRZL.get("totalassets"));//总资产
					pdresult.put("goExplain", BaseController.getPath(request)+"api/shangjia/goExplain.do");//提现说明
					result = "01";
					map.put("respCode", result);
					map.put("resultList", pdresult);
					respMsg="计算成功";
						
				}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 添加银行卡信息确认
	 * @throws Exception 
	 */
	@RequestMapping(value="/insertBankCard")
	@ResponseBody
	public Object insertBankCard(){
		logBefore(logger, "---添加银行卡信息确认---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respMsg = "失败";
		String result = "00";
		String bankName = pd.getString("bankName");//银行卡的类型(所属银行)
		String cardNumber = pd.getString("cardNumber");//银行卡号
		String userName = pd.getString("userName");//姓名
		String phone = pd.getString("phone");//手机号码
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				respMsg="backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					respMsg="缓存信息失效,请重新登录";
				}else{
					if(Tools.isEmpty(bankName)||Tools.isEmpty(cardNumber)|| Tools.isEmpty(userName)|| Tools.isEmpty(phone)){
							result = "00";
							map.put("respCode", result);
							respMsg="请求协议参数不能为空";
					}else{
//							if (!cacheData.getString("phone").equals(pd.getString("phone"))) {//判断手机号码是否匹配
//								result = "00";
//								map.put("respCode", result);
//								respMsg="请您输入本人手机号码";
//							}else{
								cacheData.put("phone", cacheData.getString("phone"));
								PageData queryGeRZL = shangjiaService.getDataByPhone(cacheData);//查询姓名是否匹配
								if (!queryGeRZL.getString("realName").equals(pd.getString("userName"))) {
									result = "00";
									map.put("respCode", result);
									respMsg="请输入本的人真实姓名";
								}else{
									PageData BankCard = shangjiaService.queryBankCardCardNumber(pd);//查询银行卡信息是否从复
									if (BankCard != null) {
										result = "00";
										map.put("respCode", result);
										respMsg="该银行卡号已经存在";
									}else{
										pd.put("userName", queryGeRZL.getString("realName"));//姓名
										pd.put("phone", phone);//手机号
										pd.put("bank_card_id", this.get32UUID());
										pd.put("bankName", bankName);//银行卡的类型(所属银行)
										pd.put("cardNumber", cardNumber);//银行卡号
										pd.put("user_fid", cacheData.getString("user_shangjia_fid"));
										pd.put("create_time", DateUtil.getTime());//创建时间
										pd.put("status", 0);//(0-正常使用中，1-默认使用中）
										pd.put("bz", "商家端app用户");
										shangjiaService.insertBankCard(pd);
										result = "01";
										map.put("respCode", result);
										map.put("payPwdStatus",queryGeRZL.getString("payPwdStatus"));//返回支付密码状态（0-未设置，1-已设置）
										respMsg="添加成功";
									}
								}
//							}
						}
				}
			}
		}catch (Exception e){
				e.printStackTrace();
				logger.error(e.toString(), e);
				map.put("respCode", result);
				respMsg="失败";
		}
		map.put("respCode", result);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 设置支付密码
	 * @throws Exception 
	 */
	@RequestMapping(value="/setzhifupwd")
	@ResponseBody
	public Object setzhifupwd()throws Exception{
		logBefore(logger, "---设置支付密码--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				msg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					msg="缓存信息失效,请重新登录";
					}else {
						String phone = pd.getString("phone");
						pd.put("phone", phone);	//手机号
						String pwd = pd.getString("payPassword");
						PageData pds = shangjiaService.getDataByPhone(pd);//查询判断用户是否存在
						if (Tools.isEmpty(pwd)) {
							result = "00";
							map.put("respCode", result);
							msg="（payPassword）支付密码不能为空";
						}else if(pds!=null){
							pd.put("payPassword", MD5.md5(pwd));//密码
							shangjiaService.updateZhiFuPwd(pd);//修改密码
							result = "01";
							map.put("respCode", result);
							msg="支付密码已设置成功";
						}else{
							result = "00";
							map.put("respCode", result);
							msg = "该手机号不是支付手机号!";
						}
					}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 我的银行卡管理列表
	 * @throws Exception 
	 */
	@RequestMapping(value="/queryBankCardList")
	@ResponseBody
	public Object queryBankCardList()throws Exception{
		logBefore(logger, "---我的银行卡管理列表---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respMsg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				respMsg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					respMsg="缓存信息失效,请重新登录";
				}else{
					
					pd.put("phone", cacheData.getString("phone"));
					pd.put("user_fid", cacheData.getString("user_shangjia_fid"));
					PageData queryGeRZL = shangjiaService.getDataByPhone(pd);
					List<PageData> List = shangjiaService.queryBankCardList(pd);//我的银行卡管理列表
					if (List.size() == 0) {
						result = "01";
						map.put("respCode", result);
						respMsg="您还未添加银行卡，暂时无数据";
						map.put("resultList", List);
						map.put("payPwdStatus",queryGeRZL.getString("payPwdStatus"));//返回支付密码状态（0-未设置，1-已设置）
					}else{
						result = "01";
						respMsg="成功!";
						map.put("respCode", result);
						map.put("resultList", List);
						map.put("payPwdStatus",queryGeRZL.getString("payPwdStatus"));//返回支付密码状态（0-未设置，1-已设置）
					}
				}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 银行卡解绑
	 * @throws Exception 
	 */
	@RequestMapping(value="/unbundlingCardNumber")
	@ResponseBody
	public Object unbundlingCardNumber()throws Exception{
		logBefore(logger, "---银行卡解绑---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				msg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					msg="缓存信息失效,请重新登录";
					}
					if (Tools.isEmpty(pd.getString("bank_card_id"))) {
						result = "00";
						map.put("respCode", result);
						msg="bank_card_id（银行卡id）请求参数不能为空";
					}else{
						shangjiaService.unbundlingCardNumber(pd);//解绑
						result = "01";
						map.put("respCode", result);
						msg="解绑成功";
					}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 提取现金
	 * @throws Exception 
	 */
	@RequestMapping(value="/insertWithdrawCash")
	@ResponseBody
	public Object insertWithdrawCash(){
		logBefore(logger, "---提取现金---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "失败";
		String result = "00";
		String zhichu_amount = pd.getString("zhichu_amount");//支出金额
		String cardNumber = pd.getString("cardNumber");//银行卡号
		String payPassword = pd.getString("payPassword");//提现密码
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				msg="backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					msg="缓存信息失效,请重新登录";
				}else{
					if(Tools.isEmpty(zhichu_amount)||Tools.isEmpty(cardNumber)){
							result = "00";
							map.put("respCode", result);
							msg="请求参数不能为空";
					}else{
							pd.put("phone", cacheData.getString("phone"));
							PageData BankCard = shangjiaService.queryBankCardCardNumber(pd);//查询银行卡信息是否匹配
							if (BankCard == null) {
								result = "00";
								map.put("respCode", result);
								msg="选择正确的银行卡";
							}else{
								pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
								PageData Account = shangjiaService.queryAccountbalance(pd);//我的账户余额
								String s = Account.get("Amount").toString();//我的账户余额
								String e = pd.get("zhichu_amount").toString();//提现余额
								double Amount = Double.parseDouble(s);
								double zhichuamount = Double.parseDouble(e);//提现金额
								System.out.println(zhichuamount);
								
								if (zhichuamount >= Amount) {//判断提现金额是否超过账户余额
									result = "00";
									map.put("respCode", result);
									msg="金额已超过可提现余额";
								}else{
									String payPwd="";
									payPwd = MD5.md5(payPassword); //密码加密
									PageData payPasswords = shangjiaService.getDataByPhone(pd);//查询密码
									if (!payPasswords.getString("payPassword").equals(payPwd)) {//判断提现密码是否匹配
										result = "00";
										map.put("respCode", result);
										msg="支付密码错误";
									}else{
										double zhichuamounts = Amount - zhichuamount;//账户金额 = 账户余额 - 支出金额
										pd.put("serial_number", this.getNumberForPK());//流水号
										pd.put("bank_card_tixian_id", this.get32UUID());
										pd.put("tixian_type", "提现");//类型
										pd.put("zhichu_amount", zhichuamount);//提现金额
										pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));//骑手外键id
										pd.put("bank_card_fid", BankCard.getString("bank_card_id"));//银行卡外键id
										pd.put("bankName", BankCard.getString("bankName"));//银行卡的类型(所属银行)
										pd.put("cardNumber", BankCard.getString("cardNumber"));//银行卡号
										pd.put("phone", BankCard.getString("phone"));//提现手机号码
										pd.put("realName", BankCard.getString("realName"));//提现姓名
										pd.put("tixian_time", DateUtil.getTime());//提现时间
										pd.put("bank_card_status", "受理中");//提现受理状态(0-正在受理中，1-已受理完成)
										pd.put("Amount", zhichuamounts);//我的账户余额
										shangjiaService.insertWithdrawCash(pd);//提取现金
										
										pd.put("totalassets", zhichuamounts);//总资产
										shangjiaService.setAccountAndAssets(pd);//存入计算出，提现后的剩下的余额
										result = "01";
										map.put("respCode", result);
										msg="提现成功!";
									}
									
								}
								
							}
						}
				}
			}
		}catch (Exception e){
				e.printStackTrace();
				logger.error(e.toString(), e);
				map.put("respCode", result);
				msg="失败";
		}
		map.put("respCode", result);
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 我的账单明细列表
	 * @throws Exception 
	 */
	@RequestMapping(value="/queryBillingDetailsList")
	@ResponseBody
	public Object queryBillingDetailsList()throws Exception{
		logBefore(logger, "---我的账单明细列表---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String msg = "";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				map.put("respCode", result);
				msg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					map.put("respCode", result);
					msg="缓存信息失效,请重新登录";
				}else{
					pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					List<PageData> List = shangjiaService.queryBillingDetailsList(pd);//我的账单明细列表
					if (List.size() == 0) {
						result = "01";
						msg = "暂时无数据";
						map.put("respCode", result);
						map.put("resultList", List);
					}else {
						result = "01";
						msg="成功!";
						map.put("respCode", result);
						map.put("resultList", List);
					}
				}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respCode", result);
		map.put("respMsg", msg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 是否营业
	 * @throws Exception 
	 */
	@RequestMapping(value="/isupdateStart")
	@ResponseBody
	public Object isupdateStart()throws Exception{
		logBefore(logger, "---是否营业---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respMsg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				respMsg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					respMsg="缓存信息失效,请重新登录";
				}else{
//					pd.put("phone", cacheData.getString("phone"));
//					PageData GeRZL = shangjiaService.getDataByPhone(pd);
					pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
					//判断是否开工状态
					if(Tools.isEmpty(pd.getString("isOpen"))){
						result = "00";
						map.put("respCode", result);
						respMsg="请求参数不能为空";
					}else {
						PageData sData = shangjiaService.querytbOrderTakeou(pd);
						int key = Integer.parseInt(sData.get("yishuoli").toString());//2-已受理
						int keyi = Integer.parseInt(sData.get("daiqucan").toString());//3待取餐
						int keys = Integer.parseInt(sData.get("jinxingzhong").toString());//4进行中
						if ( key>=1 || keyi>=1 || keys >=1) {
							result = "00";
							map.put("respCode", result);
							respMsg="您有未完成的订单";
						}else {
							shangjiaService.isupdateStart(pd);//是否营业
							result = "01";
							map.put("respCode", result);
							map.put("isOpen", pd.getString("isOpen"));
							respMsg="成功";
						}
					}
			}
		 }
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 今日数据接单与合计总数
	 * @throws Exception 
	 */
	@RequestMapping(value="/queryCount")
	@ResponseBody
	public Object queryCount(HttpServletRequest request)throws Exception{
		logBefore(logger, "---今日数据接单与合计总数---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respMsg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				respMsg="操作失败，请先登录，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				if(cacheData==null){
					result = "00";
					respMsg="缓存信息失效,请重新登录";
				}else{
					pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
					PageData Count = shangjiaService.queryCount(pd);//今日数据接单与合计总数
					result = "01";
					map.put("respCode", result);
					map.put("resultList", Count);
					respMsg="成功";
				}
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
			map.put("respCode", result);
			map.put("respMsg", "失败");
			map.put("respMsg", e.getMessage());
		}
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 商家提现说明
	 * @return
	 */
	@RequestMapping(value="/goExplain")
	public ModelAndView goExplain(){
		logBefore(logger, "------商家提现说明-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "saveinsert");
		mv.setViewName("information/shangJia/tixian");
		return mv;
	}
	
	
	/**
	 * 商家端更新设备标识ID
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-10
	 */
	@RequestMapping(value="/updateShangjiaRegistrationID")
	@ResponseBody
	public Object updateShangjiaRegistrationID(HttpServletRequest request)throws Exception{
		logBefore(logger, "---商家端更新设备标识ID---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respMsg = "失败";
		String result = "00";
		try {
			if(Tools.isEmpty(pd.getString("backCode"))){
				result = "00";
				respMsg="操作失败，backCode不能为空";
			}else{
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				pd.put("RegistrationID", pd.get("RegistrationID"));
				pd.put("RegistrationType", pd.get("RegistrationType"));//设备类型
				pd.put("user_shangjia_id", cacheData.getString("user_shangjia_fid"));
				shangjiaService.updateShangjiaRegistrationID(pd);
				result = "01";
				map.put("respCode", result);
				respMsg="成功";
				
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
		}
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	//TODO 门店运营中我的评价
	/**
	 * 商家评价主页
	 * @throws Exception 
	 */
	@RequestMapping(value="/getEvaluateList")
	@ResponseBody
	public Object getEvaluateList()throws Exception{
		logBefore(logger, "---商家评价主页---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("backCode"))){
				//根据backCode获取缓存信息
				PageData cacheData = shangjiaService.getDataByBackCode(pd);
				
				pd.put("user_shangjia_fid", cacheData.getString("user_shangjia_fid"));
				List<PageData> dataList = shangjiaService.getEvaluateList(pd);
				for (PageData temp:dataList) {
					temp.put("headImg", BaseController.getPath(getRequest())+temp.getString("headImg"));
				}
				map.put("dataList", dataList);
				
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 商家回复
	 * @throws Exception 
	 */
	@RequestMapping(value="/evaluateAnswer")
	@ResponseBody
	public Object evaluateAnswer()throws Exception{
		logBefore(logger, "---商家回复---");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String respCode = "00";
		String respMsg = "失败,请求参数不完整";
		try {
			if(Tools.notEmpty(pd.getString("evaluate_id")) && Tools.notEmpty(pd.getString("content"))){
				
				pd.put("evaluate_answer_id", this.get32UUID());
				pd.put("time", DateUtil.getTime());
				shangjiaService.evaluateAnswer(pd);
				
				respCode = "01";
				respMsg="成功";
			}
		}catch (Exception e){
			logger.error(e.toString(), e);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
}
