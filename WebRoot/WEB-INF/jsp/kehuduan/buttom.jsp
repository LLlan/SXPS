<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <!--底部导航-->
    <div class="weui-tabbar wy-foot-menu">
        <a href="api/kehu/index.do" id="t1" class="weui-tabbar__item weui-bar__item--on">
            <div class="weui-tabbar__icon iconfont icon-shouye1"></div>
            <p class="weui-tabbar__label">首页</p>
        </a>
      <!--   <a href="api/kehu/gouwuche.do" id="t2" class="weui-tabbar__item">
            <div class="weui-tabbar__icon iconfont icon-gouwuche"></div>
            <p class="weui-tabbar__label">购物车</p>
        </a> -->
        <a href="api/kehu/orders" id="t3" class="weui-tabbar__item">
            <div class="weui-tabbar__icon iconfont icon-dingdanliebiao"></div>
            <p class="weui-tabbar__label">订单</p>
        </a>
        <a href="api/kehu/wode.do" id="t4" class="weui-tabbar__item">
            <div class="weui-tabbar__icon iconfont icon-wode"></div>
            <p class="weui-tabbar__label">我的</p>
        </a>
    </div>
