
export USER=$(whoami)

export PATH=$PATH:/opt/kk/bin/

kubectl completion bash > /usr/share/bash-completion/completions/kubectl
kind completion bash > /usr/share/bash-completion/completions/kind

pretty_bash(){
  KK_INFO="$(kubectl config view --minify -o=json 2>/dev/null| jq '.contexts[0].context')"
  KK_CONTEXT="$(echo $KK_INFO |jq -r '.cluster')"
  KK_NAMESPACE="$(echo $KK_INFO |jq -r '.namespace'| sed 's/null/default/g')"
  echo "
    KK_CONTEXT=$KK_CONTEXT
    KK_NAMESPACE=$KK_NAMESPACE
  " > $HOME/.kkrc
  echo -e "\e[m[ 🐳 \e[31m${KK_CONTEXT:-none}\e[m \e[34m🏷  ${KK_NAMESPACE:-none} \e[m]$ "
}

export PS1="\$(pretty_bash)"