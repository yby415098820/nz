local DialogConfigs = class("DialogConfigs", cc.mvc.ModelBase)

local configs = {}

configs[1]  = {
	1 = {
		forward = {
			{role = "萝莉", msg = "根据可靠的情报，这个仓库里有敌人很重要导弹发射装置和大量的军火。", pos = "right"},
			{role = "夜玫瑰", msg = "杰，在支援没到之前你需要只身前往那里，一定要拖住敌人，为支援争取时间。", pos = "right"},
			{role = "杰", msg = "了解，任务开始！", pos = "left"},
			{role = "鬼眼", msg = "很好，不要辱没了我们龙组的威名！", pos = "right"},
		},
	},
	2 = {
		forward = {
			{role = "杰", msg = "成功抵达位置，但是敌人有埋伏。我们被包围了。", pos = "left"},
			{role = "萝莉", msg = "队长，敌人越来越多了，申请动用“黄金武器”！", pos = "right"},
			{role = "鬼眼", msg = "。。。。。。申请许可，全员立刻换装黄金武器！", pos = "right"},
			{role = "杰", msg = "哈哈!黄金武器，这个给力！老虎不发威你当我是哈喽kitty！", pos = "left"},
		},	
	},
	3 = {
		forward = {
			{role = "夜玫瑰", msg = "隐藏能源核心的金库被袭击！请求支援！请求支援！", pos = "right"},
			{role = "鬼眼", msg = "。。。。。。中了调虎离山的计了！行动组火速回援", pos = "right"},
			{role = "萝莉", msg = "收到！", pos = "right"},
			{role = "杰", msg = "收到！", pos = "left"},
		},
	},
	4 = {
		forward = {
			{role = "鬼眼", msg = "将敌人抵挡在基地外", pos = "right"},
			{role = "夜玫瑰", msg = "杰，占据有利地势，秒杀他们！",pos = "right"},
			{role = "杰", msg = "ok 已经抵达位置", pos = "left"},
		},
	},
	5 = {
		forward = {
			{role = "夜玫瑰", msg = "啊！竟然是你，鬼眼！",pos = "right"},
			{role = "鬼眼", msg = "呵呵，被发现也好，省的我费事了，都把命留下吧！", pos = "right"},
		},
		after = {
			{role = "杰", msg = "我哥哥是不是你害死的？",  pos = "left"},
			{role = "鬼眼", msg = "你哥哥不识好歹，想见他还不容易，我来帮你一把。哈哈",  pos = "right"},
			{role = "萝莉", msg = "杰，敌人援兵到了，快撤退",  pos = "right"},
		},
	},
}

function DialogConfigs.getConfig(groupId,levelId,appear)
	assert(configs[groupId][levelId] , "configs is nil groupId: "..groupId )
	return configs[groupId][levelId][appear]
end

return DialogConfigs