REGION=$1

rm -rf eval_all_tex.txt
cd /media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/Eval_bin
awk -F' ' -f ~/DeveloppementBase/Scripts/report/report-format-eval-bin.awk eval-bin.txt >> eval_all_tex.txt
