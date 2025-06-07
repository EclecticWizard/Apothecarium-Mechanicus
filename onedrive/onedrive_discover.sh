#!/usr/bin/env bash

cat <<'EOF'

                                              0000000000
                                         00000000000000000000
                                       000000       0 00000000000
                                      000  0        00   00  00000
                                   0000 00                  00000000
                                0000                          0  00
                               00 0 0                            000
                               000000                              0
                                 000            00000000           000
                                 000         0000      000        0 00
                                 000        00           000      0000
                                 00        00              0        00
                                 00         0000000000000000       00
                                 0              00   0   00        0
                                00000           0   000           00
                                  0 000           00            000
                                      00            00        000
                                       000                    000
                                         000               000 00
                                         00000000000000000000000
                                         000000000000000000   000
                                         000   000000   0 0   000
                                         00 000     00 00 0   0000
                                         0000    000 0000 0 0 0 000
                                        0000 00      00 0 000 00000
                                        0000 00         0 000000000
                                        000             0 0     00000
                                       0000             0 0  0   0000
                                       000              0 0   0  0 00
                                       00               0          00
                                      0000  0  000000   00     00  000
                                     0000   0      0000 000  0  0  00000
                                     000    0   0 0 0 0 0000 00000000 00
                                   0000      0   0 00  00 0000000000000
                                   0000     0    0 00   00000
                                    00           00000    0000
                                   000 0000000000000000000  00
                               0000000000000000000000000000000
                              000 000000                00000


EOF
# Discover OneDrive Personal Files
personal=$(echo ~/Library/Group\ Containers/*OneDriveStandaloneSuite*)
if [[ ${#personal[@]} -lt 1 ]]; then
    echo "[-] No personal OneDrive Detected"
    exit
fi
if [[ ${#personal[@]} -gt 1 ]]; then
    echo "[!] Multiple personal OneDrives detected"
    exit
else
    echo "[+] Personal OneDrive located at: ${personal[0]}"
fi

# Discover OneDrive Business/Education Files
business=$(echo ~/Library/Group\ Containers/*OneDriveSyncClientSuite*)
if [[ ${#business[@]} -lt 1 ]]; then
    echo "[-] No business OneDrive Detected"
    exit
fi
if [[ ${#business[@]} -gt 1 ]]; then
    echo "[!] Multiple business OneDrives detected"
    exit
else
    echo "[+] Business OneDrive located at: ${business[0]}"
fi

# ask user if they want to link or copy the files to home directory
echo "Copy or Symlink folders to home directory ($HOME)?"
printf "\t [1] to Copy (creates an 'as is' copy of the files that won't be updated)\n"
printf "\t [2] to Symlink (create a link to files within OneDrive directory, will be updated)\n"
read -p "Enter 1 or 2. Ctrl + C to quit: " response

case $response in
    1)
        mkdir ~/OneDrive; mkdir ~/OneDrive/Business; mkdir ~/OneDrive/Personal
        for d in ~/Library/Group\ Containers/*OneDriveStandaloneSuite*/*.noindex*; do
            echo "[*] Copying: $d"
            cp -r "$d" ~/OneDrive/Personal/"$(basename "$d")"
        done
        for d in ~/Library/Group\ Containers/*OneDriveSyncClientSuite*/*.noindex*; do
            echo "[*] Copying: $d"
            cp -r "$d" ~/OneDrive/Business/"$(basename "$d")"
        done
        echo "[+] Done";;
    2)
        mkdir ~/OneDrive; mkdir ~/OneDrive/Business; mkdir ~/OneDrive/Personal
        for d in ~/Library/Group\ Containers/*OneDriveStandaloneSuite*/*.noindex*; do
            echo "[*] Linking: $d"
           ln -s "$d" ~/OneDrive/Personal/"$(basename "$d") -- Link"
        done
        for d in ~/Library/Group\ Containers/*OneDriveSyncClientSuite*/*.noindex*; do
            echo "[*] Linking: $d"
            ln -s "$d" ~/OneDrive/Business/"$(basename "$d") -- Link"
        done
        echo "[+] Done";;
esac
