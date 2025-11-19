import React, { useState } from "react";
import { View, Text, Button, StyleSheet, Alert } from "react-native";
import BLEService from "./services/BLEService";

export default function App() {
  const [status, setStatus] = useState("Not connected");

  const handleConnect = () => {
    setStatus("Scanning...");
    BLEService.startScan((device) => {
      if (!device) {
        setStatus("Lock not configured. Please update config/lockConfig.js");
        Alert.alert("Configuration Required", "Please configure your lock MAC address in config/lockConfig.js");
        return;
      }
      setStatus("Device found. Connecting...");
      BLEService.connectToLock((connected) => {
        if (connected) setStatus("Connected!");
        else setStatus("Failed to connect. Check lock configuration.");
      });
    });
  };

  const handleUnlock = () => {
    setStatus("Unlocking...");
    BLEService.unlock((ok) => {
      if (ok) {
        setStatus("Door unlocked!");
        Alert.alert("Success", "Door unlocked.");
      } else {
        setStatus("Unlock failed. Check lock configuration.");
        Alert.alert("Failure", "Unlock failed. Please configure lock credentials in config/lockConfig.js");
      }
    });
  };

  const handleLock = () => {
    setStatus("Locking...");
    BLEService.lock((ok) => {
      if (ok) {
        setStatus("Door locked!");
        Alert.alert("Success", "Door locked.");
      } else {
        setStatus("Lock failed. Check lock configuration.");
        Alert.alert("Failure", "Lock failed. Please configure lock credentials in config/lockConfig.js");
      }
    });
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>TTLock BLE MVP</Text>
      <Text style={styles.status}>{status}</Text>

      <Button title="Connect" onPress={handleConnect} />
      <View style={{ height: 20 }} />

      <Button title="Unlock" onPress={handleUnlock} />
      <View style={{ height: 20 }} />

      <Button title="Lock" onPress={handleLock} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 40,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#ffffff",
  },
  title: {
    fontSize: 22,
    fontWeight: "700",
    marginBottom: 20,
  },
  status: {
    marginBottom: 30,
    fontSize: 16,
  },
});
