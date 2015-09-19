#!/bin/bash

EC2_INSTANCE=$1
DIST_TAR=/tmp/projectb.tar
DEPLOY_SCRIPT=/tmp/local_script.sh
EC2_HOME=/home/ec2-user

tar cvf ${DIST_TAR} --exclude ./.git  --exclude ./tmp --exclude ./.idea --exclude ./deploy_beta.sh ./

scp -i ~/.ssh/dev-keys.pem ${DIST_TAR} ec2-user@${EC2_INSTANCE}:${DIST_TAR}

cat > ${DEPLOY_SCRIPT} << EOF
#!/bin/bash

sudo service httpd stop

rm -rf ${EC2_HOME}/gradshub-rails.bak
mv ${EC2_HOME}/gradshub-rails ${EC2_HOME}/gradshub-rails.bak
mkdir ${EC2_HOME}/gradshub-rails
tar xvf ${DIST_TAR} -C ${EC2_HOME}/gradshub-rails

cd ${EC2_HOME}/gradshub-rails
${EC2_HOME}/bin/bundle install

echo "gem 'therubyracer', platforms: :ruby" >> Gemfile

${EC2_HOME}/bin/rake assets:precompile
sudo service httpd start
exit

EOF

ssh -i ~/.ssh/dev-keys.pem -t -t ec2-user@${EC2_INSTANCE} 'bash -s' < ${DEPLOY_SCRIPT}