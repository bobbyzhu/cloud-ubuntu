#!/usr/bin/env python

import os, re

class Records:
    def __init__(self, record_dir = 'recordings/', record_list = 'records.html'):
        self.record_dir = record_dir
        self.record_list = record_list

    def compare(self, x, y):
        stat_x = os.stat(self.record_dir + "/" + x)
        stat_y = os.stat(self.record_dir + "/" + y)
        if (stat_x.st_ctime > stat_y.st_ctime):
            return -1
        elif (stat_x.st_ctime > stat_y.st_ctime):
            return 1
        else:
            return 0

    def generate(self):
        records = open(os.path.abspath(self.record_dir + self.record_list),'w+')
        content = "<html>\n" \
                  "<head>\n" \
                  "<title>noVNC Recordings</title>\n" \
                  "<style style='text/css'>\n" \
                  "    a { text-decoration: none; outline: none; }\n" \
                  "</style>\n" \
                  "</head>\n" \
                  "<body>\n\n"
 
        content += "<table>\n" \
                   "  <tr>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "  </tr>\n" \
                   % ("No.", "play", "download", "title", "size")
   
        rec_list = os.listdir(os.path.abspath(self.record_dir))
        # sort by time
        rec_list.sort(self.compare)

        num = 0;
        for rec in rec_list:
            if (rec == self.record_list):
                continue

            num += 1
            f = os.path.abspath(self.record_dir + rec)
            t = open(f)
            m = re.match(r"var VNC_frame_title = '(.*)';", t.readline())
            t.close()
            if m and len(m.groups()):
                title = m.group(1)
            else:
                title = rec
        
            rec_size = os.path.getsize(f)
            unit = " B"
            if rec_size > 1024:
                rec_size = round(rec_size / 1024.0, 2)
                unit = " KB"
        
            if rec_size > 1024:
                rec_size = round(rec_size / 1024.0, 2)
                unit = " MB"
        
            play_url = "/play.html?data=" + rec
            down_url = "/" + self.record_dir + rec

            content += \
                   "  <tr>\n" \
                   "    <td>%s.</td>\n" \
                   "    <td><a href='%s' target='_top' title='play'> &gt; </a></td>\n" \
                   "    <td><a href='%s' target='_blank' title='download'> v </a></td>\n" \
                   "    <td>%s</td>\n" \
                   "    <td>%s%s</td>\n" \
                   "  </tr>\n" \
                   % (num, play_url, down_url, title, str(rec_size), unit)

        content += "</table>\n\n" \
                   "</body>\n" \
                   "</html>"

        records.write(content);
        records.close();
