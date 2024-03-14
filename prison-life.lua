-- Behaves similarly to the shared function of _G/shared, but is more secure and private so even if users
-- gain access to private plugins, they cannot interface with the internal functions.
local GetSecureEnvironment--!GetSecureEnvironment
local AuthToken = "null"; do
	AuthToken = GetSecureEnvironment()["game-info/auth-token"] or AuthToken
end

local success, result = pcall(function()
	return GetSecureEnvironment()["gethttp"]("https://api.github.com/repos/veilict/game-info/prison-life.lua", AuthToken)
end)

if (success) then
	if (typeof(result) == "table") then
		local Success = result.Success
		local StatusMessage = result.StatusMessage
		local Body = result.Body
		if (typeof(Success) == "boolean") then
			if (Success) then
				if (typeof(Body) == "string") then
					return loadstring(Body)()
				else
					error("An error occured while loading: Http body was not of type string", -1)
				end
			else
				error(`An error occured while loading: {tostring(StatusMessage)}`, -1)
			end
		else
			error("An error occured while loading: Http success was not of type boolean", -1)
		end
	else
		error("An error occured while loading: Http result was not of type dictionary", -1)
	end
else
	error(`An error occured while loading: {tostring(result)}`, -1)
end
