local tossam = require("tossam")
local sig = require("posix.signal")
local svg5=require("svg5")
local svg4=require("svg4")
--[[
	old green: #98bf21
	new blue: #4462ee or #2044FD
	dark blue: #000022
	table grey: #E3E3E3
]]
-- Data Table
data = {}

period = 300 -- 300s = 5 minutos
timeout = 20 -- em segundos
currentPeriod = math.floor(os.time()/period)
hotValue = 26 -- Temperaturas maior que esse valor o texto fica vermelho
coldValue = 20-- Temperaturas menor que esse valor o texto fica azul

-- Log file
logfile = io.open("log.txt","w")
logfile:write("Data/Hora Log, nodeId, Salas, Sequencial, Temperatura, Data/Hora Medição\n")
logfile:close()

Tnodes={
 [1]={offset=-6.4709731, alpha=1.2157834, tp='MTS300B', sala='526'},
 [2]={offset=-1.8704476, alpha=1.0394940, tp='MTS300A', sala='416'},
 [3]={offset=-2.4648532, alpha=1.0592533, tp='MTS300B', sala='518'},
 [4]={offset=-0.9777910, alpha=1.0456438, tp='MTS300B', sala='504'},
 [5]={offset=-1.0969142, alpha=0.9994000, tp='MTS300B', sala='508'}, -- Falta atualizar
 [6]={offset= 0.0762816, alpha=1.0183331, tp='MTS300B', sala='526'}, -- Defeito
 [7]={offset= 0.3239215, alpha=0.9777552, tp='MTS300B', sala='412'},
 [8]={offset= 1.6803904, alpha=0.9375607, tp='MTS300B', sala='513'},
 [9]={offset=-0.5147163, alpha=1.0147521, tp='MTS300B', sala='522'}, -- Desmontado
[10]={offset=-1.2355059, alpha=0.9982581, tp='MTS300B', sala='519'},
[11]={offset=-1.3696423, alpha=1.0199168, tp='MTS300B', sala='515'},

[12]={offset=-6.4709731, alpha=1.2157834, tp='MDA100' , sala='407'},
[13]={offset=-9.4350191, alpha=1.3224915, tp='MDA100' , sala='404a'},
[14]={offset=-6.1977768, alpha=1.1889917, tp='MDA100' , sala='501'},
[15]={offset=-6.3698858, alpha=1.2164728, tp='MDA100' , sala='520'},

[20]={offset=-1.0504827, alpha=1.1037628, tp='DOT' 	  , sala='404b'},
[21]={offset=-3.6330760, alpha=1.1519336, tp='DOT'    , sala='Copa'},





-- Não apagar!! Offset e alpha são especĩficos para cada caixa.
 --[2]={offset=-1.8704476, alpha=1.0394940, tp='MTS300A', sala='526'},
 --[3]={offset=-2.4648532, alpha=1.0592533, tp='MTS300B', sala='501'},
 --[4]={offset=-0.9777910, alpha=1.0456438, tp='MTS300B', sala='504'},
 --[5]={offset=-1.0969142, alpha=0.9994000, tp='MTS300B', sala='508'},
 --[6]={offset= 0.0762816, alpha=1.0183331, tp='MTS300B', sala='513'},
 --[7]={offset= 0.3239215, alpha=0.9777552, tp='MTS300B', sala='515'},
 --[8]={offset= 1.6803904, alpha=0.9375607, tp='MTS300B', sala='517'},
 --[9]={offset=-0.5147163, alpha=1.0147521, tp='MTS300B', sala='528'},
--[10]={offset=-1.2355059, alpha=0.9982581, tp='MTS300B', sala='522'},
--[11]={offset=-1.3696423, alpha=1.0199168, tp='MTS300B', sala='511'},
--[12]={offset=-6.4709731, alpha=1.2157834, tp='MDA100' , sala='404a'},
--[13]={offset=-9.4350191, alpha=1.3224915, tp='MDA100' , sala='404b'},
--[14]={offset=-6.1977768, alpha=1.1889917, tp='MDA100' , sala='407'},
--[15]={offset=-6.3698858, alpha=1.2164728, tp='MDA100' , sala='414'},
--[20]={offset=-1.0504827, alpha=1.1037628, tp='DOT' 	  , sala='Copa'},
--[21]={offset=-3.6330760, alpha=1.1519336, tp='DOT'    , sala='419'},
}

local TsalaAux={}
for i, r in pairs(Tnodes) do table.insert(TsalaAux,{sala=r.sala,node=i}) end
local sort_func = function( a,b ) return a.sala < b.sala end
table.sort(TsalaAux,sort_func)
--for x,y in ipairs(TsalaAux) do print(x,y.sala,y.node,Tnodes[y.node].sala) end


Tsalas = {
 ['501']={nome=" R-501 - Clarisse",		x=328,y=216, andar=5},
 ['502']={nome=" R-502 - Lucena",		x=406,y=216, andar=5},
 ['503']={nome=" R-503 - Markus Endler",x=468,y=216, andar=5},
 ['504']={nome=" R-504 - Noemi",		x=528,y=216, andar=5},
 ['505']={nome=" R-505 - Waldemar",		x=588,y=216, andar=5},
 ['506']={nome=" R-506 - Alessandro",	x=652,y=216, andar=5},
 ['507']={nome=" R-507 - Hugo",			x=709,y=216, andar=5},
 ['508']={nome=" R-508 - Daniel Schwabe",x=786,y=216, andar=5},
 ['510']={nome=" R-510 - Sala de aula",	x=735,y=368, andar=5},
 ['511']={nome=" R-511 - Sala de aula",	x=830,y=324, andar=5},
 ['512']={nome=" R-512 - Sala de aula",	x=830,y=460, andar=5},
 ['513']={nome=" R-513 - Casanova",		x=760,y=460, andar=5},
 ['514']={nome=" R-514 - Julio",		x=680,y=460, andar=5},
 ['515']={nome=" R-515 - Hermann",		x=600,y=460, andar=5},
 ['516']={nome=" R-516 - Marcelo Gattass",x=520,y=460, andar=5},
 ['517']={nome=" R-517 - Ruy",			x=440,y=460, andar=5},
 ['518']={nome=" R-518 - Laber",		x=367,y=460, andar=5},
 ['519']={nome=" R-519 - Ivan Mathias",	x=367,y=368, andar=5},
 ['520']={nome=" R-520 - Apoio Coord.",	x=367,y=324, andar=5},
 ['521']={nome=" R-521 - Pós-Doc",		x=440,y=324, andar=5},
 ['522']={nome=" R-522 - Alunos Pós 1",	x=520,y=324, andar=5},
 ['523']={nome=" R-523 - Alunos Pós 2",	x=600,y=324, andar=5},
 ['524']={nome=" R-524 - ",				x=670,y=324, andar=5},
 ['525']={nome=" R-525 - Alunos Pós 3",	x=670,y=368, andar=5},
 ['526']={nome=" R-526 - Alunos Pós 4",	x=600,y=368, andar=5},
 ['527']={nome=" R-527 - NIT",			x=520,y=368, andar=5},
 ['528']={nome=" R-528 - NIT",			x=440,y=368, andar=5},


 ['404a']={nome=" R-404 - Secret. balcão",	x=390,y=460, andar=4},
 ['404b']={nome=" R-404 - Secretaria",		x=440,y=368, andar=4},
 ['407'] ={nome=" R-407 - Prof.Horistas",	x=316,y=216, andar=4},
 ['408'] ={nome=" R-408 - Hélio Lopes",		x=375,y=216, andar=4},
 ['409'] ={nome=" R-409 - Therezinha",		x=440,y=216, andar=4},
 ['410'] ={nome=" R-410 - Simone",			x=510,y=216, andar=4},
 ['411'] ={nome=" R-411 - Bruno Feijó",		x=570,y=216, andar=4},
 ['412'] ={nome=" R-412 - Sérgio Colcher",	x=632,y=216, andar=4},
 ['413'] ={nome=" R-413 - ",				x=690,y=216, andar=4},
 ['414'] ={nome=" R-414 - Sérgio Lifschitz",x=772,y=216, andar=4},
 ['415'] ={nome=" R-415 - ",				x=832,y=216, andar=4},
 ['416'] ={nome=" R-416 - Thibaut Vidal", 	x=850,y=304, andar=4},
 ['417'] ={nome=" R-417 - Alberto",			x=850,y=368, andar=4},
 ['418'] ={nome=" R-418 - ",				x=832,y=460, andar=4},
 ['419'] ={nome=" R-419 - Furtado",			x=760,y=460, andar=4},
 ['420'] ={nome=" R-420 - Arndt",			x=680,y=460, andar=4},
 ['421'] ={nome=" R-421 - Poggi",			x=600,y=460, andar=4},
 ['422'] ={nome=" R-422 - Roberto",			x=520,y=460, andar=4},
 ['423'] ={nome=" R-423 - Reunião",			x=552,y=324, andar=4},
 ['424'] ={nome=" R-424 - LABPOS",			x=632,y=324, andar=4},
 ['425'] ={nome=" R-425 - Reunião",			x=552,y=368, andar=4},
 ['Copa']={nome=" R-403 - Copa",			x=180,y=368, andar=4},
}

-- Verifica consistência das tabelas
local erro=false
for i,r in pairs(Tnodes) do
	if not Tsalas[r.sala] then
		print("Não achada a sala '".. (r.sala or "") .. "' na tabela TSalas")
		erro=true
	end
end
if erro then return end

function convertDA(ADC,tipo,mote)
	
	local Temp = 0
	if tipo == "MDA100" then
		a = 0.001010024
		b = 0.000242127
		c = 0.000000146
		R1 = 10000
		ADC_FS = 1023
		Rthr = (R1 * (ADC_FS - ADC)) / ADC
		Temp = (1 / (a + (b * math.log(Rthr)) + (c * math.pow(math.log(Rthr),3.0)))) - 273.15
	elseif tipo == "DOT" then
		a = 0.00130705
		b = 0.000214381
		c = 0.000000093
		R1 = 10000
		ADC_FS = 1023
		Rthr = (R1 * (ADC_FS - (ADC_FS - ADC))) / (ADC_FS - ADC)
		Temp = (1 / (a + (b * math.log(Rthr)) + (c * math.pow(math.log(Rthr),3.0)))) - 273.15
	else
		a = 0.00130705
		b = 0.000214381
		c = 0.000000093
		R1 = 10000
		ADC_FS = 1023
		Rthr = (R1 * (ADC_FS - ADC)) / ADC
		Temp = (1 / (a + (b * math.log(Rthr)) + (c * math.pow(math.log(Rthr),3.0)))) - 273.15
	end	
	return Tnodes[mote].offset + (Temp * Tnodes[mote].alpha)
	
end

function round5(num)
	return num
end
function round5x(num)
	num = num + 0.25
	fnum = math.floor(num)
	if (num - fnum) >= 0.5 then
		return fnum + 0.5
	else
		return fnum
	end
end

function fText(str,tam)
	local tmp = str .. string.rep(" ",tam)
	return string.sub(tmp,1,tam)
end

function fTextColor(value,tam,gray)
	local tmp = value .. string.rep(" ",tam)
	tmp = string.sub(tmp,1,tam)
	local fVal = tonumber(value)
	local color = (gray and 'gray') or (((fVal > hotValue) and 'red') or ((fVal < coldValue) and 'blue') or 'black')
	return "<font style='color: ".. color .. ";'>" .. tmp .. "</font>"
end
function getColor(value,gray)
	local fVal = tonumber(value)
	local color = (gray and 'gray') or (((fVal > hotValue) and 'red') or ((fVal < coldValue) and 'blue') or 'black') 
	return color
end

function geraLog()
	logfile = io.open("log.txt","a")
	local logDate = os.date("%d/%m/%y %X")
	for i=2,30 do
		if data[i] and Tnodes[data[i].nodeId] then
			logfile:write(logDate ..', '.. data[i].nodeId ..', '..  (Tsalas[Tnodes[data[i].nodeId].sala].nome or "Não cadastrado") ..', '.. data[i].seq ..', '.. data[i].TempC ..', '.. data[i].date ..'\n')
		end
	end
	logfile:close()
end


function geraArq()
	local dateStr = os.date("%d-%m-%Y %H:%M:%S") 
	local timeSec = os.time()
	-- DATA FILE
	file = io.open("index.html","w+")
	file:write("<html>\n\n<head>\n<meta charset='UTF-8'>\n<meta http-equiv='refresh' content='120'>\n")
	file:write("<style>body{font-family: Helvetica Neue,Helvetica,Arial,sans-serif;background-color: #000022;}\ntable, td, th {text-align: center;}table {width: 80%;max-width: 800px;}\nh4{text-align:center;font-size:115%;}\nth{background-color: #4462ee;color: #ffffff;height: 25px;}\ntd{background-color: #E3E3E3;}\n#logopuc{float:left;}\n#logodi{float:right;}\n#header{margin-left: auto; margin-right: auto; text-align: center; max-width: 800px; width: 80%}\n#htd{background-color: #ffffff;}\n#all{margin-left: auto; margin-right: auto; background-color: #ffffff; width: 80%;max-width: 900px;}\n</style>\n<title> RSSF | PUC-Rio </title>\n</head>\n\n<body onload='checkOld()'>\n<div id='all'>\n<table id='header'>\n<tr>\n<td id='htd'>  <div id='logopuc'> <img src='brasao.jpg' alt='PUC-Rio'>  </div> </td>\n<td id='htd'> <div id='mtext'> <h4>PUC-Rio -- Departamento de Informática </h4><h4>  " .. dateStr ..   " </h4>  </div> </td>\n<td id='htd'> <div id='logodi'> <img src='logo_di1.jpg' alt='DI'  height='120'> </div> </td>\n</tr>\n</table>\n<p id='timeSec' hidden >".. timeSec .."</p>\n<p id='aviso' style='color:red; text-align:center;'></p>\n<table align='center'>")
	file:write("<tr><th>" .. fText("LOCAL",25).."</th><th>"..fText("TEMP(ºC)",15).."</th><th>"..fText(" DATA/HORA",17).."</th></tr>")
	for x,r in ipairs(TsalaAux) do
		local i = r.node
		local trStyle = ""
		if data[i] and Tnodes[data[i].nodeId]  then
			trStyle=((os.difftime(os.time(),data[i].time) > 610) and "style='color:gray'") or ""
			file:write("<tr ".. trStyle .."><td style='text-align: left'>" .. fText(((data[i] and Tsalas[Tnodes[data[i].nodeId].sala].nome) or 'Mote ' .. i .. ' não cadastrado'),30).. "</td><td>" .. fTextColor(data[i].TempC,15,(os.difftime(os.time(),data[i].time) > 610)) .. "</td><td>" .. fText(data[i].date,17).."</td></tr>")
		end
	end
	file:write("</table>")
	file:write("<p></p>")
	file:write(svg5)
	for i=1,30 do
		if data[i] and Tnodes[data[i].nodeId]  then
			if Tsalas[Tnodes[data[i].nodeId].sala].andar == 5 then
			  file:write("<text font-size='16.9785' style='fill: ".. getColor(data[i].TempC,(os.difftime(os.time(),data[i].time) > 610)) ..";text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:700' x='".. Tsalas[Tnodes[data[i].nodeId].sala].x .."' y='".. Tsalas[Tnodes[data[i].nodeId].sala].y .."'> <tspan x='".. Tsalas[Tnodes[data[i].nodeId].sala].x .."' y='".. Tsalas[Tnodes[data[i].nodeId].sala].y .."'>" .. data[i].TempC .. "⁰</tspan></text>\n")
			end

		end
	end
	file:write("</svg>")

 -- *** Descomentar para adicionar o 4o andar ****
	file:write("<p></p>")
	file:write(svg4)
	for i=1,30 do
		if data[i] and Tnodes[data[i].nodeId]  then
			if Tsalas[Tnodes[data[i].nodeId].sala].andar == 4 then
			  file:write("<text font-size='16.9785' style='fill: ".. getColor(data[i].TempC,(os.difftime(os.time(),data[i].time) > 610)) ..";text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:700' x='".. Tsalas[Tnodes[data[i].nodeId].sala].x .."' y='".. Tsalas[Tnodes[data[i].nodeId].sala].y .."'> <tspan x='".. Tsalas[Tnodes[data[i].nodeId].sala].x .."' y='".. Tsalas[Tnodes[data[i].nodeId].sala].y .."'>" .. data[i].TempC .. "⁰</tspan></text>")
			end

		end
	end
	file:write("</svg>")

	file:write("</div></body>")
	file:write("\n<script>\nfunction checkOld(){\n diff = (new Date().getTime()) - (document.getElementById('timeSec').innerHTML * 1000);\n document.getElementById('aviso').innerHTML= ((diff > (".. (period * 3) .."*1000)) && 'Atenção: Valores desatualizados!') || ''}\n</script>\n")
	file:write("</html>")
	file:close()
	os.execute("./transfer")
	--os.execute("./transfer.exp")
end

function checaPeriodo()
	testPeriod = math.floor(os.time()/period)
	if testPeriod > currentPeriod then
		geraArq()
		geraLog()
		currentPeriod = testPeriod
	end
end

function handler()
	print("\nbye bye\n")	
	os.exit()
end

sig.signal(sig.SIGINT,handler)
sig.signal(sig.SIGTERM,handler)

SERIAL=true
--SERIAL=false
while (1) do	
local conn, err
	
	if SERIAL then
		conn, err = tossam.connect {
		  protocol = "serial",
		  port     = "/dev/ttyUSB1",
		  baud     = "mica2",
		  nodeid   = 1
		}
	else
		conn,err = tossam.connect {
		  protocol = "sf",
		  host     = "localhost",
		  port     = 9002,
		  nodeid   = 1
		}
	end
	if not(conn) then 
		print("Connection error!:: ".. (err or '-')) 
	else

		conn:settimeout(timeout)


		conn:register [[ 
		  nx_struct msg_serial [145] { 
			nx_uint8_t  id;
			nx_uint16_t	nodeId;
			nx_uint16_t	target;
			nx_uint8_t  seq;
			nx_uint8_t  node_id;
			nx_uint8_t  retries;
			nx_uint8_t  xxx3;
			nx_uint16_t	temp;
			nx_uint16_t	volt;
			nx_uint16_t yyy[2];
		  }; 
		]]

		print("msgID","nodeID","Sala                ","A/D","seq","Retries","temp","date")
	--	file:write("nodeID\ttemp\t\tdate\n")
		while (conn) do

			local stat, msg, emsg = pcall(function() return conn:receive() end) 
			if stat then
				if msg and msg.id == 1 then
					local date = os.date("%d/%m/%y %X")
					local time = os.time()
					local TempC
					if Tnodes[msg.nodeId] then
						TempC = convertDA(msg.temp,Tnodes[msg.nodeId].tp,msg.nodeId)
					else
						TempC = 0--"---"
					end
					data[msg.nodeId] = {nodeId = msg.nodeId, seq=msg.seq, TempC=string.format("%.1f", round5(TempC)), date=date, time=time}
					checaPeriodo()
					nome = ((Tnodes[msg.nodeId] and Tsalas[Tnodes[msg.nodeId].sala].nome) or '-')
					nome = nome .. string.rep(" ", 22 - nome:len())
					print(msg.id,msg.nodeId,nome,msg.temp,msg.seq,msg.retries,string.format("%.1f", round5(TempC)),date)
					--file:write(msg.nodeId,"\t\t" .. string.format("%.1f", round5(TempC)),"\t\t" .. date,"\n")
				else
					if emsg == "closed" then
						print("\nConnection closed!")
						break 
					elseif emsg == "timeout" then
						checaPeriodo()
						--print(".") --print("timeout")			
					end
				end
			else
				print("\nreceive() got an error:"..msg)
				exit = true
				break
			end
		end
		
		conn:unregister()
		conn:close()
	end
	
	os.execute("sleep " .. 5)
end
