
# Getting Started with DevOps
# บทที่ 1 : Introduction to Docker, Docker-compose and mircoservice

## สร้าง Application สำหรับ Frontend
ทำการลง nodejs version 20 ขึ้นไป
## Anguler For Front-End
1. Install Lib Anguler
```
npm install -g @angular/cli
```
2. Create Project
```
ng new website
```
3. run Project
```
ng serve
```

## NextJs For Front-End
1. Create Project
```
npx create-next-app@latest
```
```
What is your project named?...user-console
Would you like to use TypeScript? No / Yes
Would you like to use ESLint? No / Yes
Would you like to use Tailwind CSS? No / Yes
Would you like to use `src/` directory? No / Yes
Would you like to use App Router? (recommended) No / Yes
Would you like to customize the default import alias? No / Yes
```
```
cd user-console
yarn dev
```

## สร้าง Application สำหรับ Backend
ทำการลง nodejs version 20 ขึ้นไป
## Python Flask API
1. install python version 3.9.6
```
https://www.python.org/downloads/release/python-396/
```
2. create project and install lib
```
mkdir dashboard-service
cd dashboard-service
touch app.py
pip install -r  requirements.txt
```
3. run application
```
python app.py
```
## Golang Echo API
1. install golang version 
```
https://go.dev/doc/install
```
2. create project and install lib
```
mkdir  payment-service
cd payment-service
touch main.go
go mod init payment-service
go mod tidy
```
3. run application
```
go mod tidy (ทำทุกครั้งเมื่อมี lib ใหม่ๆ)
go run main.go
```

## NodeJs express API
1. install NodeJs version 
```
https://nodejs.org/en/download/package-manager
```
2. create project and install lib
```
mkdir report-service
cd report-service
npm init -y
npm install express
touch server.js
```
3. run application
```
node server.js
```


## สร้าง Dockerfile สำหรับ Build และ Test Docker ด้วย command

คำสั่ง docker ที่ใช้กันบ่อยๆ
```
คำสั่งใช้สำหรับ build docker image   
  - docker build -t (*project) .
  - docker build --platform=linux/arm64 -t tag-name . (สำหรับเครื่อง mac m1 ขึ้นไป)
  
คำสั่งใช้สำหรับ run docker container
  - docker run -p public-port:private-port -d --name (*project) -e "NODE_ENV=production"  --env-file=".env" (docker images)

คำสั่งใช้สำหรับ ดู logs ใน container
  - docker logs -f (*project)

คำสั่งใช้สำหรับ shell เข้าใน container (ด้านหลังจะขึ้นอยู่คำสั่งใน image)
  - docker exec -it (*project) bash

คำสั่งใช้สำหรับการ start การทำงานของ container
  - docker rm -f (*id) 
  - docker stop (*id)

คำสั่งใช้สำหรับการ ลบ images ของ container
  - docker rmi -f (*id)

คำสั่งใช้สำหรับการ login docker
  - docker login -u ..... -p ..... url-registry

คำสั่งใช้สำหรับการ push image ขึ้น registry
  - docker push (tags)

คำสั่งใช้สำหรับการ build และ push image ขึ้น registry ไปพร้อมเมื่อ build เสร็จ
  - docker build --platform=linux/arm64 -t tag-name --push . (สำหรับเครื่อง mac m1 ขึ้นไป)
  - docker build -t tag-name --push . (สำหรับเครื่อง linux)

```

สำหรับ docker-compose
```
touch docker-compose.yml
docker-compose up -d
docker-compose pull
docker-compose down
```

# บทที่ 2: Introduction to CI/CD

- สมัครเข้าใช้บริการ [gitlab.com](gitlab.com)
- สร้าง group (ชื่อ) devops-basic
- สร้าง project ทั้งหมด 8 ชื่อ
  - dashboard-service
  - payment-service
  - report-service
  - app-console
  - user-console
  - devops-compose-vm
  - devops-helm
  - infra-terraform

สร้างไฟล์ .gitlab-ci.yml ในแต่ละ repo
```
    touch .gitlab-ci.yml
```

เขียน pipeline ที่ใช้ทำงาน (dev , prod)
```
stages:
  - develop-build

develop-build:
  stage: develop-build
  image : docker:latest
  tags: [gitlab-org-docker]
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
    DOCKER_TLS_CERTDIR: ""
  script:
      -  docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
      -  docker build --pull -t $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_NAME .
      -  docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_NAME
  only:
    - dev
```

จากนั้นทำการ push code ทั้งหมดไปยัง gitlab
```
git add .
git commit -am "fix code and pipeline cicd by gitlab ci"
git push origin .... (master , main , dev)
```
จากการทดสอบหลังจาก push ไปยัง gitlab แล้วผลผ่านให้พร้อมอีก 2 stage 
```
## (stage นี้จะทำการ deploy docker images ไปที่ server vm ที่เราตั้งไว้)
develop-deploy:
  stage: develop-deploy
  image: ubuntu
  tags: [gitlab-org-docker]
  services:
    - docker:dind
  environment:
    name: Development
  before_script:
    - "which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )"
    - eval $(ssh-agent -s)
    - echo "$SSH_DEV_KEY" | tr -d '\r' | ssh-add - > /dev/null
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o "StrictHostKeyChecking=no" -p22 $TARGET_DEV_USER
    - ssh -p22 $TARGET_DEV_USER "docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY"
    # - ssh -p22 $TARGET_DEV_USER "docker-compose -f docker-compose.yml pull"
    # - ssh -p22 $TARGET_DEV_USER "docker-compose -f docker-compose.yml down"
    # - ssh -p22 $TARGET_DEV_USER "docker-compose -f docker-compose.yml up -d"
  only:
    - dev


## (stage นี้จะทำการ build docker image โดยการติด version ของแต่ละครั้งเก็บไว้ที่ registry)
production-build:
  stage: production-build
  image: docker:latest
  tags: [gitlab-org-docker]
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
    DOCKER_TLS_CERTDIR: ''
  script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  - docker build --pull -t $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG .
  - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
  only:
    - tags
```

# บทที่ 3: Introduction To Deploy Application

ทำการสมัครซื้อ Domain ค่ายไหนก็ได้ตามใจนักเรียน
- สมัครเข้าใช้บริการ [z.com](z.com)
- เลือก Domain ที่เราต้องการ

## สร้าง EC2 หรือ VM

สร้าง VM ขึ้นมาแล้วจากนั้นเข้า ssh เข้าไปที่ Server
```
ssh -i ~/.ssh/key.pem ubuntu@1.1.1.1
```
ทำการติดตั้ง docker Engine
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
```
ทำการติดตั้ง docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```
กำหนดสิทธ์ให้กับ docker
```
sudo usermod -aG docker ${USER}
sudo chmod 777 /var/run/docker.sock
```

ทำการ clone devops-compose สำหรับการ deploy application
```
git clone
```
ทำการ deploy application แต่ละตัวและรวมไปถึง nginx ที่ต่อกับ domain
```
docker-compose up -d
```

สร้าง ssh-key สำหรับ server connection กับ gitlab
```
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
copy id_rsa ไปเพิ่มใน env ของ cicd gitlab

SSH_DEV_KEY เอามาจาก id_rsa ของ server
TARGET_DEV_USER เอามาจากการเข้า server ด้วย ssh ex: ubuntu@1.1.1.1
```

## สร้าง EKS หรือ GKE

ตั้งค่าให้ local config kubernetes ในเครื่อง
```
aws eks update-kubeconfig --name eks-training --region ap-southeast-1 --profile devops
```
ติดตั้ง ingress สำหรับ kubernetes
```
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace kube-system
```
สร้าง namespace ใน kubernetes
```
kubectl create namespace application
```

สร้าง Secert สำหรับใช้งาน Login Docker
```
kubectl create secret docker-registry gitlab-registry --docker-server=registry.gitlab.com --docker-username=..... --docker-password=...... --docker-email=demo@gmail.com --namespace=application --output=yaml > docker-registry.yaml
```
ทำการ apply docker login
```
kubectl apply -f docker-registry.yaml
```

สร้าง Secert ENV สำหรับใช้งานใน kubernetes
```
kubectl create secret generic env-secrets --namespace=application --type=Opaque --from-env-file=environment/production/.env --dry-run=true  --output=yaml > secret.yaml
```
ทำการ apply secert env 
```
kubectl apply -f secret.yaml
```

deploy application ทั้งหมดใน kubernetes
```
kubectl apply -f dashboard-service
kubectl apply -f payment-service
kubectl apply -f report-service
kubectl apply -f app-console
kubectl apply -f user-console
```

delete application ทั้งหมดใน kubernetes
```
kubectl delete -f dashboard-service
kubectl delete -f payment-service
kubectl delete -f report-service
kubectl delete -f app-console
kubectl delete -f user-console
```

config ingress กับ domain ใน kubernetes
```
kubectl apply -f ingress.yaml
```
สำสั่งเพิ่มเติมสำหรับใช้ kubernetes งานหลักๆ
```
คำสั่งดู pods
-----------------
kubectl get pods 
kubectl get pods -n application
kubectl get pods -A
-----------------

คำสั่งดู deployment
-----------------
kubectl get deployment 
kubectl get deployment -n application
kubectl get deployment -A
-----------------

คำสั่งดู service
-----------------
kubectl get svc 
kubectl get svc -n application
kubectl get svc -A
-----------------

คำสั่งดู ingress
-----------------
kubectl get ing 
kubectl get ing -n application
kubectl get ing -A
-----------------

คำสั่งดู describe
-----------------
kubectl describe pod ()
kubectl describe pod () -n application
kubectl describe svc ()
kubectl describe svc () -n application
kubectl describe deployment ()
kubectl describe deployment () -n application
-----------------

คำสั่งดู logs ใน pods
-----------------
kubectl logs -f (pod_name)
kubectl logs -f (pod_name) -n application
-----------------

คำสั่ง shell ใน pods
-----------------
kubectl exec -it <pod_name> -- <command>
kubectl exec -it <pod_name> -- <command> -n application
-----------------

คำสั่ง scale ใน deployment pods
-----------------
kubectl scale deployment <deployment_name> --replicas=<number_of_replicas>
kubectl scale deployment <deployment_name> --replicas=<number_of_replicas> -n application
-----------------

คำสั่ง scale ใน deployment pods
-----------------
kubectl port-forward <pod_name> <local_port>:<pod_port>
kubectl port-forward <pod_name> <local_port>:<pod_port> -n application
-----------------
```

## ติดตั้ง ArgoCD ด้วย Helm
```
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"| base64 -d;echo

kubectl port-forward svc/argocd-server -n argocd 8080:443   

kubectl create namespace application (for deploy application on namespace)

```
base64 to string
```
echo VEEtN243eU...... | base64 --decode
```

username password สำหรับ argocd
```
user : admin
pass : prom-operator
```

## การใช้ Helm

ทดสอบสร้าง template สำหรับ helm
```
helm template dashboard-service -f values/default.yaml -f values/dev.yaml .
helm template payment-service -f values/default.yaml -f values/dev.yaml .
helm template report-service -f values/default.yaml -f values/dev.yaml .
helm template app-console -f values/default.yaml -f values/dev.yaml .
helm template user-console -f values/default.yaml -f values/dev.yaml .
```

ติดตั้ง application ด้วย helm
```
helm install dashboard-service -f values/dev.yaml  .
helm install payment-service -f values/dev.yaml  .
helm install report-service -f values/dev.yaml .
helm install app-console  -f values/dev.yaml  .
helm install user-console -f values/dev.yaml  .
```

ลบการติดตั้ง application ด้วย helm
```
helm uninstall dashboard-service -n application 
helm uninstall payment-service -n application
helm uninstall report-service -n application
helm uninstall app-console -n application
helm uninstall user-console -n application
```
# บทที่ 4: Introduction To Monitor System
## Deploy the Metrics Server
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## check pods ของ metrics-server
```
kubectl get deployment metrics-server -n kube-system
```

## ติดตั้ง prometheus และ grafana
```
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
```

อ้างอิง https://prometheus-community.github.io/helm-charts/

## ติดตั้ง grafana loki สำหรับดู Logging View
```
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki-stack -n monitoring
```
อ้างอิง https://grafana.com/docs/loki/latest/setup/install/helm/install-monolithic/

## Host สำหรับใช้เชื่อมต่อ
```
http://loki.monitoring.svc.cluster.local:3100
```


# บทที่ 5: Introduction To LoadTest System
##  การทดสอบระบบด้วย Locust Load Testing
```
cd platform/loadtest/docker-locust
docker-compose up -d
```
อ้างอิง https://docs.locust.io/en/2.0.0/running-locust-docker.html
##  การทดสอบระบบด้วย k6 Load Testing
```
cd platform/loadtest/docker-k6
./run.sh
```
อ้างอิง https://github.com/luketn/docker-k6-grafana-influxdb

# บทที่ 6: infrastructure Automation (Very special)
ทดสอบสร้าง ec2 ด้วย terraform
```
terraform init
terraform plan
terraform apply

```
ทดสอบสร้าง eks ด้วย terraform
```
terraform init
terraform plan
terraform apply
```
ทดสอบสร้าง ec2 ด้วย gitlab
```
git add .
git commit -am "config ec2"
git push origin main
```

อ้างอิง https://medium.com/geekculture/how-to-run-terraform-script-using-gitlab-ci-cd-b6f448ab0232