# 自动接入口袋工厂

## 前置工作
1. 下载Godot 4.X  
2. 安装了AndroidStudio且Godot的安卓导出正常  

> 广告插件仅支持安卓平台导出  
> 如果您使用Windows 7，有可能出现问题

## 快速开始

- 下载[广告插件本体](https://github.com/Abab-bk/FlowerAD)，并放进一个文件夹  

- 将本项目克隆或复制到addons文件夹内，不要忘记激活插件！  

- 选择下方的自动接入口袋工厂  

- 在源码路径中输入第一步的文件夹路径  

- 输入其他信息，点击确认  

现在，在你的导出选项中可以看到RealPocket插件

## 注意事项  

本插件会自动加载一个autoload。  
如果取消了插件勾选，autoload也会删除，您需要自己添加：  

``` res://addons/autopocketad/FlowerAD.gd ```

您可以查看这个文件，使用其中的函数。
