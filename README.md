This is public repository of site http://maxsvargal.com

Site does't need backend for work, but for build sources you need Node.js and Ruby.

# Building

### You shouid install Node.js
Debian 
```sh
sudo apt-get install node
```

Os X
Use [homebrew](https://github.com/mxcl/homebrew)
```sh
brew install node
```

## Install Ruby

Debian 
```sh
sudo apt-get install ruby
```
Os X
Use [homebrew](https://github.com/mxcl/homebrew)
```sh
brew install ruby
```


### Install sass and compass with gem
```sh
gem install compass
```

### Install Grunt globally:
```sh
npm install -g grunt
```



## Get source code and change into the directory.

### Install npm modules:
```sh
npm install
```

### Build sources
```sh
grunt
```
Server started on localhost:9000
