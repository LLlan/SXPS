package com.yizhan.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 
 * @类名称： LocationUtils
 * @作者：lj 
 * @时间： 2017-7-4 上午8:28:55
 *
 */
public class LocationUtils {
//	private static double EARTH_RADIUS = 6378.137;    
//    
//    private static double rad(double d) {    
//        return d * Math.PI / 180.0;    
//    }    
	private static final double EARTH_RADIUS = 6378.137;

	private static double rad(double d) {
		return d * Math.PI / 180.0;
	}
    /**   
     * 第一种换算
     * 通过经纬度获取距离(单位：米)   
     * @param lat1   
     * @param lng1   
     * @param lat2   
     * @param lng2   
     * @return   
     */    
    public static double getDistance(double lat1, double lng1, double lat2,double lng2) {    
        double radLat1 = rad(lat1);    
        double radLat2 = rad(lat2);    
        double a = radLat1 - radLat2;    
        double b = rad(lng1) - rad(lng2);    
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)    
                + Math.cos(radLat1) * Math.cos(radLat2)    
                * Math.pow(Math.sin(b / 2), 2)));    
        s = s * EARTH_RADIUS;    
        s = Math.round(s * 10000d) / 10000d;    
        s = s*1000;    
        return s;    
    }
	
	/**
	 * 第二种换算
	 * @param lat1
	 * @param lng1
	 * @param lat2
	 * @param lng2
	 * @return
	 */
	public static double getDistance2(double lat1, double lng1, double lat2, double lng2){
		double radLat1 = rad(lat1);
		double radLat2 = rad(lat2);
		double a = radLat1 - radLat2;
		double b = rad(lng1) - rad(lng2);
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(radLat1) * Math.cos(radLat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000;
		return s;
	}
	
	/**
	 * 第三种换算
	 * @param long1
	 * @param lat1
	 * @param long2
	 * @param lat2
	 * @return
	 */
	public static double getDistance3(double long1, double lat1, double long2,double lat2) {
		double a, b, R;
		R = 6378137; // 地球半径
		lat1 = lat1 * Math.PI / 180.0;
		lat2 = lat2 * Math.PI / 180.0;
		a = lat1 - lat2;
		b = (long1 - long2) * Math.PI / 180.0;
		double d;
		double sa2, sb2;
		sa2 = Math.sin(a / 2.0);
		sb2 = Math.sin(b / 2.0);
		d = 2 * R * Math.asin(Math.sqrt(sa2 * sa2 + Math.cos(lat1) * Math.cos(lat2) * sb2 * sb2));
		return d;
	}  
	
	/**
	 * 谷歌或者腾讯坐标转换为百度坐标
	 * 功能：
	 * 作者：yangym
	 * 日期：2017-9-11
	 */
	public static Map locationConvert( double lat, double lng){
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
		System.out.println("lat是："+lat);
		System.out.println("lng是："+lng);
		map.put("lat", lat);
		map.put("lng", lng);
		return map;
	}
	
	public static void main(String[] args){
		Double dd = getDistance(20.02207128,110.33080185,20.035152488266153,110.33341304279185);
		System.out.println(dd);
	}
}
