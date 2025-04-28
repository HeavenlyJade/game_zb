local NavigationNode = MS.Class.new("NavigationNode")
local NavigationEdge = MS.Class.new("NavigationEdge")

function NavigationNode:ctor(bindObject)
    self.bindObject = bindObject
    self.capacity = 0
end

function NavigationEdge:ctor(startNode, endNode, weight, transferMode)
    self.startNode = startNode
    self.endNode = endNode
    self.weight = weight
    self.transferMode = transferMode
end

local NavigationMesh = MS.Class.new("NavigationMesh")

function NavigationMesh:ctor()
    self.navNodes = {}
    self.navEdges = {}
    self.navNodesCount = {}
end

function NavigationMesh:Init(navNodes, navEdges)
    self.navNodes = navNodes
    self.navEdges = navEdges

    for _, node in pairs(navNodes) do
        self.navNodesCount[node.bindObject.Name] = 0
    end
end

function NavigationMesh:CalculatePath(startNode)
    local path = {}
    local currentNode = startNode

    while currentNode do
        table.insert(path, currentNode)

        -- 获取当前节点的所有边
        local edges = {}
        for _, edge in pairs(self.navEdges) do
            if edge.startNode == currentNode then
                table.insert(edges, edge)
            end
        end

        if #edges == 0 then
            break
        end

        -- 计算总权重
        local totalWeight = 0
        for _, edge in ipairs(edges) do
            totalWeight = totalWeight + edge.weight
        end

        -- 生成一个随机数来选择下一个节点
        local randomWeight = math.random() * totalWeight
        local cumulativeWeight = 0
        for _, edge in ipairs(edges) do
            cumulativeWeight = cumulativeWeight + edge.weight
            if randomWeight <= cumulativeWeight then
                currentNode = edge.endNode
                break
            end
        end
    end
    return path
end

return NavigationMesh
