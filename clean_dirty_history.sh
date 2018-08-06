#!/bin/bash
cp ~/.zsh_history /tmp/zsh_history1

# https://wiki.archlinux.org/index.php/Zsh_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E6.B6.88.E9.99.A4.E5.8E.86.E5.8F.B2.E8.AE.B0.E5.BD.95.E4.B8.AD.E7.9A.84.E9.87.8D.E5.A4.8D.E6.9D.A1.E7.9B.AE
# uniq the history
sort -t ";" -k 2 -u /tmp/zsh_history1 | sort -o /tmp/zsh_history2
echo "[*] clean duplicate lines"

# clean dirty commands
patterns='bash|cd|chmod|df|du|git|htop|ifconfig|ipython|ll|ls|jav-download.py|mergeRequest.py|music|ping|pwd|scp|totp.py|gnome-calculator'
cat /tmp/zsh_history2 | grep -avE $patterns > ~/zsh_history
#-a, --text                equivalent to --binary-files=text
echo -e "[*] clean dirty history"
echo -e "[*] file output to ~/zsh_history"
rm -rf /tmp/zsh_history*
echo -e "[*] clear tmp file"
echo -e "[*] u need to move ~/zsh_histoty ~/.zsh_history manully"
