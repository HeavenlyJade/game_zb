local UidGenerator = {}

UidGenerator.currentId = 1

function UidGenerator:GenerateUid()
    self.currentId = self.currentId + 1
    return self.currentId
end

return UidGenerator