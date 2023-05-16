#from flask import Flask, render_template, url_for, redirect
import io
import logging
import socketserver
from http import server
from threading import Condition
from picamera2 import Picamera2
from picamera2.encoders import JpegEncoder
from picamera2.outputs import FileOutput
import RPi.GPIO as GPIO 
import Adafruit_DHT as dht
import smbus
import time
import socket 
#from picamera import PiCamera


#커튼 자동 관리
#커튼 수동 +
#커튼 수동 -
#가습기 자동 관리
#가습기 켜기
#가습기 끄기
#보안 모드 끄고 켜기

GPIO.setwarnings(False)

I2C_CH = 1
BH1750_DEV_ADDR = 0x48
CONT_H_RES_MODE     = 0x10
i2c = smbus.SMBus(I2C_CH)

GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.OUT)    # 초음파 모듈 Trig
GPIO.setup(18, GPIO.IN)     # 초음파 모듈 Echo
GPIO.setup(14, GPIO.OUT)    # 가습기 모듈

StepPins = [5,6,13,19]      # 스텝모터      
for pin in StepPins:
  GPIO.setup(pin,GPIO.OUT)
  GPIO.output(pin,False)    


host = '165.229.125.89'
port = 8505
server_sock = socket.socket(socket.AF_INET) 
server_sock.bind((host, port)) 
server_sock.listen(1)

distance=0
curtain_height=0
warning=0

PAGE = """\
<html>
<head>
<title>picamera2 MJPEG streaming demo</title>
</head>
<body>
<h1>Picamera2 MJPEG Streaming Demo</h1>
<img src="stream.mjpg" width="640" height="480" />
</body>
</html>
"""


class StreamingOutput(io.BufferedIOBase):
    def __init__(self):
        self.frame = None
        self.condition = Condition()

    def write(self, buf):
        with self.condition:
            self.frame = buf
            self.condition.notify_all()


class StreamingHandler(server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(301)
            self.send_header('Location', '/index.html')
            self.end_headers()
        elif self.path == '/index.html':
            content = PAGE.encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html')
            self.send_header('Content-Length', len(content))
            self.end_headers()
            self.wfile.write(content)
        elif self.path == '/stream.mjpg':
            self.send_response(200)
            self.send_header('Age', 0)
            self.send_header('Cache-Control', 'no-cache, private')
            self.send_header('Pragma', 'no-cache')
            self.send_header('Content-Type', 'multipart/x-mixed-replace; boundary=FRAME')
            self.end_headers()
            try:
                while True:
                    with output.condition:
                        output.condition.wait()
                        frame = output.frame
                    self.wfile.write(b'--FRAME\r\n')
                    self.send_header('Content-Type', 'image/jpeg')
                    self.send_header('Content-Length', len(frame))
                    self.end_headers()
                    self.wfile.write(frame)
                    self.wfile.write(b'\r\n')
            except Exception as e:
                logging.warning(
                    'Removed streaming client %s: %s',
                    self.client_address, str(e))
        else:
            self.send_error(404)
            self.end_headers()


class StreamingServer(socketserver.ThreadingMixIn, server.HTTPServer):
    allow_reuse_address = True
    daemon_threads = True


def camera(s_auto):
    if s_auto is False:
        return 0
    picam2 = Picamera2()
    picam2.configure(picam2.create_video_configuration(main={"size": (640, 480)}))
    output = StreamingOutput()
    picam2.start_recording(JpegEncoder(), FileOutput(output))
    try:
        address = ('165.229.125.89', 8000)
        server = StreamingServer(address, StreamingHandler)
        server.serve_forever()
    finally:
        picam2.stop_recording()


def ultrasonic(s_auto):
    GPIO.output(17, False)         
    time.sleep(0.5)
    GPIO.output(17, True)
    time.sleep(0.00001)
    GPIO.output(17, False)

    while GPIO.input(18) == 0:
        start = time.time()

    while GPIO.input(18) == 1:
        stop = time.time()

    time_interval = stop - start
        
    #measure distance
    distance = time_interval * 17000
    distance = round(distance, 2)
    anchor=distance
    
    if s_auto is False:
        return 0
        
    while(True):
        warning=0
        GPIO.output(17, False)         
        time.sleep(0.5)

        GPIO.output(17, True)
        time.sleep(0.00001)
        GPIO.output(17, False)

        while GPIO.input(18) == 0:
            start = time.time()

        while GPIO.input(18) == 1:
            stop = time.time()

        time_interval = stop - start
        
        #measure distance
        distance = time_interval * 17000
        distance = round(distance, 2)
        if(abs(anchor-distance)>100):
            warning=-1
    return 1


#user_input=0~2
def humi_auto(h_auto, h_on):
    humidity, temperature = dht.read_retry(dht.DHT11, 4) #온습도 모듈
    if humidity is None or temperature is None :
        print('Read error')
        return 0
    if h_auto is False: #가습기를 수동으로 끔
        if h_on is False:
            print('가습기 꺼짐')
            GPIO.output(14, False)
        else: #가습기를 수동으로 켬
            print('가습기 켜짐')
            GPIO.output(14, True)
    else:#자동
        #print('state = on')
        if humidity <= 40:
            GPIO.output(14, True)
        else:
            GPIO.output(14, False)
    return 1


#curtain_auto 함수에서 이 부분의 반복이 많아 따로 생성함
def motor(Seq, StepCounter, StepCount, StepPins, rounds, IsClockWise):
    for _ in range(rounds):
        for pin in range(0, 4):
            xpin = StepPins[pin]
            #[-pin]과 [pin]의 구분을 주의할 것
            if Seq[StepCounter][pin]!=0: #Seq[][]가 0이 아니면 동작
                GPIO.output(xpin, True)
            else:
                GPIO.output(xpin, False)

        StepCounter += 1

        if (StepCounter==StepCount):
            StepCounter = 0
        if (StepCounter<0):
            StepCounter = StepCount
            
        #다음 동작 기다리기
        time.sleep(0.01)

#user_input=3~5
def curtain_auto(c_auto, c_clockwise, c_counterclock):
    luxBytes = i2c.read_i2c_block_data(BH1750_DEV_ADDR, CONT_H_RES_MODE, 2)
    lux = int.from_bytes(luxBytes, byteorder='big')
    
    StepCounter = 0 #스텝 수 세는 변수
    StepCount = 4

    #Seq는 스텝모터의 각 핀을 나타냄(최상단 StepPins 배열 참조)
    #Seq 이중 배열은 모터가 돌아가는 순서를 나타냄. 아래는 시계방향 회전을 나타냄.
    #만약 이 상태로 코드를 실행했을 때 반대 방향 회전이 안 된다면, Seq를 이렇게 수정해볼 것:
    #OppositeSeq = [[1,0,0,0],
    #      [0,1,0,0],
    #      [0,0,1,0],
    #      [0,0,0,1]]
    Seq = [[0,0,0,1],
        [0,0,1,0],
        [0,1,0,0],
        [1,0,0,0]]

    if c_auto is True: #자동
        #print('state = on')
        if (lux <= 150) and (curtain_height>0):
            curtain_height-=1
            for _ in range(400):
                for pin in range(0, 4):
                    xpin = StepPins[pin]
                    if Seq[StepCounter][pin]!=0: #Seq[][]가 0이 아니면 동작
                        GPIO.output(xpin, True)
                    else:
                        GPIO.output(xpin, False)

                StepCounter += 1
                

                if (StepCounter==StepCount):
                    StepCounter = 0
                if (StepCounter<0):
                    StepCounter = StepCount

                #다음 동작 기다리기
                time.sleep(0.003)
            
        elif(lux>150) and (curtain_height<10):
            curtain_height+=1
            for _ in range(400):
                for pin in range(0, 4):
                    xpin = StepPins[pin]
                    if Seq[StepCounter][-pin]!=0: #Seq[][]가 0이 아니면 동작
                        GPIO.output(xpin, True)
                    else:
                        GPIO.output(xpin, False)

                StepCounter += 1
                

                if (StepCounter==StepCount):
                    StepCounter = 0
                if (StepCounter<0):
                    StepCounter = StepCount

                #다음 동작 기다리기
                time.sleep(0.003)
    
    else: #수동
        #clockwise=descend curtain
        if c_clockwise is True and (curtain_height>0):
            curtain_height-=1
            for _ in range(400):
                for pin in range(0, 4):
                    xpin = StepPins[pin]
                    if Seq[StepCounter][pin]!=0: #Seq[][]가 0이 아니면 동작
                        GPIO.output(xpin, True)
                    else:
                        GPIO.output(xpin, False)

                StepCounter += 1

                if (StepCounter==StepCount):
                    StepCounter = 0
                if (StepCounter<0):
                    StepCounter = StepCount

                #다음 동작 기다리기
                time.sleep(0.003)
        #counter-clockwise=ascend curtain
        elif c_counterclock is True and (curtain_height<10):
            curtain_height+=1
            for _ in range(400):
                for pin in range(0, 4):
                    xpin = StepPins[pin]
                    if Seq[StepCounter][-pin]!=0: #Seq[][]가 0이 아니면 동작
                        GPIO.output(xpin, True)
                    else:
                        GPIO.output(xpin, False)

                StepCounter += 1

                if (StepCounter==StepCount):
                    StepCounter = 0
                if (StepCounter<0):
                    StepCounter = StepCount

                #다음 동작 기다리기
                time.sleep(0.003)
    
    return 1


def security_auto(s_auto):
    if s_auto is False:
        return 0
    GPIO.output(17, False)         
    time.sleep(0.5)

    GPIO.output(17, True)
    time.sleep(0.00001)
    GPIO.output(17, False)

    while GPIO.input(18) == 0:
        start = time.time()

    while GPIO.input(18) == 1:
        stop = time.time()

    time_interval = stop - start
    distance = time_interval * 17000
    distance = round(distance, 2)

    return 1


def main():
	h_auto=False
	h_on=False
	c_auto=False
	c_clockwise=False
	c_counterclock=False
	s_auto=False


# 함수
    curtain_t = Thread(target=curtain_auto, args=(c_auto, c_clockwise, c_counterclock,))
    curtain_t.start()

    humi_t = Thread(target=humi_auto, args=(h_auto, h_on,))
    humi_t.start()

    camera_t = Thread(target=camera)
    camera_t.start()

    ultrasonic_t = Thread(target=ultrasonic, args=(s_auto,))
    ultrasonic_t.start()

	print("기다리는 중")
	while(True):
        c_clockwise=False
        c_counterclock=False#모터 수동 회전은 영구적이지 않음
		client_sock, addr = server_sock.accept() 
		data = client_sock.recv(1024)
		str = data.decode()
		print(data)
		if data==b'\x00\x012':
			s_auto=False
            ultrasonic_t = Thread(target=ultrasonic, args=(s_auto,))
            ultrasonic_t.start()
        elif data==b'\x00\x013':
            s_auto=True
            ultrasonic_t = Thread(target=ultrasonic, args=(s_auto,))
            ultrasonic_t.start()
        elif data==b'\x00\x014':
            h_auto=False
            humi_t = Thread(target=humi_auto, args=(h_auto, h_on,))
            humi_t.start()
        elif data==b'\x00\x015':
            h_auto=True
            humi_t = Thread(target=humi_auto, args=(h_auto, h_on,))
            humi_t.start()
        elif data==b'\x00\x016':
            h_auto=False
            h_on=False
            humi_t = Thread(target=humi_auto, args=(h_auto, h_on,))
            humi_t.start()
        elif data==b'\x00\x017':
            h_auto=False
            h_on=True
            humi_t = Thread(target=humi_auto, args=(h_auto, h_on,))
            humi_t.start()
        elif data==b'\x00\x018':
            c_auto=False
            curtain_t = Thread(target=curtain_auto, args=(c_auto, c_clockwise, c_counterclock,))
            curtain_t.start()
        elif data==b'\x00\x019':
            c_auto=True
            curtain_t = Thread(target=curtain_auto, args=(c_auto, c_clockwise, c_counterclock,))
            curtain_t.start()
        elif data==b'\x00\x0210':
            c_auto=False
            c_clockwise=True
            c_counterclock=False
            curtain_t = Thread(target=curtain_auto, args=(c_auto, c_clockwise, c_counterclock,))
            curtain_t.start()
        elif data==b'\x00\x0211':
            c_auto=False
            c_clockwise=False
            c_counterclock=True
            curtain_t = Thread(target=curtain_auto, args=(c_auto, c_clockwise, c_counterclock,))
            curtain_t.start()
        if warning==-1:
            client_sock.send(data)
		client_sock.close()
	

	server_sock.close()
    

if __name__ == '__main__':
    main()
