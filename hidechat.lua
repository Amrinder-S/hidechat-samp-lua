script_author('AMR')
script_name('ChatID')
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'


local hidden = inicfg.load ({
  words = { "test1","test2" }
  
}, 'hiddenchat.ini')



local hidechat = false
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(1)
    end
    while sampGetGamestate() < 3 do
        wait(1)
    end
		sampRegisterChatCommand(
        'hidechat',
        function()
            hidechat = not hidechat
            sampAddChatMessage(hidechat and 'Chat hidden' or 'Chat shown', -1)
        end)
		
		sampRegisterChatCommand('add.new', function(add)
		local word = tostring(add)
		word = esc(word)
        if #word > 0 then 
            table.insert(hidden.words, tostring(word))
            if inicfg.save(hidden, 'hiddenchat.ini') then
                sampAddChatMessage('[HideChat] "'..tostring(word)..'" will now be hidden', 0xAFAFAF)
            end
        else
            sampAddChatMessage('[HideChat] /add [word / sentence] (For example: [Helpers])', 0xAFAFAF)
        end
    end)

    wait(-1)
end

function sampev.onServerMessage(color, text)
	if hidechat then
	local toChange = false
	for k, v in pairs(hidden.words) do
			if string.find(text, v) then
			file = io.open('moonloader/hiddenchat.txt', "a")
			file:write("\n"..text)
			file:close()
			toChange = true
			end
		end
			if toChange then
            return false
        end
		end
	end
	
function esc(s)
  return (s:gsub('[%^%$%(%)%%%.%[%]%*%+%-%?]','%%%1'))
end

