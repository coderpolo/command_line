#利用fzf的模糊搜索，交互式切换分支
git checkout $(gb | fzf)

# git与remote master做diff
git diff origin/master --no-prefix -U1000 --ignore-space-change >~/1.diff

#统计git提交代码行数
git log --format='%aN' | sort -u | while read name; do
  echo -en "$name\t"
  git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
done

#git强制覆盖本地改动
git fetch --all && git reset --hard origin/`git branch --show-current`

#复制最后一个commit到剪贴板 -- 提到的cb是本项目中名为cb的脚本。
git log -1 | awk '{print $2}' | head -n1 | cb

#复制git repo地址到剪贴板
git remote -v | awk '{print $2}' | sed -n 1p | cb

#复制当前git分支到剪贴板
git branch --show-current | cb

#从剪贴板读取上一个commit，并cherry-pick。嘿嘿
cb | xargs git cherry-pick