pipeline {
    agent any

    tools {
        maven 'MAVEN'
        jdk 'JAVA'
    }

    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "https"
        NEXUS_URL = "nexus.wendellsystems.com"
        NEXUS_REPOSITORY = "petclinic-repo"
        NEXUS_CREDENTIAL_ID = "nexus_creds"
        DEV_HOST = "stage.wendellsystems.com"
        REGISTRY_LINK = "docker.wendellsystems.com/repository/docker-test"
        PASSWORD = credentials('password1')

    }


    stages {
        stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '**/tags/**']],
                doGenerateSubmoduleConfigurations: false,
                extensions: [], 
                submoduleCfg: [], 
                userRemoteConfigs: [[credentialsId: '819d712c-9d8d-4eec-97c5-94d217a0ecc4',
                refspec: '+refs/tags/*:refs/remotes/origin/tags/*',
                url: 'https://github.com/SurenGevorgyan/spring-petclinic']]])
            }
        }
        
        stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install'
            }
        }

        stage('Checkstyle') {
            steps {
                sh 'mvn --batch-mode -V -U -e checkstyle:checkstyle pmd:pmd pmd:cpd'
            }

            post {
                always {
                    junit testResults: 'target/surefire-reports/**/*.xml' 

                    recordIssues enabledForFailure: true, tools: [mavenConsole(), java(), javaDoc()]
                    recordIssues enabledForFailure: true, tool: checkStyle()
                    recordIssues enabledForFailure: true, tool: cpd(pattern: '**/target/cpd.xml')
                    recordIssues enabledForFailure: true, tool: pmdParser(pattern: '**/target/pmd.xml')
                }
            }
        }
        
        stage ('Container Build') {
            steps {
                script{
                    latestTag = sh(returnStdout:  true, script: "git tag --sort=-creatordate | head -n 1").trim()
                }
                
                sh """
                    docker build -t dockerspring:${latestTag} .
                    docker tag dockerspring:${latestTag} ${REGISTRY_LINK}
                    docker login -u admin -p ${PASSWORD} ${REGISTRY_LINK}
                    docker push ${REGISTRY_LINK}
                """
            }
        }
    }
}
