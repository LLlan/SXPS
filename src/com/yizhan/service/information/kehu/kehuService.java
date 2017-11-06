package com.yizhan.service.information.kehu;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yizhan.dao.DaoSupport;
import com.yizhan.entity.Page;
import com.yizhan.util.PageData;
/**
 * h5Service
 * 功能：
 * 作者： yangym
 * date：2017-8-9
 *
 */

@Service("kehuService")
public class kehuService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 根据手机号或者用户名去查询用户信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getDataByNameOrPhone(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getDataByNameOrPhone", pd);
	}
	
	/**
	 * 根据ID查询用户信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getUserDataByID(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getUserDataByID", pd);
	}
	
	/**
	 * 保存客户端用户信息
	 * @param pd
	 * @throws Exception
	 */
	public void saveU(PageData pd) throws Exception{
		dao.save("kehuMapper.saveKeHuUser", pd);
	}
	
	/**
	 * 根据手机号判断该用户是否已经存在 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getUserDataByPhone(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getUserDataByPhone", pd);
	}
	
	/**
	 * 根据登录名和密码获取对象信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getDataByPhoneAndPassWord(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getDataByPhoneAndPassWord", pd);
	}
	
	/**
	 * 每次登录时,更新登录时间和IP
	 * @param pd
	 * @throws Exception
	 */
	public void updateLoginTimeAndIp(PageData pd) throws Exception{
		dao.update("kehuMapper.updateLoginTimeAndIp", pd);
	}
	
	/**
	 * 根据手机号修改登录密码
	 * @param pd
	 * @throws Exception
	 */
	public void updatePasswordByPhone(PageData pd) throws Exception{
		dao.update("kehuMapper.updatePasswordByPhone", pd);
	}
	
	/**
	 * @作者：Lj
	 * @功能:上传与修改保存头像
	 * @日期：2017-8-30上午10:44:00
	 */
	public void touxiang(PageData pd) throws Exception {
		 dao.update("kehuMapper.touxiang", pd);
	}
	
	/**
	 * @作者：Lj
	 * @功能:执行修改用户名
	 * @日期：2017-8-30上午10:45:40
	 */
	public void saveyonghuming(PageData pd) throws Exception {
		dao.save("kehuMapper.saveyonghuming", pd);
	}
	
	/**
	 * 收货地址列表
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> addressList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.addressList",pd);
	}
	
	/**
	 * 执行新增收货地址
	 * @param pd
	 * @throws Exception
	 */
	public void saveaddress(PageData pd) throws Exception {
		dao.save("kehuMapper.saveaddress", pd);
	}
	
	/**
	 * 执行编辑收货地址
	 * @param pd
	 * @throws Exception
	 */
	public void saveEdit(PageData pd) throws Exception {
		dao.update("kehuMapper.saveEdit", pd);
	}
	/**
	 * 设置为默认收货地址
	 * @param pd
	 * @throws Exception
	 */
	public void isDefault(PageData pd) throws Exception {
		dao.update("kehuMapper.isDefault", pd);
	}
	
	/**
	 * 执行删除收货地址
	 * @param pd
	 * @throws Exception
	 */
	public void addressDelete(PageData pd) throws Exception {
		dao.delete("kehuMapper.addressDelete", pd);
	}
	
	/**
	 * 批量设置成不是默认
	 */
	public void setisDefaultON(String[] ids) throws Exception{
		dao.update("kehuMapper.setisDefaultON", ids);
	}
	
	/**
	 * 根据id查询一条信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData addressEdit(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.addressEdit", pd);
	}
	
	/**
	 * 确认订单的默认地址
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getByisDefault(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getByisDefault", pd);
	}
	
	/**
	 * 查询电话号码是否重复，即该用户是否注册过
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData findByPhone(PageData pd)throws Exception{
		return (PageData)dao.findForObject("kehuMapper.findByPhone", pd);
	}
	
	/**
	 * 换绑手机新手机号
	 * @param pd
	 * @throws Exception
	 */
	public void updatephone(PageData pd) throws Exception {
		dao.update("kehuMapper.updatephone", pd);
		
	}
	
	/**
	 * 设置支付密码
	 * @param pd
	 * @throws Exception
	 */
	public void updatepayPassword(PageData pd) throws Exception {
		dao.update("kehuMapper.updatepayPassword", pd);
		
	}
	
	/**
	 * 动态码表类型
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> selectall(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.selectall",pd);
	}
	
	/**
	 * 动态社区列表
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> selecHuDongSheQuList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.selecHuDongSheQuList",pd);
	}
	
	/**
	 * 根据id查询一条信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData queryHudongDongtai(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.queryHudongDongtai", pd);
	}
	
	
	/**
	 * 美食外卖商家页面列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> businessList(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("kehuMapper.businessList", pd);
	}
	
	/**
	 * 轮播图列表
	 * @作者:lj
	 * 2017-8-24下午5:41:38
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> picturesList(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("kehuMapper.picturesList", pd);
	}
	/**
	 * 导航八大模块
	 * @作者:lj
	 * 2017-8-24下午5:41:38
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> getMoKuaiList(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("kehuMapper.getMoKuaiList", pd);
	}
	
	
	/**
	 * 商家码表类型
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> goodsCategoryList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.goodsCategoryList",pd);
	}
	
	/**
	 * 商家商品列表
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> goodsList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.goodsList",pd);
	}
	
	/**
	 * 商家详情
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData queryUserShangjia(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.queryUserShangjia", pd);
	}
	
	/**
	 * 去商品详情页面
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData queryshangpingxing(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.queryshangpingxing", pd);
	}
	
	/**
	 * ajax 请求 页面初始化 根据商品分类名字和商家id查出列表数据
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> getDataByCategoryNameAndId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.getDataByCategoryNameAndId",pd);
	}
	
	
	/**
	 * 保存外卖订单
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-3
	 */
	public void insertOrderTakeou(PageData pd) throws Exception {
		dao.save("kehuMapper.insertOrderTakeou",pd);
	}
	
	/**
	 * 保存外卖订单商品表 一个外卖单对应多个商品 这是关系表
	 * @param pd
	 * @throws Exception
	 */
	public void insertOrderGoods(PageData pd) throws Exception {
		dao.save("kehuMapper.insertOrderGoods",pd);
	}
	
	/**
	 * 我的外卖全部订单
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> queryOrderTakeouLists(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("kehuMapper.queryOrderTakeouLists", pd);
	}
	
	/**
	 * 订单详情
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData querytbOrderTakeou(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.querytbOrderTakeou", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:将此条订单设置成已被评价过
	 * @日期:2017-9-4下午2:14:48
	 */
	public void setIsEvaluate(PageData pd) throws Exception {
		dao.update("kehuMapper.setIsEvaluate", pd);
		
	}
	
	/**
	 * 执行删除外卖订单
	 * @param pd
	 * @throws Exception
	 */
	public void quxiaoOrderDelete(PageData pd) throws Exception {
		dao.delete("kehuMapper.quxiaoOrderDelete", pd);
	}
	
	/**
	 * 执行删除外卖订单
	 * @param pd
	 * @throws Exception
	 */
	public void quxiaoOrderGoodsDelete(PageData pd) throws Exception {
		dao.delete("kehuMapper.quxiaoOrderGoodsDelete", pd);
	}
	
	/**
	 * 客户端详细商家商品列表
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> kehuOrderGoodsLists(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.kehuOrderGoodsLists",pd);
	}
	
	/**
	 * 客户端正在进行中的订单
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData queryOrderTakeouHaveInHand(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.queryOrderTakeouHaveInHand", pd);
	}

	
	/**
	 * 保存临时订单表
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-2
	 */
	public void saveTempOrder(PageData pd) throws Exception {
		dao.update("kehuMapper.saveTempOrder", pd);
		
	}
	
	/**
	 * 删除临时订单 根据客户id
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-2
	 */
	public void delTempOrder(PageData pd) throws Exception {
		dao.delete("kehuMapper.delTempOrder", pd);
		
	}
	/**
	 * 减到0则删除
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-17
	 */
	public void delTempOrderBySpID(PageData pd) throws Exception {
		dao.delete("kehuMapper.delTempOrderBySpID", pd);
		
	}
	
	/**
	 *  修改临时订单表的某件商品的数量 
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-17
	 */
	public void updateNumberbyId(PageData pd) throws Exception {
		dao.delete("kehuMapper.updateNumberbyId", pd);
		
	}
	
	/**
	 * 查询临时订单
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-2
	 */
	public List<PageData> selectTempOrderList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.selectTempOrderList",pd);
	}
	
	/**
	 * 查询总价格
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-2
	 */
	public PageData getTotolByUserKeHuID(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getTotolByUserKeHuID", pd);
	}
	
	/**
	 * 查询最大的取餐号
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-3
	 */
	public PageData selectMaxQucanNumber(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.selectMaxQucanNumber", pd);
	}
	
	/**
	 * 查询商家的起送价格
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-3
	 */
	public PageData getqisonjiagebyID(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getqisonjiagebyID", pd);
	}
	
	/**
	 * 查餐盒费
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-8
	 */
	public PageData getCanhefeiSUM(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getCanhefeiSUM", pd);
	}
	
	
	/**
	 * 更新订单编号到订单表中
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-9
	 */
	public void updateOrderNumber(PageData pd) throws Exception {
		dao.update("kehuMapper.updateOrderNumber", pd);
		
	}
	public void updateOrderNumberById(PageData pd) throws Exception {
		dao.update("kehuMapper.updateOrderNumberById", pd);
		
	}
	/**
	 * 根据订单编号获取订单信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getOrderInforByOrderNumber(PageData pd) throws Exception {
		return (PageData) dao.findForObject("kehuMapper.getOrderInforByOrderNumber", pd);
		
	}
	
	/**
	 * 更新订单信息
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-9
	 */
	public void updateOrderInfoByOrderNumber(PageData pd) throws Exception {
		dao.update("kehuMapper.updateOrderInfoByOrderNumber", pd);
		
	}
	
	/**
	 * 根据用户id查询一条同城订单是否存在进行中信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getorderTongchengjinxing(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getorderTongchengjinxing", pd);
	}
	
	/**
	 * 根据用户id查询一条同城订单是否存在未付款信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getorderTongcheng(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getorderTongcheng", pd);
	}
	
	/**
	 * 根据用户id查询一条同城订单是否存在已接驾订单
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getorderTongyijiejia(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getorderTongyijiejia", pd);
	}
	
	/**
	 * 根据用户id查询一条长途订单是否存在未付款信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getorderChangtu(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getorderChangtu", pd);
	}
	
	/**
	 * 根据外卖订单编号获取查询商家的id
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData geuserShangjiaFid(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.geuserShangjiaFid", pd);
	}
	
	/**
	 * 根据同城信息ID获取查询司机id
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getUserSijiFid(PageData pd) throws Exception{
		return (PageData) dao.findForObject("kehuMapper.getUserSijiFid", pd);
	}
	
	/**
	 * 获取指定司机设备ID
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData queryRegistrationID(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.queryRegistrationID", pd);
	}
	
	
	/**
	 * 满减优惠列表
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-8-31
	 */
	public List<PageData> getMjyhList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.getMjyhList",pd);
	}
	/**
	 * 满减配送费列表
	 */
	public List<PageData> getMjpsfList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.getMjpsfList",pd);
	}
	
	/**
     * @作者:Lj
     * @功能:评价标签码列表以及包括每个标签的评价次数
     * @日期:2017-8-31下午6:27:48
     */
    public List<PageData> sysLabelList(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("kehuMapper.sysLabelList",pd);
    }
    /**
     * 获取商家的评论列表
     * @param pd
     * @return
     * @throws Exception
     */
    public List<PageData> getEvaluateListOfShangJia(PageData pd) throws Exception {
    	return (List<PageData>) dao.findForList("kehuMapper.getEvaluateListOfShangJia",pd);
    }
    
    /**
     * @作者:Lj
     * @功能:执行保存订单评价
     * @日期:2017-9-1上午8:47:57
     */
    public void savemyeval(PageData pd) throws Exception {
        dao.save("kehuMapper.savemyeval", pd);
    }
    
    /**
     * @作者:Lj
     * @功能:执行保存评价标签关系表
     * @日期:2017-9-1下午2:09:56
     */
    public void saveEvaluateLabel(PageData pd) throws Exception {
    	dao.save("kehuMapper.saveEvaluateLabel", pd);
    }
    
    /**
     * @作者:Lj
     * @功能:我的评价列表
     * @日期:2017-9-1下午3:26:21
     */
    public List<PageData> getEvaluateList(PageData pd) throws Exception {
    	return (List<PageData>) dao.findForList("kehuMapper.getEvaluateList",pd);
    }
    
    /**
     * @作者:Lj
     * @功能:查询对商家的评价总数
     * @日期:2017-9-4上午10:34:35
     */
    public PageData queryPingLunSum(PageData pd) throws Exception{
    	return (PageData)dao.findForObject("kehuMapper.queryPingLunSum", pd);
    }
    
    /**
     * @作者:Lj
     * @功能:查询商家的商品出售后的，各类评价的总数
     * @日期:2017-9-5下午2:10:50
     */
    public PageData queryGeLeiPJSum(PageData pd) throws Exception{
    	return (PageData)dao.findForObject("kehuMapper.queryGeLeiPJSum", pd);
    }
    
    /**
     * @作者:Lj
     * @功能:根据id查询追评的评价
     * @日期:2017-9-4上午10:34:35
     */
	public PageData queryByevaluateId(PageData pd) throws Exception{
		return (PageData)dao.findForObject("kehuMapper.queryByevaluateId", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:我的收藏列表
	 * @日期:2017-9-4下午2:56:00
	 */
	public List<PageData> getShouCangList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.getShouCangList",pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:查询是否已被收藏过了
	 * @日期:2017-9-6上午9:14:38
	 */
	public PageData selectShouCang(PageData pd) throws Exception {
		return (PageData) dao.findForObject("kehuMapper.selectShouCang",pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行收藏商家店铺
	 * @日期:2017-9-6上午9:14:54
	 */
	public void insertShouCang(PageData pd) throws Exception {
		dao.save("kehuMapper.insertShouCang",pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行删除收藏商家店铺（执行取消收藏）
	 * @日期:2017-9-6上午11:52:13
	 */
	public void deletelShouCang(PageData pd) throws Exception {
		dao.delete("kehuMapper.deletelShouCang", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:联系我们
	 * @日期:2017-9-7下午4:28:22
	 */
	public List<PageData> syslianxiwmList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("kehuMapper.syslianxiwmList",pd);
	}
	
	
	/**
	 * 查看商品详情
	 */
	public PageData getGoodDetailByID(PageData pd) throws Exception {
		return (PageData) dao.findForObject("kehuMapper.getGoodDetailByID",pd);
	}
	/**
	 * 根据ID获取商家信息 
	 */
	public PageData getShangJiaDataByID(PageData pd) throws Exception {
		return (PageData) dao.findForObject("kehuMapper.getShangJiaDataByID",pd);
	}
}

