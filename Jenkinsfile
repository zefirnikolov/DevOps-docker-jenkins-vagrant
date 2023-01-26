pipeline 
{
    agent 
    {
        label 'docker-node'
    }
    environment 
    {
        DOCKERHUB_CREDENTIALS=credentials('hub-docker')
    }
    stages
    {
        stage('Clone')
        {
            steps 
            {
                git branch: 'main', url: 'http://192.168.99.102:3000/douser/demodevopsapp.git'
            }
        }
        stage('Make a Volume')
        {
            steps
            {
                sh 'cd'
                sh 'rm -R /home/jenkins/BGApp-Pipeline || true'
                sh 'cp -R /home/jenkins/workspace/BGApp-Pipeline /home/jenkins'
                sh 'cd /home/jenkins/BGApp-Pipeline'
            }
        }
        stage('Run')
        {
            steps
            {
                sh 'docker compose -f docker-compose-test.yml down || true'
                sh 'docker compose -f docker-compose-test.yml up -d'
            }
        }
        stage('Test')
        {
            steps
            {
                script 
                {
                    echo 'Test #1 - reachability' 
                    sh 'echo $(curl --write-out "%{http_code}" --silent --output /dev/null http://192.168.99.102:8080) | grep 200'
                  
                }
            }
        }
        stage('Test 2')
        {
            steps
            {
                sh 'sleep 10'
                echo 'Test #2 - database reachability'
                sh 'curl -s http://192.168.99.102:8080 | grep Пловдив'
            }
        }
        stage('CleanUp')
        {
            steps
            {
                sh 'docker compose -f docker-compose-test.yml down || true'
                sh 'sleep 2'
                sh 'rm -R /home/jenkins/BGApp-Pipeline || true'
            }
        }
        stage('Login') 
        {
            steps 
            {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push') 
        {
            steps 
            {
                sh 'docker image tag bgapp-pipeline-web zefirnikolov/web-pipeline'
                sh 'docker image tag bgapp-pipeline-db zefirnikolov/db-pipeline'
                sh 'docker push zefirnikolov/web-pipeline'
                sh 'docker push zefirnikolov/db-pipeline'
            }
        }
        stage('Make a Production Volume')
        {
            steps
            {
                sh 'cd'
                sh 'rm -R /home/jenkins/BGApp-Pipeline || true'
                sh 'cp -R /home/jenkins/workspace/BGApp-Pipeline /home/jenkins'
                sh 'cd /home/jenkins/BGApp-Pipeline'
            }
        }
        stage('Run Production')
        {
            steps
            {
                sh 'docker compose -f docker-compose-production.yml down || true'
                sh 'docker compose -f docker-compose-production.yml up -d'
            }
        }
    }
    post
    { 
        always 
        { 
            cleanWs()
        }
    }
}