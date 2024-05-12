pipeline {
    agent: any
    enviroment:
        new_version = "1.3.0"
        server_credential = credential("credential_name")
    stages {
        stage("Test") {
            step{
                echo "building ${server_credential}"
            }
        }
    }
}

pipeline {
    agent { 
        node {
            label 'docker-agent-python'
            }
      }
    triggers {
        pollSCM '* * * * *'
    }
    stages {
        stage('Build') {
            steps {
                echo "Building.."
                sh '''
                cd myapp
                pip install -r requirements.txt
                '''
            }
        }
        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                cd myapp
                python3 hello.py
                python3 hello.py --name=Brad
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo "doing delivery stuff.."
                '''
            }
        }
    }
}


pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                echo 'Hello World build'
            }
        }
        stage('test parallel') {
            parallel {
                stage('test-linux') {
                    steps {
                        echo 'Hello World linux'
                    }
                }
                stage('test-windows') {
                    steps {
                        echo 'Hello World windows'
                    }
                }
            }
        }
        stage('Approve based on environment lead') {
	            input {
	                message 'Please select environment'
	                id 'envId'
	                ok 'Submit'
	                submitterParameter 'approverId'
	                parameters {
	                    choice choices: ['Prod', 'Pre-Prod'], name: 'envType'
	                }
	            }

	            steps {
	                echo "Deployment approved to ${envType} by ${approverId}."

	            }
	        }
        stage('deploy with input approval') {
            steps {
                echo 'Hello World deploy'
                // Create an Approval Button with a timeout of 15minutes.
	            timeout(time: 15, unit: "MINUTES") {
	            input message: 'Do you want to approve the deployment?', ok: 'Yes'
	            }
			
	            echo "Initiating deployment"
            }
        }
    }
}


