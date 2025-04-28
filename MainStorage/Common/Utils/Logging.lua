local Log = {}

-- 日志等级
Log.LogLevel = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
	CRITICAL = 5
}

-- 当前日志等级，默认为DEBUG
Log.currentLevel = Log.LogLevel.DEBUG
Log.logTag = nil

-- 设置日志等级
function Log:SetLogLevel(level)
    Log.currentLevel = level
end
-- 设置日志标签
function Log:SetLogTag(tag)
    Log.logTag = tag
end

--输出严重错误
function Log:Critical(...)
    local msg = self:FormatString(...)
    self:Print(Log.LogLevel.ERROR,"CRITICAL", msg)
end
--输出错误
function Log:Error(...)
    local msg = self:FormatString(...)
    self:Print(Log.LogLevel.ERROR,"ERROR", msg)
end
--输出警告
function Log:Warn(...)
    local msg = self:FormatString(...)
    self:Print(Log.LogLevel.WARN,"WARN", msg)
end
--输出调试
function Log:Debug(...)
    local msg = self:FormatString(...)
    self:Print(Log.LogLevel.DEBUG,"DEBUG", msg)
end
--输出信息
function Log:Info(...)
    local msg = self:FormatString(...)
    self:Print(Log.LogLevel.INFO,"INFO", msg)
end


--格式化参数字符串
function Log:FormatString(...)
    --获取参数
    local args = {...}
    --获取参数个数
    local argCount = #args
    if argCount > 1 then
        return string.format(...)
    end
    return tostring(args[1])
end

-- 打印日志
function Log:Print(level, levelTag, message)
    if level >= Log.currentLevel then
        --判断message是不是表
        if type(message) == "table" then
            message = MS.Utils.table2str(message)
        end
        if Log.logTag then
            print("["..Log.logTag.."]".."["..levelTag.."] "..message)
        else
            print("["..levelTag.."] "..message)
        end
    end
end

Log.dump = function(tbl, title, ...)
    local func
    func = function(value)
        if type(value) == 'table' then
            local str = '{\n'
            for k, v in pairs(value) do
                str = str .. '[ ' .. k .. ' ]' .. ' = ' .. func(v) .. '\n'
            end
            str = str .. '}\n'
            return str

        else
            return tostring(value)
        end
    end

    if title then
        Log:Print(title, ... or '', func(tbl))
    else
        -- print('DUMP:', func(tbl))
    end
end

return Log
