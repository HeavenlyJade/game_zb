local NavigationSystem = MS.Class.new("NavigationSystem")

function NavigationSystem:ctor()
end

function NavigationSystem:Init()
end

function NavigationSystem:GenerateNavigationMesh(navMeshInstance)
    local routes = navMeshInstance.Points
    local navEdges = {}
    local navNodes = {}

    -- 遍历routes以填充navNodes
    for _, route in pairs(routes.Children) do
        -- route的类型为 GeoSolid
        navNodes[route.Name] = {bindObject = route}
    end

    -- 遍历routes以填充navEdges
    for _, route1String in pairs(routes.Children) do
        local route1 = navNodes[route1String.Name]
        for _, route2String in pairs(route1String.Children) do
            if route2String.Name == "Capacity" then
                route1.capacity = route2String.Value
            else
                -- route2String的类型为 string
                local route2 = navNodes[route2String.Name]
                local weight = 1
                local transferMode = route2String.Value

                navEdges[route1String.Name .. "-" .. route2String.Name] = {
                    startNode = route1,
                    endNode = route2,
                    weight = weight,
                    transferMode = transferMode
                }
            end
        end
    end

    local navigationMesh = MS.NavigationMesh.new()
    navigationMesh:Init(navNodes, navEdges)

    return navigationMesh
end

-- After Generate Navigation Mesh
function NavigationSystem:FindPath(startNodeName)
    local level = _G.GameMode.levelManager.currentLevel

    local startNode = level.navigationMesh.navNodes[startNodeName]
    local path = level.navigationMesh:CalculatePath(startNode)

    return path
end

return NavigationSystem
