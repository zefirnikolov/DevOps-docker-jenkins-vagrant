# <p align="center"> DevOps project <p>

The infrastructure is run on Vagrant allowing to be made on Virtual Box. Added Vagrant files and provisions. It uses 2 Virtual Machines - one Jenkins machine, with installed Jenkins. One Docker Machine with installed docker. The jenkins machine is sending pipeline commands and the docker machine is the executor of the commands and creates docker images and containers.

Pipeline - see the Jenkinsfile:
  
 Target: Creating a working Jenkins pipeline which downloads the files from local git server Gitea(as a container. The Gitea is installed with the vagrant provisions files (docker-compose.yml file)). Then starts a testing APP website – web + db part – tests if there is connectivity, if the db is connected correctly and the server is published in the test port and working. All of the app is running on docker containers, started from docker image created from the docker-compose-test.yml file. Then it's closing down the testing app and publishes the images on dockerhub. Then creates a Production website which is published on port 80. The website is running on containers, which are started from the docker-compose-production.yml file. The file downloads the dockerhub images. The pipeline is working correctly, cleaning after it finishes. It can be run continuously, allowing for corrections in the web/db parts of the website which enables immediate changes.



