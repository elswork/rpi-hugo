docker run --name "myHugo" --publish-all \
       --volume $(pwd):/home/pirate/Hugo/Sites/deft.work \
       --volume /tmp/hugo-build-output:/home/pirate/Hugo/Sites/deft.work/public2 \
       elswork/rpi-hugo

docker run -P -v /home/pirate/Hugo/Sites/deft.work:/src elswork/rpi-hugo

docker run -p 1313:1313 -v /home/pirate/Hugo/Sites/deft.work:/src elswork/rpi-hugo server -b http://deft.work/ --bind=0.0.0.0 -w

docker run --rm -v /home/pirate/Hugo/Sites/deft.work:/src elswork/rpi-hugo
---------------Valid
docker run -p 1313:1313 -v $HOME/docker/Hugo/Sites/deft.work:/src elswork/rpi-hugo server -b http://deft.work/ --bind=0.0.0.0 -w

docker run --rm -v $HOME/docker/Hugo/Sites/deft.work:/src --name HugoBuild elswork/rpi-hugo --cleanDestinationDir
