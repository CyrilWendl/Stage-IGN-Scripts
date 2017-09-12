rm -rf eval_all_tex.txt
cd /media/cyrilwendl/15BA65E227EC1B23/finistere/detail/Eval_all
ls ~/DeveloppementBase/Scripts/report-format.awk
awk -F' ' -f ~/DeveloppementBase/Scripts/report-format.awk eval_all.txt >> eval_all_tex.txt
