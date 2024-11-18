% Import Paho MQTT library
import org.eclipse.paho.client.mqttv3.*;

% Broker setup for the public Mosquitto broker
brokerAddress = "tcp://test.mosquitto.org:1883";
clientID = "matlabClient";

% Initialize MQTT client
mqttClient = MqttClient(brokerAddress, clientID);
options = MqttConnectOptions();
options.setKeepAliveInterval(60);            % Keep-alive interval of 60 seconds
options.setAutomaticReconnect(true);         % Enable automatic reconnection
options.setCleanSession(true);               % Start a new clean session
options.setConnectionTimeout(120);           % Increase connection timeout to 120 seconds

% Define topic and load ECG data
topic = "ECGDATA";
ecg_data = load("generated_ecg_signal.mat");
timestamps = ecg_data.t_total;
ecg_values = ecg_data.ecg_signal;

% Connect to the broker
try
    disp("Connecting to the public Mosquitto broker...");
    mqttClient.connect(options);
    disp("Connected to test.mosquitto.org successfully.");
catch ME
    error("Failed to connect to Mosquitto broker: %s", ME.message);
end

% Publish each ECG value with timestamp
for i = 1:length(timestamps)
    % Prepare the message
    messageStruct = struct("timestamp", timestamps(i), "ecg_value", ecg_values(i));
    jsonMessage = jsonencode(messageStruct);
    javaMessage = java.lang.String(jsonMessage);
    message = MqttMessage(javaMessage.getBytes("UTF-8"));
    message.setQos(0);  % Use QoS 0 for low latency

    % Check if connected before publishing
    if ~mqttClient.isConnected()
        warning("Client is disconnected. Attempting to reconnect...");
        try
            mqttClient.reconnect();
            disp("Reconnected to broker.");
        catch ME
            warning("Failed to reconnect: %s", ME.message);
            break;
        end
    end

    % Try publishing the message
    try
        mqttClient.publish(topic, message);
        fprintf("Published message %d: %s\n", i, jsonMessage);
    catch ME
        warning("Failed to publish message %d: %s", i, ME.message);
        pause(1);  % Wait for a second before retrying
    end
    
    pause(0.1); % Small delay between messages
end

% Disconnect and clean up
try
    mqttClient.disconnect();
    mqttClient.close();
    disp("Disconnected and cleaned up.");
catch ME
    warning("Failed to disconnect: %s", ME.message);
end
