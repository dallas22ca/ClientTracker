# For setup on new server:

## ON REMOTE MACHINE

### ADD USER
* ssh into server
* adduser deployer
* adduser deployer sudo
* exit

## ON LOCAL MACHINE

### DEPLOY
* Put new ip into deploy.rb file.
* cap deploy:install (May takes more than 10 minutes. if forever, just Ctrl + C and run again.)
* cap deploy:setup
* cap deploy:cold # BUNDLE MAY HANG, IF SO RUN AGAIN
* cap db:seed
* cat ~/.ssh/id_rsa.pub | ssh deployer@107.170.24.138 'cat >> ~/.ssh/authorized_keys'
* ssh-add -K
* if ctrl+c doesn't stop server: ps aux | grep rails | awk '{print $2}' |  xargs kill -9