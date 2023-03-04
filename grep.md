# grep从多个条件搜索
grep -E 'conditionA|conditionB'  -irn ./ 

# grep排除多个文件
grep -E 'conditionA|conditionB'  -irn ./ --exclude='y' --exclude='fileNamePrefix*' --exclude='*FilenamePostfix' --exclude-dir='subDir' 
