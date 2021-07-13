# Kubectl plugin manager
export PATH="${PATH}:${HOME}/.krew/bin"
  

# gcloud
export CLOUDSDK_PYTHON=python2

# stern (logs)
source <(stern --completion=zsh)

# k8s 
alias k="kubectl"
alias kargo="kubectl port-forward -n argocd svc/argocd-server 8888:443"
alias kbuild="kubectl port-forward svc/kinto-worker-kinto-build 9090:8080 -n kinto-worker"

# kinto shuttle dev
alias svegeta="sshuttle -r noobdeem@35.201.142.203 10.5.0.0/28"
alias sgoku="sshuttle -r noobdeem@34.78.47.0 10.5.0.0/28"

# kinto clusters
alias kvegeta="gcloud container clusters get-credentials vegeta-cluster --zone asia-east1-c --project kinto-development"
alias kgoku="gcloud container clusters get-credentials goku-cluster --zone europe-west1-c --project kinto-development"

# kinto prod 
alias keu="gcloud container clusters get-credentials belgium-cluster --region europe-west1 --project kinto-production"
alias kus="gcloud container clusters get-credentials oregon-cluster --region us-west1 --project kinto-production"
alias kasia="gcloud container clusters get-credentials taiwan-cluster --region asia-east1 --project kinto-production"


alias seu="sshuttle -r noobdeem@35.205.220.145 10.5.0.0/28"
alias sus="sshuttle -r noobdeem@35.233.229.106 10.5.0.0/28"
alias sasia="sshuttle -r noobdeem@35.229.197.13 10.5.0.0/28"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nadeemkhedr/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nadeemkhedr/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nadeemkhedr/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nadeemkhedr/google-cloud-sdk/completion.zsh.inc'; fi

# Okteto
# export KUBECONFIG=$HOME/Downloads/okteto-kube.config:${KUBECONFIG:-$HOME/.kube/config}

