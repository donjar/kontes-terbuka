GECKODRIVER_VERSION=v0.11.1

export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
sleep 3

wget https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
tar -xf geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
mv geckodriver ~/.rvm/gems/ruby-2.3.3/bin
