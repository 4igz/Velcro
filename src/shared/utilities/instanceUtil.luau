local CollectionService = game:GetService("CollectionService")
local instanceUtil = {}

function instanceUtil.ancestorWithTag(inst: Instance, tagName: string)
	while inst and inst.Parent do
		if CollectionService:HasTag(inst, tagName) then
			return inst
		end
		inst = inst.Parent
		task.wait()
	end
end

return instanceUtil
