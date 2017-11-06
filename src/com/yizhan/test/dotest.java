package com.yizhan.test;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.fusioncharts.database.DBConnection;
import com.weixin.method.staticMethod;
import com.weixin.test.GetUrl;
import com.yizhan.util.FileUtil;
import com.yizhan.util.PathUtil;

public class dotest {

	/**
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-3-30
	 */
	public static void main(String[] args) {
		
		dotest.zhuan(20.029484,110.327492);
	}
	
	public static Map zhuan( double lat, double lng){
		Map map = new HashMap();
		double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
		/// <summary>
		/// 中国正常坐标系GCJ02协议的坐标，转到 百度地图对应的 BD09 协议坐标
		/// </summary>
		/// <param name="lat">维度</param>
		/// <param name="lng">经度</param>
		double x = lng, y = lat;
		double z =Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
		double theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
		lng = z * Math.cos(theta) + 0.0065;
		lat = z * Math.sin(theta) + 0.006;
		System.out.println(lat);
		System.out.println(lng);
		map.put("lat", lat);
		map.put("lng", lng);
		return map;
	}

}
