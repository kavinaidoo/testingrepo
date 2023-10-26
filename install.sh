# START setting up pmap as a service ****************************************************

echo "\n**** Setting up pmap as a service ****\n"

cd /etc/systemd/system/
curl -O https://raw.githubusercontent.com/kavinaidoo/pmap/dev/pmap.service

systemctl daemon-reload
systemctl enable pmap.service

echo "\n**** Setting up pmap as a service completed ****\n"

# END setting up pmap as a service ****************************************************