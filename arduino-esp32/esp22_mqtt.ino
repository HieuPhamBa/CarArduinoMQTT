#include <WiFi.h>
#include <PubSubClient.h>

int speedCar = 255;
int speed_Coeff = 3;

#define ssid "nokia110i"
#define password "12345678"

#define mqtt_server "40.117.140.73"  // Thay bằng thông tin của bạn
#define mqtt_topic_pub "arduino_msg" //Giữ nguyên nếu bạn tạo topic tên là demo
#define mqtt_topic_sub "testtopic/1"
#define mqtt_user "robotCar" //Giữ nguyên nếu bạn tạo user là esp8266 và pass là 123456
#define mqtt_pwd "1234567890"

#define mqtt_toppic_jsp_pub "car/jps"

const uint16_t mqtt_port = 1883;

int enA = 12;
int in1 = 14;
int in2 = 27;
int in3 = 26;
int in4 = 25;
int enB = 33;

const char *CMD_GOAHEAD = "goAhead";
const char *CMD_GOBACK = "goBack";
const char *CMD_GORIGHT = "goRight";
const char *CMD_GOLEFT = "goLeft";
const char *CMD_STOP = "stopRobot";
const char *CMD_GOARIGHT = "goAheadRight";
const char *CMD_GOALEFT = "goAheadLeft";
const char *CMD_GOBRIGHT = "goBackRight";
const char *CMD_GOBLEFT = "goBackLeft";

#define LEDC_CHANNEL_0     0
#define LEDC_TIMER_13_BIT  13
#define LEDC_BASE_FREQ     5000


static int app_cpu = 0;

WiFiClient espClient;
PubSubClient client(espClient);

long lastMsg = 0;
char msg[50];
int value = 0;


void setup()
{
  Serial.begin(9600);

  setup_wifi();

  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  BaseType_t rc;
  unsigned priority = 0;
  TaskHandle_t h1;

  app_cpu = xPortGetCoreID();

  ledcSetup(LEDC_CHANNEL_0, LEDC_BASE_FREQ, LEDC_TIMER_13_BIT);
  ledcAttachPin(enA, LEDC_CHANNEL_0);

  ledcSetup(LEDC_CHANNEL_0, LEDC_BASE_FREQ, LEDC_TIMER_13_BIT);
  ledcAttachPin(enB, LEDC_CHANNEL_0);
  
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
 

  delay(2000); // Allow USB init time

  vTaskPrioritySet(nullptr, 3);
  priority = uxTaskPriorityGet(nullptr);
  assert(priority == 3);

  Serial.print("\ntaskcreate.ino:\n");
  Serial.print("loopTask-------------------------------------------------------------- priority is .\n");
  Serial.print(priority);
  
  rc = xTaskCreatePinnedToCore(
      wifi_reconnect,
      "wifi_reconnect",
      2000, // Stack size
      nullptr,
      2,      // Priority
      &h1,    // Task handle
      app_cpu // CPU
  );

   rc = xTaskCreatePinnedToCore(
      send_jsp,
      "send_jsp",
      2000, // Stack size
      nullptr,
      2,      // Priority
      &h1,    // Task handle
      app_cpu // CPU
  );
  assert(rc == pdPASS);
  // delay(1);
  Serial.print("Task wifi_connect created.\n");

  vTaskPrioritySet(h1, 3);
}

// Not used:
void loop()
{
  vTaskDelete(nullptr);
}



void wifi_reconnect(void *argp)
{
  BaseType_t rc;
  TaskHandle_t h2;

  for (;;)
  {
    if (!client.connected())
    {
      reconnect();
    }
    client.loop();
  }
}

//Task gui tin hieu jps
void send_jsp(void *argp){
  BaseType_t rc;
  TaskHandle_t h2;

  for (;;)
  {
     client.publish(mqtt_toppic_jsp_pub, "12:243:33");
     vTaskDelay(1);
  }
}

// Hàm kết nối wifi
void setup_wifi()
{
  delay(10);
  Serial.print("\n");
  Serial.print("Connecting to ");
  Serial.print(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

// Hàm reconnect thực hiện kết nối lại khi mất kết nối với MQTT Broker
void reconnect()
{
  // Chờ tới khi kết nối
  while (!client.connected())
  {
    Serial.print("Attempting MQTT connection...");
    // Thực hiện kết nối với mqtt user và pass
    if (client.connect("arduino_client", mqtt_user, mqtt_pwd))
    {
      Serial.println("connected");

      client.publish(mqtt_topic_pub, "ESP_reconnected");
      client.subscribe(mqtt_topic_sub);
    }
    else
    {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println("try again in 5 seconds");

      delay(5000);
    }
  }
}


// Hàm call back để nhận dữ liệu
void callback(char *topic, byte *payload, unsigned int length)
{
  char mesages[100];

  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("]");

  for (int i = 0; i < length; i++)
  {
    char receivedChar = (char)payload[i];

    mesages[i] = receivedChar;
    Serial.print(receivedChar);
  }

  Serial.println();
  
  if (strcmp(mesages, CMD_GOAHEAD) == 0)
  {
    goAhead();
  }
  else if (strcmp(mesages, CMD_GOBACK) == 0)
  {
    goBack();
  }
  else if (strcmp(mesages, CMD_GORIGHT) == 0)
  {
    goRight();
  }
  else if (strcmp(mesages, CMD_GOLEFT) == 0)
  {
    goLeft();
  }
  else if (strcmp(mesages, CMD_STOP) == 0)
  {
    stopRobot();
  }
  else if (strcmp(mesages, CMD_GOARIGHT) == 0)
  {
    goAheadRight();
  }
  else if (strcmp(mesages, CMD_GOALEFT) == 0)
  {
    goAheadLeft();
  }
  else if (strcmp(mesages, CMD_GOBRIGHT) == 0)
  {
    goBackRight();
  }
  else if (strcmp(mesages, CMD_GOBLEFT) == 0)
  {
    goBackLeft();
  }

  client.publish(mqtt_topic_pub, mesages);
  Serial.println();
}

void ledcAnalogWrite(uint8_t channel, uint32_t value, uint32_t valueMax = 255) {
  // calculate duty, 8191 from 2 ^ 13 - 1
  uint32_t duty = (8191 / valueMax) * min(value, valueMax);

  // write duty to LEDC
  ledcWrite(channel, duty);
}


void goAhead()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);

  Serial.println("-Car go ahead-");
}

void goBack()
{
  ledcAnalogWrite(22, speedCar);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  Serial.println("Car current status: Car go back");
}

void stopRobot()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);

  Serial.println("Car current status: Car stopped");
}

void goRight()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);

  Serial.println("Car current status: car go Right");
}

void goLeft()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  Serial.println("Car current status: Car go left");
}

void goAheadRight()
{
  ledcAnalogWrite(enA, speedCar / speed_Coeff);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);

  Serial.println("Car current status: Car go aheadRight");
}

void goAheadLeft()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  ledcAnalogWrite(enB, speedCar / speed_Coeff);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);

  Serial.println("Car current status: car go aheadLeft-");
}

void goBackRight()
{
  ledcAnalogWrite(enA, speedCar / speed_Coeff);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  ledcAnalogWrite(enB, speedCar);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  Serial.println("Car current status: go backRight");
}

void goBackLeft()
{
  ledcAnalogWrite(enA, speedCar);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  ledcAnalogWrite(enB, speedCar / speed_Coeff);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  Serial.println("Car current status: car go backLeft");
}
