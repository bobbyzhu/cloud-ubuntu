#!/usr/bin/env python

import os, re, time

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
 
        content += "<table style='border: 1px; bgcolor: #333'>\n" \
                   "  <tr>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "    <th>%s</th>\n" \
                   "  </tr>\n" \
                   % ("No.", "play", "download", "title", "size",
                     "time", "author", "tags", "description")
   
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

            info = {"time": '', "title": '', 'author': '', 'tags': '', 'desc': ''}
            for i in range(1, 10):
                l = t.readline()
                if not l:
                    break

                for (k, v) in info.items():
                    if not v:
                        m = re.match(r"var VNC_frame_%s = '(.*)';" % k, l)
                        if m and len(m.groups()):
                            info[k] = m.group(1)

            if not info['time']:
                info['time'] = time.strftime("%Y%m%d %H:%M:%S",
                             time.localtime(os.path.getctime(f)))
            else:
                info['time'] = time.strftime("%Y%m%d %H:%M:%S",
                             time.strptime(info['time'], "%a, %d %b %Y %H:%M:%S %Z"))
            if not info['title']:
                info["title"] = rec
            if not info['author']:
                info['author'] = "anonymity"
            if not info['tags']:
                info['tags'] = ""
            if not info['desc']:
                info['desc'] = ""

            t.close()

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
                   "    <td>%s</td>\n" \
                   "    <td>%s</td>\n" \
                   "    <td>%s</td>\n" \
                   "    <td>%s</td>\n" \
                   "  </tr>\n" \
                   % (num, play_url, down_url, info['title'], str(rec_size), unit,
                     info['time'], info['author'], info['tags'], info['desc'])

        content += "</table>\n\n" \
                   "</body>\n" \
                   "</html>"

        records.write(content);
        records.close();
