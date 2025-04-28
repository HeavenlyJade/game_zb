local Controller = MS.Class.new("Controller")

function Controller:ctor()
    self.pawn = nil
end
-- Possess the Pawn
function Controller:PossessPawn(pawn)
    self.pawn = pawn
    self.pawn.controller = self
end

return Controller
