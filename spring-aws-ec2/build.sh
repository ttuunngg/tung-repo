mvn clean package
$(aws ecr get-login --no-include-email --region us-east-1)
docker build -t eks-repo-84734 .
docker tag eks-repo-84734:latest 960562133150.dkr.ecr.us-east-1.amazonaws.com/eks-repo-84734:latest
docker push 960562133150.dkr.ecr.us-east-1.amazonaws.com/eks-repo-84734:latest