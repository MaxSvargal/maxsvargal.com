This is public repository of site http://maxsvargal.com

Site doesn't need backend for work, but for build sources you need Node.js and Ruby.

## Building
You shouid install Node.js

Debian 
```sh
sudo apt-get install node
```
Os X

Use [homebrew](https://github.com/mxcl/homebrew)
```sh
brew install node
```


And ruby

Debian 
```sh
sudo apt-get install ruby
```
Os X
```sh
brew install ruby
```


Install sass and compass with Ruby gem
```sh
gem install compass
```

Get source code and change into the directory.
Install npm modules:
```sh
npm install
```


Build sources
```sh
grunt
```
Server started on localhost:9000
