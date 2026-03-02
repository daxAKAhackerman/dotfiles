alias python=python3
alias pip='python3 -m pip'
alias git-changelog='git fetch --all && git log --reverse $(git describe --tags --abbrev=0 origin/master)..origin/master --format="- %s"'
alias git-changelog-main='git fetch --all && git log --reverse $(git describe --tags --abbrev=0 origin/main)..origin/main --format="- %s"'
alias z='zed .'
alias n='nvim .'

function git-cleanup {
  git remote prune origin
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}

function set-profile { export AWS_PROFILE=poka-${1}-${AWS_DEFAULT_REGION}; }

function set-region {
  export AWS_DEFAULT_REGION=$1
  export AWS_PROFILE=$(echo $AWS_PROFILE | sed -E "s/[a-z]{2}\-[a-z]+\-[0-9]+/$AWS_DEFAULT_REGION/")
}

function sso-login { aws sso login --profile poka-ci-basic; }

function aws-tunnel {
  INSTANCE_ID=$(aws ec2 describe-tags --filters '[{"Name": "value", "Values": ["*aurora-jumpbox"]}, {"Name": "resource-type", "Values": ["instance"]}]' --query Tags[-1].ResourceId --output text)
  aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "portNumber"=["$3"],"localPortNumber"=["$1"],"host"=["$2"]
}

function dns-flush {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

function nuke-cdk-out {
  find . -type d -name "cdk.out" -not -path "*/node_modules/*" -exec rm -r {} \;
}

function make-deploy-multi-region {
  for region in $@; do
    set-region $region
    make deploy
  done
}

function make-deploy-multi-region-prod {
  set-profile prod
  make-deploy-multi-region us-west-2 us-east-2 eu-west-1 ca-central-1 eu-central-1 us-east-1
}

function make-deploy-multi-region-stage {
  set-profile stage
  make-deploy-multi-region us-east-1 ca-central-1 eu-central-1 us-west-2 us-east-2 eu-west-1
}

function make-deploy-multi-region-dev {
  set-profile dev
  make-deploy-multi-region us-east-1 ca-central-1
}

function make-deploy-instance-service-sandbox-dev-stage {
  # Sandbox
  set-profile sdegrace
  set-region us-east-1
  make deploy
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all
  set-region ca-central-1
  make deploy
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all

  # Dev
  set-profile dev
  make-deploy-multi-region-dev
  set-region us-east-1
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all
  set-region ca-central-1
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all

  # Stage
  set-profile stage
  make-deploy-multi-region-stage
  set-region us-east-1
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all
  set-region ca-central-1
  instance-service-ctl update resources --update-template --all
  #instance-service-ctl update services --update-template --all
}

function update-components {
  type=$1
  version=$2

  component-service-cli component batch-update --type $type && component-service-cli --format pretty --select component_id,version,branch component list --type $type | grep -v $version
}

run-claude() {
  export AWS_DEFAULT_REGION="us-east-1"
  export AWS_PROFILE="poka-dev-us-east-1"
  export CLAUDE_CODE_USE_BEDROCK=1
  export ANTHROPIC_SMALL_FAST_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'
  export ANTHROPIC_MODEL='us.anthropic.claude-sonnet-4-5-20250929-v1:0'
  echo "Environment variables have been set."
  claude
}
