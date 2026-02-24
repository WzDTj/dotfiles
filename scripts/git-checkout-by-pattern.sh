#!/bin/zsh

checkout_by_pattern() {
    if [ -z "$1" ]; then
        echo "请提供分支匹配关键字。"
        return 1
    fi

    local pattern target
    pattern="$1"
    target=$(git branch --format '%(refname:short)' | grep -- "$pattern" | tail -n 1)

    if [ -z "$target" ]; then
        echo "未找到匹配分支：$pattern"
        return 1
    fi

    git checkout "$target"
}

checkout_by_pattern "$@"
