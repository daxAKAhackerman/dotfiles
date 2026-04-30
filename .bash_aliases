alias z='zed .'
alias n='nvim .'

function git-cleanup {
  git remote prune origin
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}

function nuke-cdk-out {
  find . -type d -name "cdk.out" -not -path "*/node_modules/*" -exec rm -r {} \;
}

if [[ "$(uname)" == "Darwin" ]]; then
  function set-profile { export AWS_PROFILE=poka-${1}-${AWS_DEFAULT_REGION}; }

  function set-region {
    export AWS_DEFAULT_REGION=$1
    AWS_PROFILE=$(echo "$AWS_PROFILE" | sed -E "s/[a-z]{2}\-[a-z]+\-[0-9]+/$AWS_DEFAULT_REGION/")
    export AWS_PROFILE
  }

  function sso-login { aws sso login --profile poka-ci-basic; }

  function aws-tunnel {
    INSTANCE_ID=$(aws ec2 describe-tags --filters '[{"Name": "value", "Values": ["*aurora-jumpbox"]}, {"Name": "resource-type", "Values": ["instance"]}]' --query Tags[-1].ResourceId --output text)
    aws ssm start-session --target "$INSTANCE_ID" --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "portNumber"=["$3"],"localPortNumber"=["$1"],"host"=["$2"]
  }

  function dns-flush {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  }

  function update-components {
    type=$1
    version=$2

    component-service-cli component batch-update --type "$type" && component-service-cli --format pretty --select component_id,version,branch component list --type "$type" | grep -v "$version"
  }

  alias languagetool='/opt/homebrew/opt/openjdk/bin/java -jar /opt/languagetool/LanguageTool-6.6/languagetool.jar'
else
  alias vba='/opt/visualboyadvance-m/build/visualboyadvance-m'

  function update {
    sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove --purge -y
    flatpak update -y
  }
fi
