# 利用fzf的模糊搜索，交互式切换分支
git checkout $(gb | fzf)

# git与remote master做diff
git diff origin/master --no-prefix -U1000 --ignore-space-change >~/1.diff

# 统计git提交代码行数
git log --format='%aN' | sort -u | while read name; do
  echo -en "$name\t"
  git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
done

# git强制覆盖本地改动
git fetch --all && git reset --hard origin/`git branch --show-current`

# 复制最后一个commit到剪贴板 -- 提到的cb是本项目中名为cb的脚本。
git log -1 | awk '{print $2}' | head -n1 | cb

# 复制git repo地址到剪贴板
git remote -v | awk '{print $2}' | sed -n 1p | cb

# 复制当前git分支到剪贴板
git branch --show-current | cb

# 从剪贴板读取上一个commit，并cherry-pick。嘿嘿
cb | xargs git cherry-pick

# 使用远端分支覆盖本地改动
git fetch --all && git reset --hard origin/`git branch --show-current`

# 分支重命名
git branch -m oldName newName && git push --delete origin oldName && git push origin newName && git branch --set-upstream-to origin/newName

# git tag相关（添加、上传、删除本地、删除远端、远端tag覆盖本地）
git tag -a 1.1.0 -m "message"
git push origin 1.1.0
git tag -d 1.1.0
git push origin :refs/tags/1.1.0
git tag -d 1.1.0 && git fetch  --tags

# git stash相关 (当前改动放入暂存,取出最近暂存,查看暂存list,查看暂存list中指定改动,取出暂存list中指定改动)
git stash 
git stash apply
git stash list
git stash show -p stash@{2}
git stash apply stash@{2}