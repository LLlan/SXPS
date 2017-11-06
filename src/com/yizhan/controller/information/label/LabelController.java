package com.yizhan.controller.information.label;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yizhan.controller.base.BaseController;
import com.yizhan.entity.Page;
import com.yizhan.service.information.h5sys.h5sysService;
import com.yizhan.service.information.label.LabelService;
import com.yizhan.util.AppUtil;
import com.yizhan.util.DateUtil;
import com.yizhan.util.PageData;
import com.yizhan.util.Tools;

/**
 * h5后台系统设置
 * @类名称： h5sysController
 * @作者：lj 
 * @时间： 2017-8-7 下午3:28:49
 *
 */
@Controller
@RequestMapping(value="/label")
public class LabelController extends BaseController {

	@Resource(name = "labelService")
	private LabelService labelService;
	
	/**
	 * 获取标签列表
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/getLabellistPage")
	public ModelAndView getLabellistPage(Page page){
		logBefore(logger, "-------获取标签列表---------");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			String searchName="";
			searchName=pd.getString("searchName");
			
			if(Tools.notEmpty(pd.getString("searchName"))){
				if(pd.getString("searchName").equals("商家") 
						|| pd.getString("searchName").equals("商") 
						|| pd.getString("searchName").equals("家")){
					pd.put("searchName", "1");
				}else if(pd.getString("searchName").equals("骑手") 
						|| pd.getString("searchName").equals("骑") 
						|| pd.getString("searchName").equals("手")){
					pd.put("searchName", "2");
				}
			}
			page.setPd(pd);
			
 			List<PageData> list = labelService.getLabellistPage(page);
 			pd.put("searchName", searchName);
 			mv.addObject("pd",pd);
 			mv.addObject("list",list);
 			mv.setViewName("information/label/label_list");
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
		return mv;
	}
	
	/**
	 * 添加页面
	 * @return
	 */
	@RequestMapping(value="/goToAdd")
	public ModelAndView goToAdd(){
		logBefore(logger, "------添加页面-----");
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "insert");
		mv.setViewName("information/label/label_edit");
		return mv;
	}
	
	/**
	 * 添加
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/insert")
	public ModelAndView insert() throws Exception{
		logBefore(logger, "------添加-------");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd.put("label_id", this.get32UUID());
		labelService.insert(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	/**
	 * 判断名称是否存在
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/isExist")
	@ResponseBody
	public Object isExist() throws Exception{
		logBefore(logger, "------判断名称是否存在-----");
		Map<String, Object> map=new HashMap<String, Object>();
		PageData pd=new PageData();
		pd=this.getPageData();
		PageData pd1 = labelService.getDateByIdorName(pd);
		
		String respCode="00";
		String respMsg="失败,该标签名称已经存在";
		
		if(pd1==null){
			respCode="01";
			respMsg="成功";
		}
		map.put("respCode", respCode);
		map.put("respMsg", respMsg);
		return AppUtil.returnObject(pd, map);
	}
	/**
	 * 编辑页面
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/goToEdit")
	public ModelAndView goToEdit() throws Exception{
		logBefore(logger, "------编辑页面-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		pd  = labelService.getDateByIdorName(pd);
		mv.addObject("pd", pd);
		mv.addObject("msg", "update");
		mv.setViewName("information/label/label_edit");
		return mv;
	}
	
	/**
	 * 编辑
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/update")
	public ModelAndView update() throws Exception{
		logBefore(logger, "------编辑-----");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		labelService.update(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	/**
	 * 删除
	 * @param writer
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter writer) throws Exception{
		logBefore(logger, "---删除--");
		PageData pd=new PageData();
		Map<String, Object> map=new HashMap<String, Object>();
		pd=this.getPageData();
		String id[]=pd.getString("ids").split(",");
		List<String> ids=new ArrayList<String>();
		for (int i = 0; i < id.length; i++) {
			ids.add(id[i]);
		}
		map.put("ids", ids);
		labelService.delete(map);
		writer.close();
	}
}
