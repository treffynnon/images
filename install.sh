echo "Installing imagemagick"
sudo apt-get install imagemagick

echo " "
echo "Installing gnu parallel"
sudo apt-get install parallel

echo " "
echo "Installing mozjpeg"
sudo apt-get install build-essential autoconf pkg-config nasm libtool
git clone https://github.com/mozilla/mozjpeg.git
cd mozjpeg
autoreconf -fiv
./configure --with-jpeg8
make
sudo make install

cd -

echo " "
echo "Installing jpeg-archive"
git clone https://github.com/danielgtaylor/jpeg-archive.git
cd jpeg-archive
git checkout 2.1.1
make
sudo make install
