cd /media/cyrilwendl/15BA65E227EC1B23/finistere/detail/Eval_all
rm -rf eval_all_tex.txt
awk -F' ' -f ~/DeveloppementBase/Scripts/report/report-format.awk eval_all.txt >> eval_all_tex.txt
