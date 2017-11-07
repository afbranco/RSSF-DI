# Installation procedure
This installation procedure was tested in a fresh installation of Ubuntu 16.04 server. 
This assumes that the HTML page will be transferred/copied to another machine that serves the web.

**Note:** *This procedure assumes the web server machine as `obaluae.inf.puc-rio.br`. 
Please, adjust the remote user and machine according to your project needs.*

## Steps summary:
1. Install Lua 5.1 & LuaRocks
2. Install TOSSAM
   - May need to fix some depencies versions
3. Install luaposix
4. Dowload source files
5. Configure USB access
6. Configure SSH autologin
7. Download files in the web server machine
8. Execution

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
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/receiveData.lua
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/svg4.lua
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/svg5.lua
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/transfer

chmod +x transfer
```

## Configure USB access
```
sudo usermod -a -G dialout $USER
```

## Configure SSH autologin
Execute `ssh-keygen` with default values and then copy the key executing `ssh-copy-id`.
You may test the login executing `ssh`. Do not forget to exit the login terminal to continue the installation.
```
cd ~
ssh-keygen
ssh-copy-id rssf@obaluae.inf.puc-rio.br
```

## Download files in the web server machine
```
ssh rssf@obaluae.inf.puc-rio.br
mkdir public_html
cd public_html
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/brasao.jpg
wget https://raw.githubusercontent.com/afbranco/RSSF-DI/master/logo_di1.jpg
exit
```

## Application execution
Inside `rssf_DI` directory, execute:
```
cd ~/rssf_DI
lua receiveData.lua
```


