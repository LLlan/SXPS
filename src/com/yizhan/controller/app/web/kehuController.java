package com.yizhan.controller.app.web;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import oracle.net.aso.s;

import org.apache.james.mime4j.field.datetime.DateTime;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import sun.text.normalizer.NormalizerBase.Mode;

import com.google.gson.Gson;
import com.hp.hpl.sparta.xpath.ThisNodeTest;
import com.yizhan.controller.app.jpushModel.JpushClientUtil;
import com.yizhan.controller.base.BaseController;
import com.yizhan.entity.information.KeHu;
import com.yizhan.service.app.shangjia.ShangjiaService;
import com.yizhan.service.information.h5sys.h5sysService;
import com.yizhan.service.information.kehu.kehuService;
import com.yizhan.service.information.notice.NoticeService;
import com.yizhan.util.AppUtil;
import com.yizhan.util.Const;
import com.yizhan.util.DateTimeUtil;
import com.yizhan.util.DateUtil;
import com.yizhan.util.FileUpload;
import com.yizhan.util.FormateUtil;
import com.yizhan.util.LocationUtils;
import com.yizhan.util.MD5;
import com.yizhan.util.PageData;
import com.yizhan.util.PathUtil;
import com.yizhan.util.SmsUtil;
import com.yizhan.util.Tools;

@Controller
@RequestMapping("/api/kehu")
public class kehuController extends BaseController {
	
	@Resource(name="kehuService")
	private kehuService kehuService;
	
	@Resource(name="h5sysService")
	private h5sysService h5sysService;
	
	@Resource(name="noticeService")
	private NoticeService noticeService;
	
	@Resource(name="shangjiaService")
	private ShangjiaService shangjiaService;
	/**
	 * 登录页面
	 * @return
	 */
	@RequestMapping(value="/toLogin")
	public ModelAndView tologin(){
		logBefore(logger, "---toLogin---登录页面-----");
		ModelAndView mv = new  ModelAndView();
		mv.setViewName("kehuduan/login");
		return mv;
	}
	
	/**
	 * 执行登录
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/login")
	@ResponseBody
	public Object login(HttpSession session,HttpServletRequest request) throws Exception{
		logBefore(logger, "--执行登录--");
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		PageData tempPd=new PageData();
		String respCode = "";
		String respMsg="";
		tempPd.put("phone", pd.getString("phone"));
		tempPd.put("loginPassword", MD5.md5(pd.getString("password")));
		PageData tempData=kehuService.getDataByPhoneAndPassWord(tempPd);
		PageData result =  kehuService.getUserDataByPhone(tempPd);
		if(result==null){
			respCode="02";
			respMsg="该用户还未注册!";
		}else if(tempData==null){
			respCode="00";
			respMsg="账号或密码错误！";
		}else {
			respCode="01";
			respMsg="登录成功!";
			//创建session
			KeHu kehu=new KeHu();
			kehu.setUser_kehu_id(tempData.getString("user_kehu_id"));
			kehu.setPhone(tempData.getString("phone"));
			session.setAttribute("h5User",kehu);
			//更新登录时间和登录IP
			PageData temp=new PageData();
			temp.put("last_login_time", DateUtil.getTime());//最近登陆时间	
			temp.put("ip", request.getRemoteHost());//ip地址	
			temp.put("user_kehu_id", tempData.getString("user_kehu_id"));
			kehuService.updateLoginTimeAndIp(temp);
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 进入注册页面
	 * @return
	 */
	@RequestMapping(value="/toRegister")
	public ModelAndView toRegister(){
		logBefore(logger, "--进入注册页面--");
		ModelAndView mv=new ModelAndView();
		mv.setViewName("kehuduan/zhuce");
		return mv;
	}
	
	/**
	 * 获取短信验证码
	 * @return
	 */
	@RequestMapping(value="/getSms")
	@ResponseBody
	public Object getSms(){
		logBefore(logger, "--获取短信验证码--");
		PageData pd = new PageData();
		pd= this.getPageData();
		Map<String,String> map = new HashMap<String,String>();
		String phone = pd.getString("phone");
		map = SmsUtil.sendMsM(phone);
		map.put("phone", phone);
		if(map.size()>0){
			map.put("reqCode", "01");
		}else{
			map.put("reqCode", "00");
		}
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 注册
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/register")
	@ResponseBody
	public Object register(HttpServletRequest request) throws Exception{
		logBefore(logger, "--注册--");
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		//根据用户名或者手机号查询对象信息
		PageData tempPhone=kehuService.getUserDataByPhone(pd);
		String respCode = "";
		String respMsg="";
			if(tempPhone!=null){//
				respCode="00";
				respMsg="注册失败，该手机号已经注册！";
			}else{
				respCode="01";
				respMsg="注册成功！";
				pd.put("user_kehu_id", this.get32UUID());	//主键
				pd.put("phone", pd.getString("phone"));	
				pd.put("loginPassword", MD5.md5(pd.getString("password")));	
//				pd.put("headImg","");	
				pd.put("userName","用户"+DateUtil.getTimeStamp());
//				pd.put("payPassword","");
				pd.put("registerTime", DateUtil.getTime());//注册时间	
				pd.put("last_login_time",DateUtil.getTime());//最近登陆时间	
				pd.put("ip", request.getRemoteHost());//ip地址
				pd.put("status", 1); //1 使用中 0 已停用
				pd.put("bz", "");	
				kehuService.saveU(pd);
			}
			map.put("respCode", respCode);
			map.put("respMsg", respMsg);
		return AppUtil.returnObject(pd, map);
	}
	
	
	/**
	 *  忘记密码
	 * @return
	 */
	@RequestMapping(value="/wangjimima")
	public ModelAndView wangjimima(){
		logBefore(logger, "--忘记密码--");
		ModelAndView mv=new ModelAndView();
		PageData pd = this.getPageData();
		if(pd.get("tag").equals("1")){
			mv.setViewName("kehuduan/forget1");
		}else{
			mv.setViewName("kehuduan/forget2");
		}
		mv.addObject("phone", pd.get("phone"));
		return mv;
	}
	
	
	/**
	 * 执行修改密码
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/changepwd")
	@ResponseBody
	public Object changepwd(HttpSession session,HttpServletRequest request) throws Exception{
		logBefore(logger, "--执行修改密码--");
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		String respCode = "";
		String respMsg = "";
		PageData tempPd=new PageData();
		//根据手机号查询对象信息
		PageData tempPhone=kehuService.getUserDataByPhone(pd);
		if (tempPhone!=null){
			tempPd.put("phone", pd.getString("phone"));
			tempPd.put("loginPassword", MD5.md5(pd.getString("newPassword")));
			kehuService.updatePasswordByPhone(tempPd);
			respCode="01";
			respMsg="密码修改成功！";
		}else{
			respCode="00";
			respMsg="该账号还未注册，请您去注册！";
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		return AppUtil.returnObject(pd, map);
	}
	
	
	/**
	 * 美食外卖商家页面列表(距离最近)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/shopsTwo")
	public ModelAndView shopsTwo() throws Exception{
		logBefore(logger, "---shopsTwo--美食外卖商家页面列表(距离最近)---");
		ModelAndView mv = new  ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		List<PageData> ShangjiaList = kehuService.businessList(pd);
		mv.addObject("pd",ShangjiaList);
		mv.setViewName("kehuduan/shopcart/shopsTwo");
		return mv;
	}
	
	
	/**
	 * 去商家详情页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/shop")
	public ModelAndView shop() throws Exception{
		logBefore(logger, "--shop---去商家详情页面---");
		ModelAndView mv = new  ModelAndView();
		PageData pd = new PageData();
		PageData pds = new PageData();
		pd = this.getPageData();
		List reseltlist = new ArrayList();
		
		mv.addObject("user_shangjia_id", pd.getString("user_shangjia_id"));
		pd.put("user_shangjia_id", pd.getString("user_shangjia_id"));
		pd.put("categoryName", pd.getString("categoryName"));
		pd.put("yearsAndmonth", DateTimeUtil.formateYearAndMonth(new Date()));
		System.out.println(DateTimeUtil.formateYearAndMonth(new Date())+"****************");
		
		//获取商家信息
		PageData shangjiaData = kehuService.queryUserShangjia(pd);
		
		//运费信息
		List<PageData> freightList=shangjiaService.getFreightOfShangJia(pd);
		mv.addObject("freightList", freightList);
		
		//超重收费信息
		PageData weightBeyondPd=shangjiaService.getWeightBeyondOfShangJia(pd);
		mv.addObject("weightBeyondPd", weightBeyondPd);
		
		//查出所有商品种类
		List<PageData> goodsCategoryList = kehuService.goodsCategoryList(pd);
		
		for(PageData pdselect:goodsCategoryList){
			//查本月销售量
			pdselect.put("currentMonth", DateTimeUtil.formateYearAndMonth(new Date()));
			//查出某个商家下的所有商品 by yym 
			List<PageData> goodsList =  kehuService.getDataByCategoryNameAndId(pdselect);
			reseltlist.add(goodsList);
		}
		
		//满减优惠列表
		List<PageData> mjyhList = kehuService.getMjyhList(pd);
		mv.addObject("mjyhList", mjyhList);
		
		//满减配送费列表
		List<PageData> mjpsfList = kehuService.getMjpsfList(pd);
		mv.addObject("mjpsfList", mjpsfList);
		
		//商家评价部分的标签码表
		List<PageData> sysLabelList = kehuService.sysLabelList(pd);
		mv.addObject("sysLabelList", sysLabelList);
		
		//获取商家的评价列表
		List<PageData> evaluateList = kehuService.getEvaluateListOfShangJia(pd);
		mv.addObject("evaluateList", evaluateList);
		/*
		 * List<PageData> biaoqianlist= new ArrayList<PageData>();
		PageData count = kehuService.queryPingLunSum(pd);//查询商家的评价总数
		for (int i = 0; i < sysLabelList.size(); i++) {
			pd.put("label_fid", sysLabelList.get(i).getString("label_id"));
			PageData countsData = kehuService.queryGeLeiPJSum(pd);
			biaoqianlist.add(countsData);
		}
		mv.addObject("count", count);
		mv.addObject("countsData", biaoqianlist);
		*/
		if(isSession()){
			pd.put("user_shangjia_fid", pd.getString("user_shangjia_id"));
			pd.put("user_kehu_fid",  getSessionUser().getUser_kehu_id());
			PageData sdData = kehuService.selectShouCang(pd);
			if (sdData == null) {//判断是否已收藏
				mv.addObject("shoucangs", "01");
			}else {
				mv.addObject("shoucangs", "02");
			}
		}
		mv.addObject("tid", pd.get("tid"));
		mv.addObject("shangjiaData", shangjiaData);
		mv.addObject("goodsCategoryList", goodsCategoryList);
		mv.addObject("goodsList", reseltlist);
		mv.addObject("sysLabelList", sysLabelList);
		pds = kehuService.getqisonjiagebyID(pd);
		mv.addObject("pds", pds);
		mv.addObject("mkID", pd.getString("mkID"));
		mv.addObject("lat", pd.getString("lat"));
		mv.addObject("lng", pd.getString("lng"));
		mv.addObject("flag", pd.getString("flag"));
		mv.setViewName("kehuduan/shop");
		return mv;
	}
	
	
	/**
	 * 根据商品id查看商品详情
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-9-8
	 */
	@RequestMapping(value="/getGoodDetailByID")
	@ResponseBody
	public Object getGoodDetailByID(){
		PageData pd = new PageData();
		PageData rpd = new PageData();
		pd = this.getPageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			rpd = kehuService.getGoodDetailByID(pd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		map.put("rpd", rpd);
		return AppUtil.returnObject(pd, map);
	}
	
	
	
	/**
	 * @作者:Lj
	 * @功能:执行收藏商家店铺
	 * @日期:2017-9-6上午9:00:51
	 */
	@RequestMapping(value="/insertShouCang")
	@ResponseBody
	public Object insertShouCang() throws Exception{
		logBefore(logger, "---insertShouCang--执行收藏商家店铺--");
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String, Object> map = new HashMap<String, Object>();
 		if(isSession()){
			pd.put("user_shangjia_fid", pd.getString("user_shangjia_id"));
			pd.put("user_kehu_fid",  getSessionUser().getUser_kehu_id());
			PageData sdData = kehuService.selectShouCang(pd);
			if(sdData==null){
				PageData pdinsert = new PageData();
				pdinsert.put("shoucang_id", this.get32UUID());
				pdinsert.put("user_shangjia_fid",  pd.getString("user_shangjia_id"));
				pdinsert.put("user_kehu_fid", getSessionUser().getUser_kehu_id());
				pdinsert.put("mkID", pd.getString("mkID"));//八大模块id
				kehuService.insertShouCang(pdinsert);//执行店铺收藏
				map.put("sdData", sdData);
				map.put("respCode", "01");
			}else{
				map.put("sdData", sdData);
				map.put("respCode", "03");
				sdData.put("shoucang_id", sdData.getString("shoucang_id"));
				kehuService.deletelShouCang(sdData);//执行取消店铺收藏
			}
			
		}else{
			map.put("respCode", "00");
		}
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 根据标签的逐渐ID获取评论
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getEvaluateListOfShangJia")
	@ResponseBody
	public Object getEvaluateListOfShangJia() throws Exception{
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		
		//获取商家的评价列表
		List<PageData> evaluateList = kehuService.getEvaluateListOfShangJia(pd);
		map.put("evaluateList", evaluateList);
		
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 去商品详情页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/shopi")
	public ModelAndView shopi() throws Exception{
		logBefore(logger, "--shopi---去商品详情页面---");
		ModelAndView mv = new  ModelAndView();
		PageData pd = new PageData();
		PageData pds = new PageData();
		pd = this.getPageData();
		pd.put("goods_id", pd.getString("goods_id"));
		//去商品详情页面
		PageData sData = kehuService.queryshangpingxing(pd);
		mv.addObject("pds", sData);
		mv.addObject("goodsNum", pd.getString("goodsNum"));
		mv.setViewName("kehuduan/shopcart/shopi");
		return mv;
	}
	
	/**
	 * ajax 请求 页面初始化 根据商品分类名字和商家id查出列表数据
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getDataByCategoryNameAndId")
	@ResponseBody
	public Object getDataByCategoryNameAndId() throws Exception{
		logBefore(logger, "--ajax根据商品分类名字和商家id查出列表数据-------");
		PageData pd = new PageData();
		Map map = new HashMap();
		pd = this.getPageData();
		List<PageData> shangpinList =  kehuService.getDataByCategoryNameAndId(pd);
		map.put("shangpinList", shangpinList);
		return AppUtil.returnObject(pd, map);
	}
	
	
	
	/**
	 * 商品列表页面
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/goodsList")
	public ModelAndView goodsList() throws Exception{
		logBefore(logger, "---goodsList--");
		ModelAndView mv = new  ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
 		if(isSession()){
 			List<PageData> goodsList = kehuService.goodsList(pd);
			mv.addObject("goodsList", goodsList);
			pd.put("user_shangjia_id", pd.getString("user_shangjia_fid"));
			mv.setViewName("redirect:/api/h5KeHu/shop?user_shangjia_fid="+pd.getString("user_shangjia_fid"));
		}else{
			mv.setViewName("redirect:/api/h5KeHu/index");
		}
		return mv;
	}
	
	
	
	/**
	 * 去结算==保存到临时表中
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-30
	 */
	@RequestMapping(value="/saveOrderTemp")
	@ResponseBody
	public Object saveOrderTemp() throws Exception{
		logBefore(logger, "--（去结算）保存到外卖临时表中--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		if (isSession()){
			pd.put("user_kehu_id",  getSessionUser().getUser_kehu_id());
			String sp_id ="";
			//2条 =6,3条=8规律是：2*2+2 所有pd.size() = (pd.size()-2)/2
			for(int i=0;i<pd.size();i++){
				if(pd.containsKey("map["+i+"][value]")){
					if(Tools.notEmpty(pd.get("map["+i+"][value]").toString())){
						//商品id
						sp_id= pd.get("map["+i+"][key]").toString();
						//结果字符串
						String rstr[] = pd.get("map["+i+"][value]").toString().split(",");
						for(int y=0;y<1;y++){
							//添加
							PageData pdinsert = this.getPageData();
							pdinsert.put("temp_id", this.get32UUID());
							pdinsert.put("kehu_id", getSessionUser().getUser_kehu_id());
							pdinsert.put("shangjia_id",pd.get("user_shangjia_id"));
							pdinsert.put("sp_id", sp_id);
							pdinsert.put("sp_name",rstr[y]);
							pdinsert.put("price", rstr[y+1]);
							pdinsert.put("canhefei", rstr[y+2]);
							pdinsert.put("num", rstr[y+3]);
							pdinsert.put("weight", rstr[y+4]);
							pdinsert.put("mkID", pd.get("mkID"));
							kehuService.saveTempOrder(pdinsert);
						}
		
					}
				
				}
			}
			map.put("respCode", "01");
		}else{
			map.put("respCode", "00");
		}
		return AppUtil.returnObject(pd, map);
	}
	
	
	/**
	 *去订单详情并支付页面
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-17
	 */
	@RequestMapping(value="/orderPay")
	public ModelAndView orderPay() throws Exception{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//最后查出所有
		//查出临时表所有数据
		pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
		//查出临时表所有数据
		List<PageData> resultList = kehuService.selectTempOrderList(pd);
		
		//查出合计数以及该订单中的货物总重量
		PageData totolData = kehuService.getTotolByUserKeHuID(pd);
		pd.put("user_kehu_fid",  getSessionUser().getUser_kehu_id());
		
		//获取商家信息
		PageData shangjiaData = kehuService.queryUserShangjia(pd);
		//商家的经纬度
		double lat2 = Double.parseDouble(shangjiaData.get("latitude").toString());
		double lng2 = Double.parseDouble(shangjiaData.get("longitude").toString());
		
		//查默认地址
		PageData dizhiData =  kehuService.getByisDefault(pd);
		//判断是否有默认地址,有,则计算收货地址到商家的距离,若无,则计算客户当前位置到商家的距离
		double distance1=0;//单位米
		if(dizhiData!=null){//有默认地址
			double lat1 = Double.parseDouble(dizhiData.get("latitude").toString());
			double lng1 = Double.parseDouble(dizhiData.get("longitude").toString());
			distance1 = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
		}else{
			double lat1 = Double.parseDouble(pd.get("lat").toString());
			double lng1 = Double.parseDouble(pd.get("lng").toString());
			distance1 = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
		}
		int distance= (new Double(distance1)).intValue();//转为整数
		
		//计算配送费用（因为默认配送方式为商家配送,会产生配送费用）
		double psCost=0;
		//1.运费信息
		List<PageData> freightList=shangjiaService.getFreightOfShangJia(pd);
		//获取5档配送标准,判断属于哪一档,并回去该档下的配送费用
		for (int i = freightList.size()-2; i >= 0; i--) {
			if(distance >= Integer.parseInt(freightList.get(i).getString("distance1"))){
				psCost+=Double.parseDouble(freightList.get(i).getString("cost"));
				break;
			}
		}
		//判断配送距离是否超出5档范围,若超出,则计算超出距离收取的费用
		if(distance > Integer.parseInt(freightList.get(freightList.size()-1).getString("distance1"))){
			psCost+=(double)(distance - Integer.parseInt(freightList.get(freightList.size()-1).getString("distance1")))/(Double.parseDouble(freightList.get(freightList.size()-1).getString("distance2"))*1000)*Double.parseDouble(freightList.get(freightList.size()-1).getString("cost"));
		}
		//2.超重收费信息
		PageData weightBeyondPd=shangjiaService.getWeightBeyondOfShangJia(pd);
		//判断该订单的获取总重量是否属于超重收费内
		double zweight=Double.parseDouble(totolData.get("weight").toString());
		double byweight=Double.parseDouble(weightBeyondPd.get("weight").toString());
		if(zweight > byweight ){
			psCost+=(zweight - byweight)/Double.parseDouble(weightBeyondPd.get("unit").toString())*Double.parseDouble(weightBeyondPd.get("cost").toString());
		}
		shangjiaData.put("psCost", FormateUtil.formateDoubleAsIntPointString(psCost));//保留两位小数

		//满减优惠列表
		List<PageData> mjyhList = kehuService.getMjyhList(pd);
		double mjyh=0;
		for (int i = mjyhList.size()-1; i >= 0; i--) {
			if(Double.parseDouble(totolData.get("totol").toString())>=Double.parseDouble(mjyhList.get(i).get("man_num").toString())){
				mjyh=Double.parseDouble(mjyhList.get(i).get("jian_num").toString());
				break;
			}
		}
		mv.addObject("mjyh", Double.parseDouble(FormateUtil.formateDoubleAsIntPointString(mjyh)));
		
		//判断该用户是否为当前商家的新用户
		List<PageData> OrderList = kehuService.queryOrderTakeouLists(pd);
		//新用户立减
		double xyhli=0;
		if(Tools.notEmpty(shangjiaData.getString("xyhliState"))){
			if(shangjiaData.getString("xyhliState").equals("1")){
				if(Tools.notEmpty(shangjiaData.getString("xyhli"))){
					if(OrderList.size()==0){
						xyhli=Double.parseDouble(shangjiaData.getString("xyhli"));
					}
				}
			}
		}
		mv.addObject("xyhli", Double.parseDouble(FormateUtil.formateDoubleAsIntPointString(xyhli)));
		
		//满减配送费
		List<PageData> mjpsfList = kehuService.getMjpsfList(pd);
		double mjpsf=0;
		if(mjpsfList!=null && !mjpsfList.isEmpty()){
			for (int i = mjpsfList.size()-1; i >= 0; i--) {
				if(Double.parseDouble(totolData.get("totol").toString())>=Double.parseDouble(mjpsfList.get(i).get("man_num").toString())){
					mjpsf=Double.parseDouble(mjpsfList.get(i).get("jian_num").toString());
					break;
				}
			}
		}
		//满减配送费,最多把配送费用减完
		if(mjpsf > psCost){
			mjpsf=psCost;
		}
		mv.addObject("mjpsf", Double.parseDouble(FormateUtil.formateDoubleAsIntPointString(mjpsf)));
		
		mv.addObject("resultList", resultList);
		mv.addObject("totolData", totolData);
		mv.addObject("shangjiaData", shangjiaData);
		mv.addObject("dizhiData", dizhiData);
		mv.addObject("lat", pd.getString("lat"));
		mv.addObject("lng", pd.getString("lng"));
		mv.addObject("dizhiData", dizhiData);
		mv.addObject("user_shangjia_id", pd.get("user_shangjia_id"));
		mv.setViewName("kehuduan/querenDingdan");
		return mv;
	}
	
	/**
	 * 购物车集合
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-17
	 */
	@RequestMapping(value="/gwcList")
	@ResponseBody
	public Object gwcList() throws Exception{
		logBefore(logger, "--查看购物车--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		//最后查出所有
		//查出临时表所有数据
		pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
		List<PageData> finalList = kehuService.selectTempOrderList(pd);
		map.put("finalList", finalList);
		logBefore(logger, AppUtil.returnObject(new PageData(), map).toString());
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 清空购物车
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-18
	 */
	@RequestMapping(value="/clearCar")
	@ResponseBody
	public Object clearCar() throws Exception{
		logBefore(logger, "--清空购物车--");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
		kehuService.delTempOrder(pd);
		map.put("respMsg", "01");
		return AppUtil.returnObject(pd, map);
	}
	
	
	
	
	
	/**
	 * 提交订单
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/submitOrder")
	public ModelAndView submitOrder() throws Exception{
		logBefore(logger, "---客户端外卖提交订单---");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		System.out.println("+++++++++++"+pd.get("arriveTime")+"");
		if (isSession()) {
			pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
			List<PageData> resultlist = kehuService.selectTempOrderList(pd);
			PageData maxnumData = kehuService.selectMaxQucanNumber(pd);
			
			//平台服务费比例
			PageData fuwuData  = h5sysService.getDateByfuwufeiId(pd);
			//配送费比例
			//PageData peisonData  = h5sysService.getDateBypeisongfeiId(pdinsert);
			//订单表主键id
			String order_takeou_id = this.get32UUID();
			//插入订单表
			PageData pdinsert = this.getPageData();
			pdinsert.put("order_takeou_id", order_takeou_id);
			pdinsert.put("orderTime", DateUtil.getTime());
			pdinsert.put("orderNumber","");//先设置为空字符串，在支付时更新
			if(maxnumData!=null){
				pdinsert.put("qucan_number",(Integer.parseInt(maxnumData.get("maxnum").toString())+1));
			}else{
				pdinsert.put("qucan_number",1);
			}
			
			//保存到订单表中
			pdinsert.put("order_remark", pd.get("remark"));//留言 备注
			pdinsert.put("payState", "未支付");//支付后修改是微信支付还是支付宝支付
			pdinsert.put("orderStateKehu", 1);	
			pdinsert.put("orderStateShangjia", 1);
			pdinsert.put("orderStateQishou", 6);
			pdinsert.put("payMethod", "");//支付方式
			pdinsert.put("totalSum", pd.get("total"));//总金额
			pdinsert.put("paySum", pd.get("total"));//实际支付金额 可能=总金额-优惠打折的金额
			pdinsert.put("user_kehu_fid",  getSessionUser().getUser_kehu_id());
			pdinsert.put("user_shangjia_fid",  pd.get("user_shangjia_id"));
			pdinsert.put("shouhuo_address_fid",  pd.get("shouhuo_address_id"));
			pdinsert.put("user_qishou_fid",  "");//骑手id
			pdinsert.put("qurysdTime",  "");//确认送达时间
			pdinsert.put("peisongfei", new BigDecimal(pd.get("psCost").toString()).equals("")?0:new BigDecimal(pd.get("psCost").toString()));//页面传来
			pdinsert.put("fuwubili", fuwuData.get("fuwubili"));
			pdinsert.put("mjyh", pd.get("mjyh"));
			pdinsert.put("xyhli", pd.get("xyhli"));
			pdinsert.put("mjpsf", pd.get("mjpsf"));
			pdinsert.put("deliveryMode", pd.get("deliveryMode"));
			pdinsert.put("mkID", pd.get("mkID"));
			pdinsert.put("arriveTime", pd.get("arriveTime"));
			kehuService.insertOrderTakeou(pdinsert);
			
			//批量添加到商品订单表
			for(int i=0;i<resultlist.size();i++){
				PageData goods = this.getPageData();
				goods.put("order_goods_id", this.get32UUID());
				goods.put("goodsName", resultlist.get(i).get("name"));
				goods.put("goodsNum", resultlist.get(i).get("num"));
				goods.put("canhefei", resultlist.get(i).get("canhefei"));
				goods.put("originalPrice", resultlist.get(i).get("weight"));//商品的净重
				goods.put("presentPrice", resultlist.get(i).get("price"));//商品价格
				//外建 外卖订单id
				goods.put("takeout_order_fid", order_takeou_id);
				goods.put("goods_fid", resultlist.get(i).get("sp_id"));
				kehuService.insertOrderGoods(goods);
				
			}
			
			//删除临时订单表
			kehuService.delTempOrder(pd);
			mv.addObject("order_takeou_id", order_takeou_id);
			mv.addObject("total", pd.get("total"));
			mv.setViewName("kehuduan/zaixianZhifu");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	/**
	 * 去选择支付方式页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/tozaixianZhifu")
	public ModelAndView tozaixianZhifu() throws Exception{
		logBefore(logger, "---去选择支付方式页面---");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		if (isSession()) {
			mv.addObject("order_takeou_id", pd.getString("order_takeou_id"));
			mv.addObject("total", pd.get("total"));
			mv.setViewName("kehuduan/zaixianZhifu");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	@RequestMapping(value="/delTempOrder")
	public ModelAndView delTempOrder(HttpSession session) throws Exception{
		logBefore(logger, "--删除临时订单--");
		ModelAndView mv=new ModelAndView();
		PageData pd = this.getPageData();
		if(isSession()){
			pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
			kehuService.delTempOrder(pd);
			mv.setViewName("redirect:/api/kehu/shop.do?user_shangjia_id="+pd.get("user_shangjia_id")+"&mkID="+pd.get("mkID"));
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	
	//========================================分割=======================================//
	
	
	/**
	 * 生鲜客户端进入首页
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/index")
	public ModelAndView index() throws Exception{
		logBefore(logger, "--生鲜客户端进入首页--");
		ModelAndView mv = new  ModelAndView();
		PageData pd=new PageData();
		pd = this.getPageData();
		//导航部分
		List<PageData>	mkList = kehuService.getMoKuaiList(pd);	
		mv.addObject("mkList", mkList);
		//轮播图列表
		List<PageData>	varList = kehuService.picturesList(pd);	
		mv.addObject("varList", varList);
		//平台公告
		List<PageData>	noticeList = noticeService.headNewsList(pd);	
		mv.addObject("noticeList", noticeList);
		
		mv.setViewName("kehuduan/index");
		return mv;
	}
	
	
	/**
	 * 
	 * 功能：首页 附近商家
	 * 作者：yangym
	 * 日期：2017-9-1
	 */
	@RequestMapping(value="/nearDistanceShangjia")
	@ResponseBody
	public Object nearDistanceShangjia() throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		DecimalFormat df = new DecimalFormat("######0.00");   
		List<PageData> resultList =  new ArrayList<PageData>();
		List<PageData> businessList =  kehuService.businessList(pd);
		for(int i=0;i<businessList.size();i++){
			double lat1 = Double.parseDouble(pd.get("lat").toString());
			double lng1 = Double.parseDouble(pd.get("lng").toString());
			double lat2 = Double.parseDouble(businessList.get(i).get("latitude").toString());
			double lng2 = Double.parseDouble(businessList.get(i).get("longitude").toString());
			double distance = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
			distance = distance/1000;
			//商家配送范围为空，或者在配送范围内，则该商家显示
			double temp=0;
			if(Tools.notEmpty(businessList.get(i).getString("psRange"))){
				temp=Double.parseDouble(businessList.get(i).getString("psRange"));
			}
			if(Tools.isEmpty(pd.get("mkID").toString())){
				temp=8;
			}
			System.out.println("====++++distance(客、商之间的距离)+======"+distance+"====++++temp(配送范围)+======"+temp);
			if(distance<=temp || temp==0){
				PageData rpd = new PageData();
				rpd.put("user_shangjia_id", businessList.get(i).get("user_shangjia_id"));
				rpd.put("shopName", businessList.get(i).get("shopName"));
				rpd.put("shopNotice", businessList.get(i).get("shopNotice"));
				rpd.put("deliveryAmount", businessList.get(i).get("deliveryAmount"));
				rpd.put("logoImg", businessList.get(i).get("logoImg"));
				rpd.put("mkID", businessList.get(i).get("mkID"));
				if(Tools.isEmpty(businessList.get(i).getString("psf"))){
					rpd.put("psCost", 0);
				}else{
					rpd.put("psCost", businessList.get(i).get("psf"));
				}
				
				rpd.put("xsNum", businessList.get(i).get("xsNum"));
				rpd.put("distance", businessList.get(i).get("distance"));
				
				double pscore=Double.parseDouble(businessList.get(i).get("pscore").toString());
				if(pscore>=0 && pscore<0.5){
					pscore=0;
				}else if(pscore>=0.5 && pscore<1){
					pscore=0.5;
				}else if(pscore>=1 && pscore<1.5){
					pscore=1;
				}else if(pscore>=1.5 && pscore<2){
					pscore=1.5;
				}else if(pscore>=2 && pscore<2.5){
					pscore=2;
				}else if(pscore>=2.5 && pscore<3){
					pscore=2.5;
				}else if(pscore>=3 && pscore<3.5){
					pscore=3;
				}else if(pscore>=3.5 && pscore<4){
					pscore=3.5;
				}else if(pscore>=4 && pscore<4.5){
					pscore=4;
				}else if(pscore>=4.5 && pscore<5){
					pscore=4.5;
				}else{
					pscore=5;
				}
				rpd.put("pscore", pscore+"");
			
				//新用户立减
				if(Tools.notEmpty(businessList.get(i).getString("xyhliState")) && businessList.get(i).getString("xyhliState").equals("1")){
					if(Tools.notEmpty(businessList.get(i).getString("xyhli"))){
						rpd.put("xyhli", businessList.get(i).getString("xyhli"));
					}
				}
				//满减
				if(Tools.notEmpty(businessList.get(i).getString("man_num"))){
					String mans[]= businessList.get(i).getString("man_num").split(",");
					String jians[]= businessList.get(i).getString("jian_num").split(",");
					String mjString="";
					for(int y=0;y<mans.length;y++){
						 mjString += "满"+mans[y]+"减"+jians[y]+";";
					}
					rpd.put("mjString", mjString);
					
				}
			
				//保留2位小数
				rpd.put("distance", df.format(distance));
				resultList.add(rpd);
			}
		}
		
		//按距离进行排序
		if(pd.getString("type").equals("2")){
			Collections.sort(resultList, new Comparator<PageData>(){
				public int compare(PageData o1, PageData o2) {
					if(Double.parseDouble(o1.get("distance").toString()) > Double.parseDouble(o2.get("distance").toString())){
						return 1;
					}
					if(Double.parseDouble(o1.get("distance").toString()) == Double.parseDouble(o2.get("distance").toString())){
						return 0;
					}
					return -1;
				}
			});
		}
		map.put("businessList", resultList);
		map.put("mkID", pd.getString("mkID"));
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 *购物车
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/gouwuche")
	public ModelAndView gouwuche() throws Exception{
		logBefore(logger, "--购物车--");
		ModelAndView mv = new  ModelAndView();
		PageData pd=new PageData();
		pd = this.getPageData();
		if(isSession()){	
			
			
			mv.setViewName("kehuduan/gouwuChe");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin.do");
		}
	
		return mv;
	}
	
	
	/**
     * 功能：全部订单
     * 作者：yangym
     * 日期：2017-8-29
     */
    @RequestMapping(value="/orders")
    public ModelAndView orders() throws Exception{
        logBefore(logger, "--全部订单--");
        ModelAndView mv = new  ModelAndView();
        PageData pd=new PageData();
        pd = this.getPageData();
        if(isSession()){    
            pd.put("user_kehu_fid",  getSessionUser().getUser_kehu_id());
            List<PageData> OrderList = kehuService.queryOrderTakeouLists(pd);//我的外卖全部订单
            mv.addObject("OrderList", OrderList);
            mv.addObject("pd", pd);
            mv.setViewName("kehuduan/order");
        }else{
            mv.setViewName("redirect:/api/kehu/toLogin.do");
        }
        return mv;
    }

    /**
     * @作者:Lj
     * @功能:我的外卖订单详情
     * @日期:2017-9-1上午10:30:48
     */
    @RequestMapping(value="/orderinfo")
    public ModelAndView orderinfo() throws Exception{
        logBefore(logger, "----orderinfo--我的外卖订单详情------");
        ModelAndView mv = new  ModelAndView();
        PageData pd= new PageData();
        pd = this.getPageData();
        if (isSession()){
            pd.put("order_takeou_id", pd.getString("order_takeou_id"));
            PageData sData = kehuService.querytbOrderTakeou(pd);//订单详情
            List<PageData> kehugoodsList = kehuService.kehuOrderGoodsLists(pd);
            mv.addObject("goodsList", kehugoodsList);
            mv.addObject("pd", sData);
            mv.addObject("pds", pd);
            mv.setViewName("kehuduan/order_info");
        }else{
            mv.setViewName("redirect:/api/kehu/index");
        }
        return mv;
    }
    
    /**
     * @作者:Lj
     * @功能:订单评价
     * @日期:2017-8-31上午11:23:16
     */
    @RequestMapping(value="/myeval")
    public ModelAndView myeval() throws Exception{
        logBefore(logger, "--订单评价--");
        ModelAndView mv = new  ModelAndView();
        PageData pd=new PageData();
        pd = this.getPageData();
        if(isSession()){
            pd.put("order_takeou_id", pd.getString("order_takeou_id"));
            pd.put("type", "type");
            PageData sData = kehuService.querytbOrderTakeou(pd);//订单详情
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date begin=df.parse(sData.get("orderTime").toString());
            java.util.Date end = df.parse(sData.get("qurysdTime").toString());
            Long l = (end.getTime() - begin.getTime()) / (1000 * 60);//计算（送达）全程使用的了多少分钟。(n分钟)=[(送达时间戳)-(下单时间戳)]/(1000 * 60)
            System.out.println(l+"分");
            List<PageData> kehugoodsList = kehuService.kehuOrderGoodsLists(pd);
            List<PageData> sysLabelList = kehuService.sysLabelList(pd);
            mv.addObject("goodsList", kehugoodsList);
            mv.addObject("sysLabelList", sysLabelList);
            mv.addObject("pd", sData);
            mv.addObject("l", l);//分钟数
            mv.addObject("order_takeou_id", pd.getString("order_takeou_id"));
            mv.addObject("msg", "savemyeval");
            mv.setViewName("kehuduan/myeval");
        }else{
            mv.setViewName("redirect:/api/kehu/toLogin.do");
        }
        return mv;
    }


    /**
     * @作者:Lj
     * @功能:执行保存订单评价
     * @日期:2017-9-1上午8:41:40
     */
    @RequestMapping(value="/savemyeval")
    public ModelAndView savemyeval() throws Exception{
        logBefore(logger, "--执行保存订单评价--");
        ModelAndView mv = new  ModelAndView();
        PageData pd=new PageData();
        pd = this.getPageData();
        if(isSession()){
        	pd.put("order_takeou_id", pd.getString("order_takeou_id"));
        	PageData sData = kehuService.querytbOrderTakeou(pd);//订单详情
        	
        	//商家
        	PageData sjPageData=new PageData();
        	String sjevaluate_id=this.get32UUID();
        	sjPageData.put("evaluate_id", sjevaluate_id);
        	sjPageData.put("score", pd.getString("sjscore"));//评分
        	sjPageData.put("min", pd.getString("min"));//骑手送达全程使用的分钟
        	sjPageData.put("user_kehu_fid", getSessionUser().getUser_kehu_id());//外键（客户的主键ID）
        	sjPageData.put("user_shangjia_fid", sData.getString("user_shangjia_fid"));//外键（商户的主键ID）
        	sjPageData.put("user_qishou_fid", sData.getString("user_qishou_fid"));//外键（骑手的主键ID）
        	sjPageData.put("mkID", sData.getString("mkID"));//八大模块id
        	sjPageData.put("type", "1");//分类(1-评论商家，2-评论骑手)
        	sjPageData.put("category", "1");//类别(1-首次评论，2-追加评论)
        	sjPageData.put("label", pd.getString("sjlabel"));//标签内容
        	sjPageData.put("content", pd.getString("sjcontent"));//评价内容
        	sjPageData.put("time", DateUtil.getTime());//创建时间评论时间
    		kehuService.savemyeval(sjPageData);//执行保存订单评价
    		
    		String sjlabelid[]=pd.getString("sjlabelid").split(",");
    		for (int i = 0; i < sjlabelid.length; i++){
				PageData pds=new PageData();
				pds.put("evaluate_label_id", this.get32UUID());
				pds.put("evaluate_fid", sjevaluate_id);
				pds.put("label_fid", sjlabelid[i]);
				kehuService.saveEvaluateLabel(pds);//执行保存评价标签关系表
			}
    		
    		//骑手
    		PageData qsPageData=new PageData();
    		String qsevaluate_id=this.get32UUID();
    		qsPageData.put("evaluate_id", qsevaluate_id);
    		qsPageData.put("score", pd.getString("qsscore"));//评分
    		qsPageData.put("min", pd.getString("min"));//骑手送达全程使用的分钟
    		qsPageData.put("user_kehu_fid", getSessionUser().getUser_kehu_id());//外键（客户的主键ID）
    		qsPageData.put("user_shangjia_fid", sData.getString("user_shangjia_fid"));//外键（商户的主键ID）
    		qsPageData.put("user_qishou_fid", sData.getString("user_qishou_fid"));//外键（骑手的主键ID）
    		qsPageData.put("mkID", sData.getString("mkID"));//八大模块id
    		qsPageData.put("type", "2");//分类(1-评论商家，2-评论骑手)
    		qsPageData.put("category", "1");//类别(1-首次评论，2-追加评论)
    		qsPageData.put("label", pd.getString("qslabel"));//标签内容
    		qsPageData.put("content", pd.getString("qscontent"));//评价内容
    		qsPageData.put("time", DateUtil.getTime());//创建时间评论时间
    		kehuService.savemyeval(qsPageData);//执行保存订单评价
    		
    		String qslabelid[]=pd.getString("qslabelid").split(",");
    		for (int i = 0; i < qslabelid.length; i++) {
				PageData pds=new PageData();
				pds.put("evaluate_label_id", this.get32UUID());
				pds.put("evaluate_fid", qsevaluate_id);
				pds.put("label_fid", qslabelid[i]);
				kehuService.saveEvaluateLabel(pds);//执行保存评价标签关系表
			}
    		kehuService.setIsEvaluate(pd);//设置该订单已被评论
            mv.setViewName("redirect:/api/kehu/orders.do");
        }else{
            mv.setViewName("redirect:/api/kehu/toLogin.do");
        }
        return mv;
    }
	
	
	/**
	 * 商家列表
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-29
	 */
	@RequestMapping(value="/businessList")
	public ModelAndView businessList() throws Exception{
		logBefore(logger, "--商家列表--");
		DecimalFormat df = new DecimalFormat("######0.00");   
		ModelAndView mv = new  ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		List<Object> resultList =  new ArrayList<Object>();
		//判断是否定位了是否获取到经纬度
		if(Tools.notEmpty(pd.getString("lat"))){
			if(Tools.isEmpty(pd.getString("flag"))){
				List<PageData> businessList =  kehuService.businessList(pd);
				for(int i=0;i<businessList.size();i++){
					PageData rpd = new PageData();
					rpd.put("user_shangjia_id", businessList.get(i).get("user_shangjia_id"));
					rpd.put("shopName", businessList.get(i).get("shopName"));
					rpd.put("shopNotice", businessList.get(i).get("shopNotice"));
					rpd.put("deliveryAmount", businessList.get(i).get("deliveryAmount"));
					rpd.put("deliveryAmount", businessList.get(i).get("deliveryAmount"));
					rpd.put("logoImg", businessList.get(i).get("logoImg"));
					rpd.put("psCost", businessList.get(i).get("psCost"));
					//新用户立减
					if(Tools.notEmpty(businessList.get(i).getString("xyhliState")) && businessList.get(i).getString("xyhliState").equals("1")){
						if(Tools.notEmpty(businessList.get(i).get("xyhli").toString())){
							rpd.put("xyhli", "新用户立减"+businessList.get(i).get("xyhli")+"元");
						}
					}
					if(Tools.notEmpty(businessList.get(i).getString("man_num"))){
						String mans[]= businessList.get(i).getString("man_num").split(",");
						String jians[]= businessList.get(i).getString("jian_num").split(",");
						String mjString="";
						for(int y=i;y<mans.length;y++){
							 mjString += "满"+mans[y]+"减"+jians[y]+";";
						}
						rpd.put("mjString", mjString);
						
					}
					double lat1 = Double.parseDouble(pd.get("lat").toString());
					double lng1 = Double.parseDouble(pd.get("lng").toString());
					double lat2 = Double.parseDouble(businessList.get(i).get("latitude").toString());
					double lng2 = Double.parseDouble(businessList.get(i).get("longitude").toString());
					double distance = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
					distance = distance/1000;
					//保留2位小数
					rpd.put("distance", df.format(distance));
					resultList.add(rpd);
				}
				
				mv.setViewName("kehuduan/business_list");
			}else{
				mv.setViewName("redirect:/api/kehu/index.do");
			}
		}else{
			mv.setViewName("redirect:/api/kehu/index.do");
		}
			mv.addObject("businessList", resultList);
			mv.addObject("mkID", pd.get("mkID"));
			mv.addObject("lat", pd.get("lat"));
			mv.addObject("lng", pd.get("lng"));
			return mv;
	}
	
	
	/**
	 * 退出注销 
	 * @return
	 */
	@RequestMapping(value="/tuichu")
	public ModelAndView tuichu(){
		logBefore(logger, "--退出注销--");
		ModelAndView mv = new  ModelAndView();
		//销毁session
		removeSession();
		mv.setViewName("redirect:/api/kehu/index.do");
		return mv;
	}
	
	
	
	
	/**
	 * 在线支付
	 * @return
	 */
	@RequestMapping(value="/zaixianZhifu")
	public ModelAndView zaixianZhifu(){
		logBefore(logger, "---zaixianZhifu--在线支付--");
		ModelAndView mv=new ModelAndView();
		if(isSession()){
			mv.setViewName("kehuduan/Interaction/zaixianZhifu");
		}else{
			mv.setViewName("redirect:/api/h5KeHu/index");
		}
		return mv;
	}
	
	
	
	/**
	 * 
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-9-11
	 */
	@RequestMapping(value="/getLocations")
	@ResponseBody
	public Object getLocations(HttpSession session) throws Exception{
		logBefore(logger, "--地址转换--");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		Map map =  new HashMap();
		map = LocationUtils.locationConvert(Double.parseDouble(pd.getString("lat")), Double.parseDouble(pd.getString("lng")));
		return AppUtil.returnObject(pd, map);
	}
	
	
	
	
	
	//======================================我的begin===========================================//
	
	
	/**
	 * 我的
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-29
	 */
	@RequestMapping(value="/wode")
	public ModelAndView wode() throws Exception{
		logBefore(logger, "--我的--");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		if(isSession()){
			pd.put("user_kehu_id", getSessionUser().getUser_kehu_id());
			PageData resultData = kehuService.getUserDataByID(pd);
			mv.addObject("resultData", resultData);
			mv.addObject("pd", pd);
			mv.setViewName("kehuduan/wode");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin.do");
		}
		return mv;
	}
	
	/**
	 * @功能：会员资料页面
	 * @作者:lj
	 * @日期：2017-8-30上午9:12:45
	 */
	@RequestMapping(value="/huiyuanZiliao")
	public ModelAndView ziliao(HttpSession session,HttpServletRequest request) throws Exception{
		logBefore(logger, "--huiyuanZiliao---会员资料页面--");
		ModelAndView mv=new ModelAndView();
		if(isSession()){
			PageData pd= new PageData();
			pd = this.getPageData();
			KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
			pd.put("user_kehu_id", kehu.getUser_kehu_id());
			PageData pds = kehuService.getUserDataByID(pd);
			mv.addObject("pds", pds);
			mv.setViewName("kehuduan/huiyuanZiliao");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	/**
     * @作者:lj
     * @功能：上传与修改保存头像
     * @日期：2017-8-30上午10:41:28
     */
    @RequestMapping(value="/savetouxiang")
    public ModelAndView savetouxiang(HttpSession session,MultipartFile imgFile) throws Exception{
        logBefore(logger, "--savetouxiang---上传与修改保存头像--");
        ModelAndView mv=new ModelAndView();
        PageData pd = new PageData();
        String TOUXIANG = "kehutouxiang/";  
        String  ffile = DateUtil.getDays(), headImgURLName = "";
        KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
        if(isSession()){
            if (null != imgFile && !imgFile.isEmpty()){
                String filePath = PathUtil.getClasspath() + Const.FILEPATHIMG + TOUXIANG + ffile;//文件上传路径
                headImgURLName = FileUpload.fileUp(imgFile,filePath, this.get32UUID()); //执行上传
                pd.put("imgFile", Const.FILEPATHIMG + TOUXIANG + ffile + "/" + headImgURLName);
                System.out.println(pd.getString("headImgForm"));
                pd.put("user_kehu_id", kehu.getUser_kehu_id());
                kehuService.touxiang(pd);
                mv.addObject("respCode", "01");
            }else{
                mv.addObject("respCode", "00");
            }
        }else{
            mv.setViewName("redirect:/api/kehu/toLogin");
        }
        mv.setViewName("redirect:/api/kehu/huiyuanZiliao");
        return mv;
    }
	
	/**
	 * @作者：Lj
	 * @功能:去修改用户名页面
	 * @日期：2017-8-30上午10:44:48
	 */
	@RequestMapping(value="/changeUserName")
	public ModelAndView changeUserName(HttpSession session) throws Exception{
		logBefore(logger, "---changeUserName-----去修改用户名页面------");
		ModelAndView mv = new  ModelAndView();
		if(isSession()){
			PageData pd= new PageData();
			pd = this.getPageData();
			KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
			pd.put("user_kehu_id", kehu.getUser_kehu_id());
			PageData pds = kehuService.getUserDataByID(pd);
			mv.addObject("pds", pds);
			mv.addObject("msg", "savechangeUserName");
			mv.setViewName("kehuduan/changeUserName");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	/**
	 * @作者：Lj
	 * @功能:执行修改用户名
	 * @日期：2017-8-30上午10:45:09
	 */
	@RequestMapping(value="/savechangeUserName")
	public ModelAndView savechangeUserName(HttpSession session) throws Exception{
		logBefore(logger, "--savechangeUserName--执行修改用户名-------");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		String userName=pd.getString("userName");
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			pd.put("userName", userName);
			pd.put("user_kehu_id", kehu.getUser_kehu_id());
			kehuService.saveyonghuming(pd);//修改用户名
		}else {
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		mv.setViewName("redirect:/api/kehu/huiyuanZiliao");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:换绑旧手机号页面
	 * @日期:2017-8-30上午11:47:50
	 */
	@RequestMapping(value="/changeTel")
	public ModelAndView changeTelss() throws Exception{
		logBefore(logger, "---changeTel----换绑旧手机号页面----");
		ModelAndView mv = new  ModelAndView();
		if(isSession()){
			mv.setViewName("kehuduan/changeTel");
		}else {
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	/**
	 * @作者：Lj
	 * @功能:执行查询是否存在账号
	 * @日期：2017-8-30上午11:45:09
	 */
	@RequestMapping(value="/yanzhengPhone")
	@ResponseBody
	public Object yanzhengPhone() throws Exception{
		logBefore(logger, "------yanzhengPhone--执行查询是否存在账号----");
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("phone", pd.getString("phone"));
		PageData pds = this.kehuService.findByPhone(pd);
		if(pds!=null){//判断“旧手机号与新手机号”是否存在可以执行换绑新的手机号了。
			map.put("respCode", "01");
			System.out.println("Object:账号存在可以换绑新手机号");
		}else {//“旧手机号与新手机号”否则号码出错啦！
			map.put("respCode", "00");
			System.out.println("Object:账号不存在，还没注册");
		}
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * @作者：Lj
	 * @功能:换绑新手机号页面
	 * @日期：2017-8-30上午11:45:25
	 */
	@RequestMapping(value="/newTel")
	public ModelAndView newTel() throws Exception{
		logBefore(logger, "---newTel----换绑新手机号页面----");
		ModelAndView mv = new  ModelAndView();
		if(isSession()){
			mv.setViewName("kehuduan/newTel");
		}else{
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行换绑新手机号
	 * @日期:2017-8-30上午11:46:17
	 */
	@RequestMapping(value="/savexgphone")
	public ModelAndView savexgphone(HttpSession session) throws Exception{
		logBefore(logger, "--savexgphone--执行换绑新手机号-------");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		String phone=pd.getString("phone");
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			pd.put("phone", phone);
			pd.put("user_kehu_id", kehu.getUser_kehu_id());
			kehuService.updatephone(pd);//执行修改手机号
		}else {
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		mv.setViewName("redirect:/api/kehu/toLogin");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:优惠价列表
	 * @日期:2017-8-30下午2:06:13
	 */
	@RequestMapping(value="/youhuiQuan")
	public ModelAndView youhuiQuan(HttpSession session) throws Exception{
		logBefore(logger, "--youhuiQuan--优惠价列表-------");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		String phone=pd.getString("phone");
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			pd.put("phone", phone);
			pd.put("user_kehu_id", kehu.getUser_kehu_id());
			mv.setViewName("kehuduan/youhuiQuan");
		}else {
			mv.setViewName("redirect:/api/kehu/toLogin");
		}
		return mv;
	}
	
	
	/**
	 * @作者:Lj
	 * @功能:管理收货地址列表
	 * @日期:2017-8-30下午2:19:48
	 */
	@RequestMapping(value="/shouhuoDizhi")
	public ModelAndView shouhuoDizhi(HttpSession session) throws Exception{
		logBefore(logger, "--shouhuoDizhi----管理收货地址列表--");
		ModelAndView mv=new ModelAndView();
		PageData pd = this.getPageData();
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			pd.put("user_kehu_fid", kehu.getUser_kehu_id());
			DecimalFormat df = new DecimalFormat("######0.00");
			List<PageData> resultList =  new ArrayList<PageData>();
			List<PageData> addressList  = kehuService.addressList(pd);//收货地址列表
			PageData psRangedData = kehuService.queryUserShangjia(pd);//获取商家配送范围
			if(pd.getString("tag").equals("2")){
				mv.addObject("tag", pd.get("tag"));
				mv.addObject("shouhuoDizhiList", addressList);
				mv.setViewName("kehuduan/shouhuoDizhi");
			}else{
				//外卖进入收货地址
				for (int i = 0; i < addressList.size(); i++) {
					double lat1 = Double.parseDouble(pd.get("lat").toString());
					double lng1 = Double.parseDouble(pd.get("lng").toString());
					double lat2 = Double.parseDouble(addressList.get(i).get("latitude").toString());
					double lng2 = Double.parseDouble(addressList.get(i).get("longitude").toString());
					double distance = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
					distance = distance/1000;
					//商家配送范围为空，或者在配送范围内，则该商家显示
					//保留2位小数
					double distances = Double.parseDouble(df.format(distance));
					double temp=0;
					if(Tools.notEmpty(psRangedData.getString("psRange"))){
						temp=Double.parseDouble(psRangedData.getString("psRange"));
					}
					System.out.println("====++++distance(客、商之间的距离)+======"+distances+"====++++temp(配送范围)+======"+temp);
					
					PageData pds = new PageData();
					
					if(distances<=temp || temp==0){
						pds.put("show", 1);
					}else{
						pds.put("show", 0);
					}
					pds.put("shouhuo_address_id", addressList.get(i).get("shouhuo_address_id").toString());
					pds.put("linkmanName", addressList.get(i).get("linkmanName").toString());
					pds.put("phone", addressList.get(i).get("phone").toString());
					pds.put("address", addressList.get(i).get("address").toString());
					pds.put("detailAddress", addressList.get(i).get("detailAddress").toString());
					pds.put("identity", addressList.get(i).get("identity").toString());
					pds.put("user_kehu_fid", addressList.get(i).get("user_kehu_fid").toString());
					pds.put("create_time", addressList.get(i).get("create_time").toString());
					pds.put("lable", addressList.get(i).get("lable").toString());
					pds.put("isDefault", addressList.get(i).get("isDefault").toString());
					resultList.add(pds);
				}
				
				//按是否在配送范围内进行排序,在配送范围内的在前面-1、0、1是倒序（从大到小）,反之,正序（从小到大）
				Collections.sort(resultList, new Comparator<PageData>(){
					public int compare(PageData o1, PageData o2) {
						if(Double.parseDouble(o1.get("show").toString()) > Double.parseDouble(o2.get("show").toString())){
							return -1;
						}
						if(Double.parseDouble(o1.get("show").toString()) == Double.parseDouble(o2.get("show").toString())){
							return 0;
						}
						return 1;
					}
				});
				mv.setViewName("kehuduan/shouhuoDizhi_wm");
				mv.addObject("shouhuoDizhiList", resultList);
			}
			mv.addObject("user_shangjia_id", pd.get("user_shangjia_id"));
			mv.addObject("lat", pd.get("lat"));
			mv.addObject("lng", pd.get("lng"));
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	/**
	 * @作者:Lj
	 * @功能:设置指定收货地址为默认收货地址
	 * @日期:2017-8-30下午2:19:48
	 */
	@RequestMapping(value="/isDefault")
	public ModelAndView isDefault(HttpSession session) throws Exception{
		logBefore(logger, "--isDefault----设置指定收货地址为默认收货地址--");
		ModelAndView mv=new ModelAndView();
		PageData pd = this.getPageData();
		if(isSession()){
			PageData pd1=new PageData();
			pd1.put("user_kehu_fid", getSessionUser().getUser_kehu_id());
			pd1.put("isDefault", "0");
			kehuService.isDefault(pd1);
			
			pd.put("isDefault", "1");
			kehuService.isDefault(pd);
			mv.setViewName("redirect:/api/kehu/orderPay?user_shangjia_id="+pd.getString("user_shangjia_id")+"&lat="+pd.get("lat")+"&lng="+pd.get("lng"));
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	
	
	
	
	
	/**
	 * @作者:Lj
	 * @功能:跳转新增收货地址页面
	 * @日期:2017-8-30下午6:16:04
	 */
	@RequestMapping(value="/xinzengDizhi")
	public ModelAndView xinzengDizhi(){
		logBefore(logger, "--xinzengDizhi----跳转新增收货地址页面--");
		ModelAndView mv=new ModelAndView();
		PageData pd =new PageData();
		pd= this.getPageData();
		if(isSession()){
			mv.addObject("user_shangjia_id", pd.get("user_shangjia_id"));
			mv.addObject("msg", "saveaddress");
			mv.addObject("tag", pd.get("tag"));
			mv.addObject("lats", pd.get("lat"));
			mv.addObject("lngs", pd.get("lng"));
			mv.setViewName("kehuduan/xinzengDizhi");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行新增收货地址
	 * @日期:2017-8-30下午6:16:39
	 */
	@RequestMapping(value="/saveaddress")
	@ResponseBody
	public ModelAndView saveaddress(HttpSession session) throws Exception{
		logBefore(logger, "--saveaddress--执行新增收货地址-------");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			String stri = pd.getString("isDefault");
			double lats = Double.parseDouble(pd.getString("lat"));
			double lngs = Double.parseDouble(pd.getString("lng"));
			Map<String, Object> latAndlngMap = LocationUtils.locationConvert(lats, lngs);
			if (stri!=null) {
				int key = Integer.parseInt(stri);
				System.out.println(key);
				if (key==0) {
					pd.put("shouhuo_address_id", this.get32UUID());
					pd.put("linkmanName", pd.getString("linkmanName"));
					pd.put("phone", pd.getString("phone"));
					pd.put("address", pd.getString("address"));
					pd.put("latitude", latAndlngMap.get("lat"));
					pd.put("longitude", latAndlngMap.get("lng"));
					pd.put("detailAddress", pd.getString("detailAddress"));
					pd.put("identity", pd.getString("sex"));
					pd.put("lable", pd.getString("lable"));
					pd.put("isDefault", pd.getString("isDefault"));
					pd.put("user_kehu_id", kehu.getUser_kehu_id());
					pd.put("create_time", Tools.date2Str(new Date()));//创建时间
					kehuService.saveaddress(pd);//执行新增收货地址
				}else {
					//批量设置成不是默认
					String ids= kehu.getUser_kehu_id();
					String Arrayids[]=ids.split(",");//分割成数组
					kehuService.setisDefaultON(Arrayids);
					pd.put("shouhuo_address_id", this.get32UUID());
					pd.put("linkmanName", pd.getString("linkmanName"));
					pd.put("phone", pd.getString("phone"));
					pd.put("address", pd.getString("address"));
					pd.put("latitude", latAndlngMap.get("lat"));
					pd.put("longitude", latAndlngMap.get("lng"));
					pd.put("detailAddress", pd.getString("detailAddress"));
					pd.put("identity", pd.getString("sex"));
					pd.put("lable", pd.getString("lable"));
					pd.put("isDefault", pd.getString("isDefault"));
					pd.put("user_kehu_id", kehu.getUser_kehu_id());
					pd.put("create_time", Tools.date2Str(new Date()));//创建时间
					kehuService.saveaddress(pd);//执行新增收货地址
				}
			}
			mv.setViewName("redirect:/api/kehu/shouhuoDizhi?tag="+pd.get("tag")+"&user_shangjia_id="+pd.get("user_shangjia_id")+"&lat="+pd.get("lats")+"&lng="+pd.get("lngs"));
		}else {
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:跳转修改收货地址页面
	 * @日期:2017-8-30下午6:16:54
	 */
	@RequestMapping(value="/bianjiDizhiEdit")
	public ModelAndView addressEdit() throws Exception{
		logBefore(logger, "--bianjiDizhiEdit----跳转修改收货地址页面--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			mv.addObject("lats", pd.get("lat"));
			mv.addObject("lngs", pd.get("lng"));
			mv.addObject("tag", pd.get("tag"));
			mv.addObject("user_shangjia_id", pd.get("user_shangjia_id"));
			pd.put("shouhuo_address_id", pd.getString("shouhuo_address_id"));
			pd = kehuService.addressEdit(pd); //根据id查询一条信息
			mv.addObject("pd", pd);
			mv.addObject("msg", "saveEdit");
			mv.setViewName("kehuduan/bianjiDizhi_edit");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行编辑收货地址
	 * @日期:2017-8-30下午6:17:06
	 */
	@RequestMapping(value="/saveEdit")
	@ResponseBody
	public ModelAndView saveEdit(HttpSession session) throws Exception{
		logBefore(logger, "--saveEdit--执行编辑收货地址-------");
		ModelAndView mv = new  ModelAndView();
		PageData pd = this.getPageData();
		KeHu kehu = (KeHu) session.getAttribute("h5User");//获取用户id
		if(isSession()){
			//批量设置成不是默认
			String ids= kehu.getUser_kehu_id();
			System.out.println(ids);
			if(pd.getString("isDefault").equals("1")){
				String Arrayids[]=ids.split(",");//分割成数组
				kehuService.setisDefaultON(Arrayids);
			}
			double lats = Double.parseDouble(pd.getString("lat"));
			double lngs = Double.parseDouble(pd.getString("lng"));
			Map<String, Object> latAndlngMap = LocationUtils.locationConvert(lats, lngs); 
			pd.put("shouhuo_address_id", pd.getString("shouhuo_address_id"));
			pd.put("linkmanName", pd.getString("linkmanName"));
			pd.put("phone", pd.getString("phone"));
			pd.put("address", pd.getString("address"));
			pd.put("latitude", latAndlngMap.get("lat"));
			pd.put("longitude", latAndlngMap.get("lng"));
			pd.put("detailAddress", pd.getString("detailAddress"));
			pd.put("identity", pd.getString("sex"));
			pd.put("lable", pd.getString("lable"));
			pd.put("isDefault", pd.getString("isDefault"));
			pd.put("user_kehu_fid", kehu.getUser_kehu_id());
			pd.put("update_time", Tools.date2Str(new Date()));//创建时间
			kehuService.saveEdit(pd);//执行编辑收货地址
		}else {
			mv.setViewName("redirect:/api/kehu/index");
		}
		mv.setViewName("redirect:/api/kehu/shouhuoDizhi.do?tag="+pd.getString("tag")+"&user_shangjia_id="+pd.getString("user_shangjia_id")+"&lat="+pd.get("lats")+"&lng="+pd.get("lngs"));
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行删除收货地址
	 * @日期:2017-8-30下午6:17:20
	 */
	@RequestMapping(value="/addressDelete")
	public ModelAndView addressDelete() throws Exception{
		logBefore(logger, "--addressDelete----执行删除收货地址--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			pd.put("shouhuo_address_id", pd.getString("shouhuo_address_id"));
			kehuService.addressDelete(pd);
			mv.setViewName("redirect:/api/kehu/shouhuoDizhi?tag="+pd.getString("tag")+"&user_shangjia_id="+pd.getString("user_shangjia_id")+"&lat="+pd.get("lat")+"&lng="+pd.get("lng"));
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:我的评价列表
	 * @日期:2017-8-30下午6:18:48
	 */
	@RequestMapping(value="/wodePingjia")
	public ModelAndView wodePingjia() throws Exception{
		logBefore(logger, "--wodePingjia----我的评价列表--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			pd.put("user_kehu_fid", getSessionUser().getUser_kehu_id());
			pd.put("type", "1");
			PageData count = kehuService.queryPingLunSum(pd);//查询对商家的评价总数
			List<PageData> wodePingjiaList = kehuService.getEvaluateList(pd);
			List<PageData> zuijialist= new ArrayList<PageData>();
			for (int i = 0; i < wodePingjiaList.size(); i++) {
				pd.put("evaluate_fid", wodePingjiaList.get(i).getString("evaluate_id"));
				PageData zuijiapd = kehuService.queryByevaluateId(pd);
				zuijialist.add(zuijiapd);
			}
			mv.addObject("count", count);
			mv.addObject("pd", pd);
			mv.addObject("zuijialist", zuijialist);
			mv.addObject("wodePingjiaList", wodePingjiaList);
			mv.setViewName("kehuduan/wodePingjia");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:追加评论页面
	 * @日期:2017-8-30下午6:18:48
	 */
	@RequestMapping(value="/zhuijia")
	public ModelAndView zhuijia() throws Exception{
		logBefore(logger, "--zhuijia----追加评论页面--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			mv.addObject("evaluate_id", pd.getString("evaluate_id"));
			mv.addObject("msg", "savezhuijia");
			mv.setViewName("kehuduan/zhuijia");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	 /**
	  * @作者:Lj
	  * @功能:执行保存追加评价
	  * @日期:2017-9-4上午10:46:05
	  */
    @RequestMapping(value="/savezhuijia")
    public ModelAndView savezhuijia() throws Exception{
        logBefore(logger, "--执行保存追加评价--");
        ModelAndView mv = new  ModelAndView();
        PageData pd=new PageData();
        pd = this.getPageData();
        if(isSession()){
        	pd.put("evaluate_id", pd.getString("evaluate_id"));
        	PageData sData = kehuService.queryByevaluateId(pd);
        	//商家
        	PageData sjPageData=new PageData();
        	sjPageData.put("evaluate_id", this.get32UUID());
        	sjPageData.put("evaluate_fid", sData.getString("evaluate_id"));//追加评论主键id
        	sjPageData.put("category", "2");//类别(1-首次评论，2-追加评论)
        	sjPageData.put("type", sData.getString("type"));//分类(1-评论商家，2-评论骑手)
        	sjPageData.put("content", pd.getString("pinglun"));//评价内容
        	sjPageData.put("time", DateUtil.getTime());//创建时间评论时间
        	kehuService.savemyeval(sjPageData);//执行保存订单评价
//        	sjPageData.put("score", sData.getString("sjscore"));//评分
//        	sjPageData.put("min", sData.getString("min"));//骑手送达全程使用的分钟
//        	sjPageData.put("user_kehu_fid", getSessionUser().getUser_kehu_id());//外键（客户的主键ID）
//        	sjPageData.put("user_shangjia_fid", sData.getString("user_shangjia_fid"));//外键（商户的主键ID）
//        	sjPageData.put("user_qishou_fid", sData.getString("user_qishou_fid"));//外键（骑手的主键ID）
//        	sjPageData.put("label", pd.getString("label"));//标签内容
            mv.setViewName("redirect:/api/kehu/wodePingjia.do");
        }else{
            mv.setViewName("redirect:/api/kehu/toLogin.do");
        }
        return mv;
    }
	
	/**
	 * @作者:Lj
	 * @功能:我的收藏列表
	 * @日期:2017-8-30下午6:22:42
	 */
	@RequestMapping(value="/wodeShoucang")
	public ModelAndView wodeShoucang() throws Exception{
		logBefore(logger, "--wodeShoucang----我的收藏列表--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			pd.put("user_kehu_fid", getSessionUser().getUser_kehu_id());
			pd.put("type", "1");
			List<PageData> shouCangList = kehuService.getShouCangList(pd);
			mv.addObject("shouCangList", shouCangList);
			mv.addObject("pd", pd);
			mv.setViewName("kehuduan/wodeShoucang");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:联系我们
	 * @日期:2017-8-30下午6:22:42
	 */
	@RequestMapping(value="/lianxiWomen")
	public ModelAndView lianxiWomen() throws Exception{
		logBefore(logger, "--lianxiWomen----联系我们--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		if(isSession()){
			List<PageData> lianxiwmList = kehuService.syslianxiwmList(pd);
			mv.addObject("lianxiwmList", lianxiwmList);
			mv.setViewName("kehuduan/lianxiWomen");
		}else{
			mv.setViewName("redirect:/api/kehu/index");
		}
		return mv;
	}
	
	/**
	 * @功能:去搜索商家页面
	 * @日期:2017-8-30下午6:22:42
	 */
	@RequestMapping(value="/toSearch")
	public ModelAndView toSearch() throws Exception{
		logBefore(logger, "--去搜索商家页面--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		
		mv.addObject("pd", pd);
		mv.setViewName("kehuduan/searchResult");
		
		return mv;
	}
	
	/**
	 * @功能:去平台公告列表页
	 * @日期:2017-8-30下午6:22:42
	 */
	@RequestMapping(value="/toNoticeList")
	public ModelAndView toNoticeList() throws Exception{
		logBefore(logger, "--去平台公告列表页--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		//平台公告
		List<PageData>	noticeList = noticeService.headNewsList(pd);	
		mv.addObject("noticeList", noticeList);
		
		mv.setViewName("kehuduan/pingtaiGonggao");
		
		return mv;
	}
	
	/**
	 * @功能:去平台公告详情页
	 * @日期:2017-8-30下午6:22:42
	 */
	@RequestMapping(value="/toNoticeDetaile")
	public ModelAndView toNoticeDetaile() throws Exception{
		logBefore(logger, "--去平台公告详情页--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		//平台公告
		pd=noticeService.getHeadNewsById(pd);
		mv.addObject("pd", pd);
		
		mv.setViewName("kehuduan/pingtaiGonggaoDetaile");
		
		return mv;
	}
	
	//从订单、我的评价、我的收藏中访问商家详情时,判断商家是否营业、是否在配送范围内
	@RequestMapping(value="/toShopByInfo")
	public ModelAndView toShopByInfo() throws Exception{
		logBefore(logger, "--从订单、我的评价、我的收藏中访问商家详情时,判断商家是否营业、是否在配送范围内--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		
		String respCode="01";
		String respMsg="成功";
		
		//根据ID获取商家信息
		PageData pd1=kehuService.getShangJiaDataByID(pd);
		
		//计算客商之间的距离
		double lat1 = Double.parseDouble(pd.get("lat").toString());
		double lng1 = Double.parseDouble(pd.get("lng").toString());
		double lat2 = Double.parseDouble(pd1.get("latitude").toString());
		double lng2 = Double.parseDouble(pd1.get("longitude").toString());
		double distance = LocationUtils.getDistance(lat1,lng1,lat2,lng2);
		distance = distance/1000;
		
		//商家配送范围为空，或者在配送范围内，则该商家显示
		double temp=0;
		if(Tools.notEmpty(pd1.getString("psRange"))){
			temp=Double.parseDouble(pd1.getString("psRange"));
		}
		
		//判断商家是否营业
		if(pd1.getString("isOpen").equals("0")){
			respCode="00";
			respMsg="很遗憾,该商家已经打烊了!";
		}else{
			//判断是否在配送范围内
			if(distance>temp && temp!=0){//不在配送范围内
				respCode="00";
				respMsg="很遗憾,您当前位置不在该商家的配送范围内!";
			}
		}
		
		if(respCode.equals("01")){
			mv.setViewName("redirect:/api/kehu/shop?user_shangjia_id="+pd.getString("user_shangjia_id")+"&mkID="+pd.getString("mkID"));
		}else{
			mv.addObject("respMsg", respMsg);
			mv.setViewName("kehuduan/emptyResult");
		}
		return mv;
	}
	
	
	//======================================我的end=============================================//
	
	/**
	 * 判断一串字符串中是否含有非数字字符
	 * 无：返回TRUE
	 * 有：返回FALSE
	 * @param str
	 * @return
	 */
	public boolean isNumeric(String str) {
		for (int i = str.length(); --i >= 0;) {
			if (!Character.isDigit(str.charAt(i))) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 判断session是否存在
	 * 存在：返回TRUE
	 * 反之：返回FALSE
	 * @return
	 */
	public boolean isSession(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		KeHu keHu=(KeHu) session.getAttribute("h5User");
		if(keHu==null){
			return false;
		}
		return true;
	}
	
	/**
	 * 获取session对象
	 * @return
	 */
	public KeHu getSessionUser(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		KeHu KeHu=(KeHu) session.getAttribute("h5User");
		return KeHu;
	}
	
	/**
	 * 创建用户session
	 * @throws Exception 
	 */
	public void createSession(String user_shanghu_id) throws Exception{
		PageData pd=new PageData();
		pd.put("user_shanghu_id", user_shanghu_id);
		PageData tempData=kehuService.getDataByNameOrPhone(pd);
		KeHu kehu=new KeHu();
		kehu.setUser_kehu_id(tempData.getString("user_kehu_id"));
		kehu.setPhone(tempData.getString("phone"));
		kehu.setUserName(tempData.getString("userName"));
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		session.setAttribute("h5User",kehu);
	}
	
	/**
	 * 
	 * 退出 销毁session
	 * 
	 */
	public void removeSession(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		session.removeAttribute("h5User");
	}
	
	
}
