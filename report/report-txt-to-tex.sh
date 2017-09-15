REGION=$1

cd /media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/Eval_all
rm -rf eval_all_tex.txt
awk -F' ' -f ~/DeveloppementBase/Scripts/report/report-txt-to-tex.awk eval_all.txt >> eval_all_tex.txt
