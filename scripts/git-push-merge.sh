#!/bin/zsh

push_and_merge() {
    if [ -z "$1" ]; then
        echo "请提供目标分支作为参数。"
        return 1
    fi

    CURREN_BRANCH=$(git rev-parse --abbrev-ref HEAD)

    git push origin "$CURREN_BRANCH"
    git checkout "$1"
    git pull origin "$1"
    git merge "$CURREN_BRANCH"
    git push origin "$1"

    echo "分支推送并合并完成。"
}

push_and_merge "$@"
