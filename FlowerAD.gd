extends Node

var ad

signal reward_get
signal reward_failed
signal reward_closed
signal reward_skip

func _ready() -> void:
    if ad != null:
        ad.RewardGet.connect(Callable(self, "RewardGet"))
        ad.RewardClosed.connect(Callable(self, "RewardClosed"))
        ad.RewardFailed.connect(Callable(self, "RewardFailed"))
        ad.RewardSkip.connect(Callable(self, "RewardSkip"))
        ad.InitAD.connect(Callable(self, "InitAD"))

func is_android() -> bool:
    if OS.get_name() == "Android" && Engine.has_singleton("RealPocket"):
        return true
    else:
        return false

func InitAD():
    print("广告初始化成功")

func _init() -> void:
    if OS.get_name() == "Android" && Engine.has_singleton("RealPocket"):
        ad = Engine.get_singleton("RealPocket")
    else:
        print("无法初始化广告")

func ShowRewardAD(id:String) -> void:
    if ad != null:
        ad.ShowRewardVideoAd(id)

func RewardSkip():
    if ad != null:
        ad.DisRewardVideoAD()
        reward_skip.emit()

func RewardClosed():
    if ad != null:
        ad.DisRewardVideoAD()
        reward_closed.emit()

func RewardGet():
    if ad != null:
        ad.DisRewardVideoAD()
        reward_get.emit()

func RewardFailed():
    if ad != null:
        ad.DisRewardVideoAD()
        reward_failed.emit()
