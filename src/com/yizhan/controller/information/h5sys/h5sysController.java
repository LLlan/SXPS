package com.yizhan.controller.information.h5sys;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.yizhan.controller.base.BaseController;
import com.yizhan.entity.Page;
import com.yizhan.service.information.h5sys.h5sysService;
import com.yizhan.util.DateUtil;
import com.yizhan.util.PageData;

/**
 * h5后台系统设置
 * @类名称： h5sysController
 * @作者：lj 
 * @时间： 2017-8-7 下午3:28:49
 *
 */
@Controller
@RequestMapping(value="/h5sys")
public class h5sysController extends BaseController {

	@Resource(name = "h5sysService")
	private h5sysService h5sysService;
	
	/**
	 * 配送规则分页列表
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/h5PeisongfeiListPage")
	public ModelAndView h5PeisongfeiListPage(Page page){
		logBefore(logger, "-------配送规则分页列表---------");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			page.setPd(pd);
 			List<PageData> h5KeHuServiceList = h5sysService.peisongfeilistPage(page);
 			mv.addObject("pd",pd);
 			mv.addObject("h5KeHuServiceList",h5KeHuServiceList);
 			mv.setViewName("information/h5sys/peisongfei_list");
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
		return mv;
	}
	
	/**
	 * 配送费规则添加页面
	 * @return
	 */
	@RequestMapping(value="/peisongfeiAdd")
	public ModelAndView peisongfeiAdd(){
		logBefore(logger, "------配送费规则添加页面-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "saveinsert");
		mv.setViewName("information/h5sys/peisongfei_edit");
		return mv;
	}
	
	/**
	 * 执行配送费规则添加
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/saveinsert")
	public ModelAndView saveinsert() throws Exception{
		logBefore(logger, "------执行配送费规则添加-------");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("peisongfei_id", this.get32UUID());
		pd.put("gongli1", pd.getString("gongli1"));
		pd.put("gongli2", pd.getString("gongli2"));
		pd.put("gongli3", pd.getString("gongli3"));
		pd.put("gongli4", pd.getString("gongli4"));
		h5sysService.saveinsert(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 配送费规则编辑页面
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/goPeisongfeiEdit")
	public ModelAndView goPeisongfeiEdit() throws Exception{
		logBefore(logger, "------配送费规则编辑页面-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd  = h5sysService.getDateBypeisongfeiId(pd);
		mv.addObject("pd", pd);
		mv.addObject("msg", "sysPeisongfeiupdate");
		mv.setViewName("information/h5sys/peisongfei_edit");
		return mv;
	}
	
	/**
	 * 执行配送费规则编辑
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/sysPeisongfeiupdate")
	public ModelAndView sysPeisongfeiupdate() throws Exception{
		logBefore(logger, "------执行配送费规则编辑-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("gongli1", pd.getString("gongli1"));
		pd.put("gongli2", pd.getString("gongli2"));
		pd.put("gongli3", pd.getString("gongli3"));
		pd.put("gongli4", pd.getString("gongli4"));
		h5sysService.sysPeisongfeiupdate(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 执行配送费规则删除与批量删除
	 * @param writer
	 * @throws Exception
	 */
	@RequestMapping(value="/sysPeisongfeiDelete")
	public void sysPeisongfeiDelete(PrintWriter writer) throws Exception{
		logBefore(logger, "-----执行配送费规则删除与批量删除-----");
		PageData pd=new PageData();
		pd=this.getPageData();
		String str[]=pd.getString("ids").split(",");
		List<String> ids=new ArrayList<String>();
		for (int i = 0; i < str.length; i++) {
			ids.add(str[i]);
		}
		pd.put("ids", ids);
		h5sysService.sysPeisongfeiDelete(pd);
		writer.close();
	}
	
	//************平台服务费规则***************//
	/**
	 * 服务费规则分页列表
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/fuwufeiListPage")
	public ModelAndView fuwufeiListPage(Page page){
		logBefore(logger, "-------服务费规则分页列表---------");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			page.setPd(pd);
 			List<PageData> fuwufeiList = h5sysService.fuwufeiListPage(page);
 			mv.addObject("pd",pd);
 			mv.addObject("fuwufeiList",fuwufeiList);
 			mv.setViewName("information/h5sys/fuwufei_list");
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
		return mv;
	}
	
	/**
	 * 服务费规则添加页面
	 * @return
	 */
	@RequestMapping(value="/fuwufeiAdd")
	public ModelAndView fuwufeiAdd(){
		logBefore(logger, "------服务费规则添加页面-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "saveFuwufei");
		mv.setViewName("information/h5sys/fuwufei_edit");
		return mv;
	}
	
	/**
	 * 执行服务费规则添加
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/saveFuwufei")
	public ModelAndView saveFuwufei() throws Exception{
		logBefore(logger, "------执行服务费规则添加-------");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("fuwufei_id", this.get32UUID());
		h5sysService.saveFuwufei(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 服务费规则编辑页面
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/gofuwufeiEdit")
	public ModelAndView gofuwufeiEdit() throws Exception{
		logBefore(logger, "------服务费规则编辑页面-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd  = h5sysService.getDateByfuwufeiId(pd);
		mv.addObject("pd", pd);
		mv.addObject("msg", "sysFuwufeiUpdate");
		mv.setViewName("information/h5sys/fuwufei_edit");
		return mv;
	}
	
	/**
	 * 执行服务费规则编辑
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/sysFuwufeiUpdate")
	public ModelAndView sysFuwufeiUpdate() throws Exception{
		logBefore(logger, "------执行服务费规则编辑-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		h5sysService.sysFuwufeiUpdate(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	//****************联系我们（开始）********************//
	
	/**
	 * @作者:Lj
	 * @功能:联系我们分页列表
	 * @日期:2017-9-7上午11:41:51
	 */
	@RequestMapping(value="/sysContactwmListPage")
	public ModelAndView sysContactwmListPage(Page page){
		logBefore(logger, "-------联系我们分页列表---------");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			page.setPd(pd);
 			List<PageData> lianxiwmList = h5sysService.sysContactwmListPage(page);
 			mv.addObject("pd",pd);
 			mv.addObject("lianxiwmList",lianxiwmList);
 			mv.setViewName("information/h5sys/lianxiwomen_list");
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:联系我们添加页面
	 * @日期:2017-9-7上午11:50:49
	 */
	@RequestMapping(value="/lianxiwmAdd")
	public ModelAndView lianxiwmAdd(){
		logBefore(logger, "------联系我们添加页面-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "saveLianxiwm");
		mv.setViewName("information/h5sys/lianxiwm_edit");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行联系我们新增数据
	 * @日期:2017-9-7上午11:54:16
	 */
	@RequestMapping(value="/saveLianxiwm")
	public ModelAndView saveLianxiwm() throws Exception{
		logBefore(logger, "------执行联系我们新增数据-------");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("contact_id", this.get32UUID());//主键id
		pd.put("create_time", DateUtil.getTime());//创建时间
		h5sysService.saveLianxiwm(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行去联系我们编辑页面
	 * @日期:2017-9-7上午11:54:51
	 */
	@RequestMapping(value="/golianxiwmEdit")
	public ModelAndView golianxiwmEdit() throws Exception{
		logBefore(logger, "------执行去联系我们编辑页面-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd  = h5sysService.golianxiwmEditId(pd);//根据ID获取联系我们的一条对象信息
		mv.addObject("pd", pd);
		mv.addObject("msg", "lianxiwmUpdate");
		mv.setViewName("information/h5sys/lianxiwm_edit");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行编辑联系我们
	 * @日期:2017-9-7上午11:57:14
	 */
	@RequestMapping(value="/lianxiwmUpdate")
	public ModelAndView lianxiwmUpdate() throws Exception{
		logBefore(logger, "------执行编辑联系我们-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("update_time", DateUtil.getTime());//修改时间
		h5sysService.lianxiwmUpdate(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行删除联系我们
	 * @日期:2017-9-7下午12:04:15
	 */
	@RequestMapping(value="/deletelianxiwm")
	public void deletelianxiwm(PrintWriter writer) throws Exception{
		logBefore(logger, "---执行删除联系我们--");
		PageData pd=new PageData();
		Map<String, Object> map=new HashMap<String, Object>();
		pd=this.getPageData();
		String id[]=pd.getString("ids").split(",");
		List<String> ids=new ArrayList<String>();
		for (int i = 0; i < id.length; i++) {
			ids.add(id[i]);
		}
		map.put("ids", ids);
		h5sysService.deletelianxiwm(map);
		writer.close();
	}
	
	//****************联系我们（结束）********************//
}
