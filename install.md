# Installation procedure
This installation procedure was tested in a fresh installation of Ubuntu 16.04 server. 
This assumes that the HTML page will be transfered/copied to another machine that serves the web.

## This procedure will explain next items:
1. Install Lua 5.1 & LuaRocks
2. Install TOSSAM
   - May need to fix some depencies versions
3. Install luaposix
4. Dowload source files
5. Configure USB access
6. Configure SSH autologin
7. Execution

## Install Lua & LuaRocks
```
sudo apt-get install lua5.1
sudo apt-get install luarocks 
```

## Install TOSSAM
[TOSSAM](http://www.inf.ufg.br/~brunoos/tossam/) is a Lua support for TinyOS Active Message protocol.

1. Download `tossam-0.2-1.rockspec` file
```
cd ~
wget http://www.inf.ufg.br/~brunoos/tossam/download/tossam-0.2-1.rockspec
```

2. Update the rockspec file with a more recent luars232 version
```
sed -1 's/luars232  == 1.0.3-1/luars232  == 1.0.3-3/g' tossam-0.2-1.rockspec
```

3. Execute the TOSSAM installation
```
sudo luarocks install tossam-0.2-1.rockspec
```

## Install Lua Posix
```
sudo luarocks install luaposix
```

## Download source files
```
cd ~
mkdir rssf_DI
cd rssf_DI
wget 
```



