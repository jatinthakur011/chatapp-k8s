pipeline {

    agent any

    environment {

        AWS_ACCOUNT_ID = "730972070019"
        AWS_REGION = "eu-north-1"

        ECR_REPO = "chatapp"

        IMAGE_TAG = "${BUILD_NUMBER}"

        IMAGE_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {

            steps {

                checkout scm

            }

        }

        stage('Docker Build') {

            steps {

                sh '''
                docker build -t chatapp:${BUILD_NUMBER} .
                '''
            }

        }

        stage('Login ECR') {

            steps {

                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS \
                --password-stdin \
                ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }

        }

        stage('Push ECR') {

            steps {

                sh '''
                docker tag chatapp:${BUILD_NUMBER} ${IMAGE_URI}

                docker push ${IMAGE_URI}
                '''
            }

        }

        stage('Deploy EKS') {

            steps {

                sh '''
                kubectl set image deployment/django \
                django=${IMAGE_URI} \
                -n chatapp

                kubectl rollout status deployment/django -n chatapp
                '''
            }

        }

    }

}
