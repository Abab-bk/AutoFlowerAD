@tool
extends Control

@onready var start_btn: Button = $Panel/HBox/Margin/VBox/Start
@onready var sdk_node: LineEdit = $Panel/HBox/Margin/VBox/SDKPath
@onready var app_id_node:LineEdit = $Panel/HBox/Margin/VBox/AppID
@onready var path_node:LineEdit = $Panel/HBox/Margin/VBox/Path

@onready var log_node: Label = $Panel/HBox/Margin2/VBox/Scroll/log

var log:String = ""
var source_path:String

func push_log(context:String) -> void:
    log += "\n" + context
    log_node.text = log

func _ready() -> void:
    start_btn.pressed.connect(self.start)

func start() -> void:
    print("start")
    log = ""
    push_log("开始接入")
    # 检测有没有输入源码路径
    
    if sdk_node.text == "":
        push_log("请输入源码路径")
        return
    source_path = sdk_node.text
    
    print(source_path)
    source_path = source_path.replace("\\", "/")
    
    
    var source_file = DirAccess.open(source_path)
    push_log("源码路径：" + source_path)
    push_log("源码路径已写入")
    
    # 写入信息
    var file_appid = FileAccess.open(source_path + "/FlowerAD/AppID.txt", FileAccess.WRITE)
    if app_id_node.text == "":
        push_log("请输入APP ID")
        return
    file_appid.store_string(app_id_node.text)
    file_appid.close()
    push_log("AppID已写入")
    
    var file_path = FileAccess.open(source_path + "/FlowerAD/Path.txt", FileAccess.WRITE)
    if path_node.text == "":
        push_log("请输入渠道")
        return
    file_path.store_string(path_node.text)
    file_path.close()
    push_log("渠道已写入")
    
    # 检测有没有依赖文件
    var libs_file = DirAccess.open(source_path + "/FlowerAD/libs")
    
    if libs_file.file_exists("godot-lib_release.aar"):
        libs_file.remove("godot-lib_release.aar")
        
    if not libs_file.file_exists("csj_ad_sdk_230215.aar"):
        push_log("csj_ad_sdk_230215.aar 不存在！，请检查源码文件夹")
        return
    
    libs_file.copy(source_path + "/FlowerAD/libs/csj_ad_sdk_230215.aar", "res://android/plugins/csj_ad_sdk_230215.aar")
    push_log("复制csj_ad_sdk_230215.aar成功！")
    
    if not libs_file.file_exists("gdt_ad_sdk_230210.aar"):
        push_log("gdt_ad_sdk_230210.aar 不存在！，请检查源码文件夹")
        return

    libs_file.copy(source_path + "/FlowerAD/libs/gdt_ad_sdk_230210.aar", "res://android/plugins/gdt_ad_sdk_230210.aar")
    push_log("复制gdt_ad_sdk_230210.aar成功！")

    if not libs_file.file_exists("ks_ad_sdk_230116.aar"):
        push_log("ks_ad_sdk_230116.aar 不存在！，请检查源码文件夹")
        return
        
    libs_file.copy(source_path + "/FlowerAD/libs/ks_ad_sdk_230116.aar", "res://android/plugins/ks_ad_sdk_230116.aar")
    push_log("复制ks_ad_sdk_230116.aar成功！")
        
    if not libs_file.file_exists("pocket_ad_sdk_3.2.8.aar"):
        push_log("pocket_ad_sdk_3.2.8.aar 不存在！，请检查源码文件夹")
        return
    
    libs_file.copy(source_path + "/FlowerAD/libs/pocket_ad_sdk_3.2.8.aar", "res://android/plugins/pocket_ad_sdk_3.2.8.aar")
    push_log("复制pocket_ad_sdk_3.2.8.aar成功！")
    
    var tem_file = DirAccess.open("res://android/build/libs/release")
    
    if not tem_file.file_exists("godot-lib.template_release.aar"):
        push_log("Android文件夹不存在依赖！")
        return
    
    push_log("依赖文件存在")
       
    if FileAccess.file_exists(source_path + "/FlowerAD/libs/godot-lib_release.aar"):
        var temp_ = DirAccess.open("FlowerAD/libs")
        temp_.remove("FlowerAD/libs/godot-lib_release.aar")
    else:
        push_log("文件已移除")
    
    var lib_file = DirAccess.open("res://android/build/libs/release")
    if lib_file.file_exists("res://android/build/libs/release/godot-lib.template_release.aar"):
        lib_file.copy("res://android/build/libs/release/godot-lib.template_release.aar", source_path + "/FlowerAD/libs/godot-lib.template_release.aar")
        push_log("复制lib文件到源码文件夹完毕") 
        lib_file.change_dir(source_path + "/FlowerAD/libs")
        lib_file.rename(source_path + "/FlowerAD/libs/godot-lib.template_release.aar", source_path + "/FlowerAD/libs/godot-lib_release.aar")
        push_log("重命名lib文件完毕") 
    else:
        push_log("找不到安卓源码目录下的lib文件！")
        return
    
    # build
    var temp:String = "cd " + source_path + " && .\\gradlew build"
#    var temp:String = "cd " + source_path + " && python build.py"
    print(temp)
    
    push_log("build中，请耐心等待。")
    var exe = Thread.new()
    
    exe.start(func():
        OS.execute("CMD.exe", ["/C", temp]))
    exe.wait_to_finish()
    push_log("build完成")
    
    var copy_file1 = DirAccess.open(source_path + "/FlowerAD/build/outputs/aar/")
    print(copy_file1.get_open_error())
    if copy_file1.file_exists("FlowerAD-release.aar"):
        push_log("aar文件存在，尝试复制到plugins")
        var err = copy_file1.copy(source_path + "/FlowerAD/build/outputs/aar/FlowerAD-release.aar", "res://android/plugins/FlowerAD-release.aar")
        if err == OK:
            push_log("复制aar文件完毕")
        else:
            push_log("复制失败！错误码：  " + str(err))
            return
    else:
        push_log("找不到build生成的aar文件！")
        return

    var copy_file2 = DirAccess.open(source_path)

    if copy_file2.file_exists(source_path + "/FlowerAD-release.gdap"):
        push_log("gdap文件存在，尝试复制到plugins")
        copy_file2.copy(source_path + "/FlowerAD-release.gdap", "res://android/plugins/FlowerAD-release.gdap")
        push_log("复制gdap文件完毕")
    else:
        push_log("找不到gdap文件！")
        return
    
    push_log("接入成功！")
