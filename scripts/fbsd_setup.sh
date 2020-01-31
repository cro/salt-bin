#!/bin/bash
CWD=`pwd`
PYVER='3.7.6'
PYPRE='3.7'

pkg upgrade
pkg install libffi bzip2 ncurses gdbm gcc sqlite3 readline lzlib libzmq4 ossp-uuid libxml2 libxslt bash curl openssl git openssh-portable vim
curl https://pyenv.run | bash
vim .bashrc
vim .profile
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.6
pyenv virtualenv 3.7.6 juniper
mkdir juniper
cd juniper
pyenv local juniper
source ~/.pyenv/versions/juniper/bin/activate
pip install --upgrade pip pyyaml
pip install -e git+https://github.com/saltstack/pop-build\#egg=pop-build
pop-build
   30  history


curl -LO  https://www.openssl.org/source/openssl-1.1.1d.tar.gz
tar -xvf openssl-1.1.1d.tar.gz

cd openssl-1.1.1d
./config shared --prefix=/usr/local/openssl11 --openssldir=/usr/local/openssl11 && make && make install
cd ..

curl -LO https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tar.xz
tar xvf Python-3.7.6.tar.xz
cd Python-3.7.6
# Edit Modules/Setup.dist
LDFLAGS="-Wl,-rpath=/usr/local/openssl11/lib" ./configure --prefix=/usr/local/python37 --with-openssl=/usr/local/openssl11 --with-system-ffi --enable-shared && make && make install
cd ..

ln -s /usr/local/python37/bin/*3.7* /usr/local/bin
ln -s /usr/local/python37/bin/pip3.7 /usr/local/bin/pip3
export LD_LIBRARY_PATH=/usr/local/python37/lib/:/usr/local/openssl11/lib/
LD_LIBRARY_PATH=/usr/local/python37/lib/:/usr/local/openssl11/lib/ /usr/local/python37/bin/pip3 install staticx
rm -f /usr/local/python37/bin/staticx
ln -s /usr/local/python37/bin/staticx /usr/local/bin/staticx
cd $CWD
LD_LIBRARY_PATH=/usr/local/python37/lib/:/usr/local/openssl11/lib/ /usr/local/python37/bin/python3 build.py -S
